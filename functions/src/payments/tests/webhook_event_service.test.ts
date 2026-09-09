import {
  beforeEach,
  describe,
  expect,
  it,
} from "vitest";
import {
  WebhookEventService,
  WebhookEventStatus,
} from "../webhooks/webhook_event_service";

import { createMockFirestore } from "./mock_firestore";

describe("WebhookEventService", () => {
  const eventId = "event-123";

  let firestore: ReturnType<typeof createMockFirestore>;

  let service: WebhookEventService;

  beforeEach(() => {
    firestore = createMockFirestore();
    service = new WebhookEventService(firestore as any,);
  });

  describe("startProcessing", () => {
    it("creates a processing event for a new webhook", async () => {
      const result =
        await service.startProcessing(eventId);

      expect(result).toBe(true);

      const event = firestore.get(
        `paymentWebhookEvents/${eventId}`,
      );

      expect(event).toMatchObject({
        eventId,
        status:
          WebhookEventStatus.processing,
        attempts: 1,
        processedAt: null,
        lastError: null,
      });

      expect(
        event?.processingStartedAt,
      ).toBeDefined();
    });

    it("does not process an already processed event", async () => {
      firestore.seed(
        `paymentWebhookEvents/${eventId}`,
        {
          eventId,
          status:
            WebhookEventStatus.processed,
          attempts: 1,
          processedAt: new Date(),
          processingStartedAt: null,
          lastError: null,
        },
      );

      const result =
        await service.startProcessing(eventId);

      expect(result).toBe(false);

      const event = firestore.get(
        `paymentWebhookEvents/${eventId}`,
      );

      expect(event?.attempts).toBe(1);
      expect(event?.status).toBe(
        WebhookEventStatus.processed,
      );
    });

    it("does not take over an active processing lease", async () => {
      firestore.seed(
        `paymentWebhookEvents/${eventId}`,
        {
          eventId,
          status: WebhookEventStatus.processing,
          attempts: 1,
          processingStartedAt: new Date(),
          processedAt: null,
          lastError: null,
        },
      );

      const result = await service.startProcessing(eventId);

      expect(result).toBe(false);

      const event = firestore.get(`paymentWebhookEvents/${eventId}`,);

      expect(event?.attempts).toBe(1);
      expect(event?.status).toBe(WebhookEventStatus.processing,);
    });

    it("takes over an expired processing lease", async () => {
      const expiredAt = new Date(
        Date.now() - 6 * 60 * 1000,
      );

      firestore.seed(
        `paymentWebhookEvents/${eventId}`,
        {
          eventId,
          status:
            WebhookEventStatus.processing,
          attempts: 1,
          processingStartedAt: expiredAt,
          processedAt: null,
          lastError: null,
        },
      );

      const result =
        await service.startProcessing(eventId);

      expect(result).toBe(true);

      const event = firestore.get(
        `paymentWebhookEvents/${eventId}`,
      );

      expect(event?.status).toBe(
        WebhookEventStatus.processing,
      );

      expect(event?.attempts).toBe(2);
      expect(event?.lastError).toBeNull();
    });

    it("retries a failed webhook", async () => {
      firestore.seed(
        `paymentWebhookEvents/${eventId}`,
        {
          eventId,
          status:
            WebhookEventStatus.failed,
          attempts: 1,
          processingStartedAt: null,
          processedAt: null,
          lastError:
            "Payment service unavailable.",
        },
      );

      const result =
        await service.startProcessing(eventId);

      expect(result).toBe(true);

      const event = firestore.get(
        `paymentWebhookEvents/${eventId}`,
      );

      expect(event?.status).toBe(
        WebhookEventStatus.processing,
      );

      expect(event?.attempts).toBe(2);
      expect(event?.lastError).toBeNull();
    });

    it("preserves the event ID during retry", async () => {
      firestore.seed(
        `paymentWebhookEvents/${eventId}`,
        {
          eventId,
          status:
            WebhookEventStatus.failed,
          attempts: 3,
          processingStartedAt: null,
          processedAt: null,
          lastError: "Previous failure.",
        },
      );

      await service.startProcessing(eventId);

      const event = firestore.get(
        `paymentWebhookEvents/${eventId}`,
      );

      expect(event?.eventId).toBe(eventId);
    });
  });

  describe("markProcessed", () => {
    it("marks a processing event as processed", async () => {
      firestore.seed(
        `paymentWebhookEvents/${eventId}`,
        {
          eventId,
          status:
            WebhookEventStatus.processing,
          attempts: 1,
          processingStartedAt: new Date(),
          processedAt: null,
          lastError: null,
        },
      );

      await service.markProcessed(eventId);

      const event = firestore.get(
        `paymentWebhookEvents/${eventId}`,
      );

      expect(event?.status).toBe(
        WebhookEventStatus.processed,
      );

      expect(event?.processingStartedAt).toBeNull();
      expect(event?.lastError).toBeNull();
      expect(event?.processedAt).toBeDefined();
    });
  });

  describe("markFailed", () => {
    it("marks a processing event as failed", async () => {
      firestore.seed(
        `paymentWebhookEvents/${eventId}`,
        {
          eventId,
          status:
            WebhookEventStatus.processing,
          attempts: 1,
          processingStartedAt: new Date(),
          processedAt: null,
          lastError: null,
        },
      );

      await service.markFailed(
        eventId,
        "Payment provider unavailable.",
      );

      const event = firestore.get(
        `paymentWebhookEvents/${eventId}`,
      );

      expect(event?.status).toBe(
        WebhookEventStatus.failed,
      );

      expect(event?.processingStartedAt).toBeNull();

      expect(event?.lastError).toBe(
        "Payment provider unavailable.",
      );
    });
  });
});
