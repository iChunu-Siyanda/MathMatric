import { describe, expect, it, vi, beforeEach } from "vitest";
import { MasterclassPaymentWebhookHandler } from "../../webhooks/masterclass_payment_webhook_handler";
import { PaymentWebhookEvent } from "../../provider/payment_provider";
import { MasterclassPaymentService } from "../../masterclasses/payment/masterclass_payment_service";
import { MasterclassPaymentSuccessService } from "../../masterclasses/payment/masterclass_payment_success_service";
import { WebhookEventService } from "../../webhooks/webhook_event_service";

describe("MasterclassPaymentWebhookHandler", () => {
  let masterclassPaymentService: MasterclassPaymentService;
  let masterclassPaymentSuccessService: MasterclassPaymentSuccessService;
  let webhookEventService: WebhookEventService;
  let handler: MasterclassPaymentWebhookHandler;

  beforeEach(() => {
    masterclassPaymentService = {
      markProcessing: vi.fn().mockResolvedValue(undefined),
      markFailed: vi.fn().mockResolvedValue(undefined),
    } as unknown as MasterclassPaymentService;

    masterclassPaymentSuccessService = {
      markPaymentPaid: vi.fn().mockResolvedValue({}),
    } as unknown as MasterclassPaymentSuccessService;

    webhookEventService = {
      startProcessing: vi.fn().mockResolvedValue(true),
      markProcessed: vi.fn().mockResolvedValue(undefined),
      markFailed: vi.fn().mockResolvedValue(undefined),
    } as unknown as WebhookEventService;

    handler = new MasterclassPaymentWebhookHandler({
      masterclassPaymentService,
      masterclassPaymentSuccessService,
      webhookEventService,
    });
  });

  function buildEvent(
    overrides: Partial<PaymentWebhookEvent> = {},
  ): PaymentWebhookEvent {
    return {
      eventId: "event-1",
      bookingId: "masterclass-1_student-1",
      providerPaymentId: "mock-masterclass-1_student-1",
      status: "paid",
      failureReason: null,
      occurredAt: new Date("2026-02-01T15:00:00.000Z"),
      ...overrides,
    };
  }

  it("processes a 'processing' event", async () => {
    const event = buildEvent({ status: "processing" });

    const result = await handler.handle(event);

    expect(result.statusCode).toBe(200);
    expect(result.message).toBe("Webhook processed.");

    expect(
      masterclassPaymentService.markProcessing,
    ).toHaveBeenCalledWith("masterclass-1_student-1");

    expect(webhookEventService.markProcessed).toHaveBeenCalledWith(
      "event-1",
    );
  });

  it("processes a 'paid' event via the success service", async () => {
    const event = buildEvent({ status: "paid" });

    const result = await handler.handle(event);

    expect(result.statusCode).toBe(200);

    expect(
      masterclassPaymentSuccessService.markPaymentPaid,
    ).toHaveBeenCalledWith({
      enrollmentId: "masterclass-1_student-1",
      providerPaymentId: "mock-masterclass-1_student-1",
      paidAt: event.occurredAt,
    });
  });

  it("processes a 'failed' event with the provided failure reason", async () => {
    const event = buildEvent({
      status: "failed",
      failureReason: "Card declined.",
    });

    await handler.handle(event);

    expect(
      masterclassPaymentService.markFailed,
    ).toHaveBeenCalledWith({
      enrollmentId: "masterclass-1_student-1",
      failureReason: "Card declined.",
    });
  });

  it("defaults the failure reason when none is provided", async () => {
    const event = buildEvent({
      status: "failed",
      failureReason: null,
    });

    await handler.handle(event);

    expect(
      masterclassPaymentService.markFailed,
    ).toHaveBeenCalledWith({
      enrollmentId: "masterclass-1_student-1",
      failureReason: "Masterclass payment failed.",
    });
  });

  it("is idempotent on replay of the same event ID", async () => {
    vi.mocked(
      webhookEventService.startProcessing,
    ).mockResolvedValueOnce(false);

    const event = buildEvent();

    const result = await handler.handle(event);

    expect(result.statusCode).toBe(200);
    expect(result.message).toBe("Already processed.");

    expect(
      masterclassPaymentSuccessService.markPaymentPaid,
    ).not.toHaveBeenCalled();
  });

  it("marks the webhook event failed and rethrows when the underlying service call fails", async () => {
    vi.mocked(
      masterclassPaymentSuccessService.markPaymentPaid,
    ).mockRejectedValueOnce(
      new Error("Enrollment does not exist."),
    );

    const event = buildEvent({ status: "paid" });

    await expect(handler.handle(event)).rejects.toThrow(
      "Enrollment does not exist.",
    );

    expect(webhookEventService.markFailed).toHaveBeenCalledWith(
      "event-1",
      "Enrollment does not exist.",
    );

    expect(webhookEventService.markProcessed).not.toHaveBeenCalled();
  });

  it("rejects an unsupported status and records failure", async () => {
    const event = {
      ...buildEvent(),
      status: "unknown",
    } as unknown as PaymentWebhookEvent;

    await expect(handler.handle(event)).rejects.toThrow(
      "Unsupported masterclass payment status.",
    );

    expect(webhookEventService.markFailed).toHaveBeenCalledWith(
      "event-1",
      "Unsupported masterclass payment status.",
    );
  });

  it("still rethrows even if recording the webhook failure itself throws", async () => {
    vi.mocked(
      masterclassPaymentService.markProcessing,
    ).mockRejectedValueOnce(
      new Error("Masterclass payment not found."),
    );

    vi.mocked(
      webhookEventService.markFailed,
    ).mockRejectedValueOnce(
      new Error("Firestore write failed."),
    );

    const event = buildEvent({ status: "processing" });

    await expect(handler.handle(event)).rejects.toThrow(
      "Masterclass payment not found.",
    );
  });
});
