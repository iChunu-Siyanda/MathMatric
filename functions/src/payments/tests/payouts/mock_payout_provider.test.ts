import { describe, expect, it } from "vitest";

import { MockPayoutProvider } from "../../provider/mock_payout_provider";
import { ProviderValidator } from "../../provider/provider_validator";

describe("MockPayoutProvider", () => {
  const provider = new MockPayoutProvider();

  describe("name", () => {
    it("exposes the mock provider name", () => {
      expect(provider.name).toBe("mock");
    });
  });

  describe("createPayout", () => {
    it("creates a payout with a deterministic provider payout ID", async () => {
      const result = await provider.createPayout({
        amountCents: 40000,
        currency: "ZAR",
        payoutId: "payout-booking-123",
        tutorId: "tutor-123",
      });

      expect(result).toEqual({
        providerPayoutId:
          "mock-payout-payout-booking-123",
      });
    });

    it("returns the same provider payout ID for the same payout ID", async () => {
      const first =
        await provider.createPayout({
          amountCents: 40000,
          currency: "ZAR",
          payoutId: "payout-booking-123",
          tutorId: "tutor-123",
        });

      const second =
        await provider.createPayout({
          amountCents: 40000,
          currency: "ZAR",
          payoutId: "payout-booking-123",
          tutorId: "tutor-123",
        });

      expect(second).toEqual(first);
    });

    it("accepts a positive integer amount", async () => {
      await expect(
        provider.createPayout({
          amountCents: 1,
          currency: "ZAR",
          payoutId: "payout-1",
          tutorId: "tutor-1",
        }),
      ).resolves.toEqual({
        providerPayoutId: "mock-payout-payout-1",
      });
    });

    it("rejects a zero amount", async () => {
      await expect(
        provider.createPayout({
          amountCents: 0,
          currency: "ZAR",
          payoutId: "payout-1",
          tutorId: "tutor-1",
        }),
      ).rejects.toThrow(
        "Amount must be a positive integer.",
      );
    });

    it("rejects a negative amount", async () => {
      await expect(
        provider.createPayout({
          amountCents: -1,
          currency: "ZAR",
          payoutId: "payout-1",
          tutorId: "tutor-1",
        }),
      ).rejects.toThrow(
        "Amount must be a positive integer.",
      );
    });

    it("rejects a fractional amount", async () => {
      await expect(
        provider.createPayout({
          amountCents: 100.5,
          currency: "ZAR",
          payoutId: "payout-1",
          tutorId: "tutor-1",
        }),
      ).rejects.toThrow(
        "Amount must be a positive integer.",
      );
    });

    it("rejects an unsupported currency", async () => {
      await expect(
        provider.createPayout({
          amountCents: 40000,
          currency: "USD" as "ZAR",
          payoutId: "payout-1",
          tutorId: "tutor-1",
        }),
      ).rejects.toThrow(
        "Unsupported currency.",
      );
    });

    it("rejects an empty payout ID", async () => {
      await expect(
        provider.createPayout({
          amountCents: 40000,
          currency: "ZAR",
          payoutId: "",
          tutorId: "tutor-1",
        }),
      ).rejects.toThrow(
        "Payout ID cannot be empty.",
      );
    });

    it("rejects a whitespace-only payout ID", async () => {
      await expect(
        provider.createPayout({
          amountCents: 40000,
          currency: "ZAR",
          payoutId: "   ",
          tutorId: "tutor-1",
        }),
      ).rejects.toThrow(
        "Payout ID cannot be empty.",
      );
    });

    it("rejects an empty tutor ID", async () => {
      await expect(
        provider.createPayout({
          amountCents: 40000,
          currency: "ZAR",
          payoutId: "payout-1",
          tutorId: "",
        }),
      ).rejects.toThrow(
        "Tutor ID cannot be empty.",
      );
    });

    it("rejects a whitespace-only tutor ID", async () => {
      await expect(
        provider.createPayout({
          amountCents: 40000,
          currency: "ZAR",
          payoutId: "payout-1",
          tutorId: "   ",
        }),
      ).rejects.toThrow(
        "Tutor ID cannot be empty.",
      );
    });
  });

  describe("verifyWebhook", () => {
    it("verifies a processing webhook", () => {
      const occurredAt =
        "2026-01-15T10:00:00.000Z";

      const result =
        provider.verifyWebhook(
          JSON.stringify({
            providerPayoutId:
              "mock-payout-payout-123",
            payoutId: "payout-123",
            status: "processing",
            failureReason: null,
            eventId: "event-123",
            occurredAt,
          }),
          "test-signature",
        );

      expect(result).toEqual({
        providerPayoutId:
          "mock-payout-payout-123",
        payoutId: "payout-123",
        status: "processing",
        failureReason: null,
        eventId: "event-123",
        occurredAt: new Date(occurredAt),
      });
    });

    it("verifies a succeeded webhook", () => {
      const occurredAt =
        "2026-01-15T11:00:00.000Z";

      const result =
        provider.verifyWebhook(
          JSON.stringify({
            providerPayoutId:
              "mock-payout-payout-123",
            payoutId: "payout-123",
            status: "succeeded",
            failureReason: null,
            eventId: "event-456",
            occurredAt,
          }),
          "test-signature",
        );

      expect(result.status).toBe("succeeded");
      expect(result.providerPayoutId).toBe(
        "mock-payout-payout-123",
      );
      expect(result.payoutId).toBe(
        "payout-123",
      );
      expect(result.eventId).toBe(
        "event-456",
      );
      expect(result.failureReason).toBeNull();
      expect(result.occurredAt).toEqual(
        new Date(occurredAt),
      );
    });

    it("verifies a failed webhook with a failure reason", () => {
      const occurredAt =
        "2026-01-15T12:00:00.000Z";

      const result =
        provider.verifyWebhook(
          JSON.stringify({
            providerPayoutId:
              "mock-payout-payout-123",
            payoutId: "payout-123",
            status: "failed",
            failureReason:
              "Beneficiary account rejected.",
            eventId: "event-789",
            occurredAt,
          }),
          "test-signature",
        );

      expect(result).toEqual({
        providerPayoutId:
          "mock-payout-payout-123",
        payoutId: "payout-123",
        status: "failed",
        failureReason:
          "Beneficiary account rejected.",
        eventId: "event-789",
        occurredAt: new Date(occurredAt),
      });
    });

    it("converts an omitted failure reason to null", () => {
      const result =
        provider.verifyWebhook(
          JSON.stringify({
            providerPayoutId:
              "mock-payout-payout-123",
            payoutId: "payout-123",
            status: "failed",
            eventId: "event-123",
            occurredAt:
              "2026-01-15T12:00:00.000Z",
          }),
          "test-signature",
        );

      expect(result.failureReason).toBeNull();
    });

    it("rejects an invalid signature", () => {
      expect(() =>
        provider.verifyWebhook(
          JSON.stringify({
            providerPayoutId:
              "mock-payout-payout-123",
            payoutId: "payout-123",
            status: "succeeded",
            eventId: "event-123",
            occurredAt:
              "2026-01-15T12:00:00.000Z",
          }),
          "invalid-signature",
        ),
      ).toThrow(
        "Invalid webhook signature.",
      );
    });

    it("rejects a missing occurredAt", () => {
      expect(() =>
        provider.verifyWebhook(
          JSON.stringify({
            providerPayoutId:
              "mock-payout-payout-123",
            payoutId: "payout-123",
            status: "succeeded",
            eventId: "event-123",
          }),
          "test-signature",
        ),
      ).toThrow(
        "Webhook occurredAt is required.",
      );
    });

    it("rejects an invalid occurredAt", () => {
      expect(() =>
        provider.verifyWebhook(
          JSON.stringify({
            providerPayoutId:
              "mock-payout-payout-123",
            payoutId: "payout-123",
            status: "succeeded",
            eventId: "event-123",
            occurredAt: "not-a-date",
          }),
          "test-signature",
        ),
      ).toThrow(
        "Webhook occurredAt is invalid.",
      );
    });

    it("preserves the webhook event identity fields", () => {
      const result =
        provider.verifyWebhook(
          JSON.stringify({
            providerPayoutId:
              "provider-payout-999",
            payoutId: "payout-999",
            status: "processing",
            failureReason: null,
            eventId: "webhook-event-999",
            occurredAt:
              "2026-02-01T08:30:00.000Z",
          }),
          "test-signature",
        );

      expect(result.providerPayoutId).toBe(
        "provider-payout-999",
      );
      expect(result.payoutId).toBe(
        "payout-999",
      );
      expect(result.eventId).toBe(
        "webhook-event-999",
      );
    });
  });

  describe("validateProviderPayoutId", () => {
    it("accepts a valid provider payout ID", () => {
        expect(() =>
        ProviderValidator.validateProviderPayoutId(
            "peach-payout-123",
        ),
        ).not.toThrow();
    });

    it("rejects an empty provider payout ID", () => {
        expect(() =>
        ProviderValidator.validateProviderPayoutId(
            "",
        ),
        ).toThrow(
        "Provider payout ID is required.",
        );
    });

    it("rejects a whitespace-only provider payout ID", () => {
        expect(() =>
        ProviderValidator.validateProviderPayoutId(
            "   ",
        ),
        ).toThrow(
        "Provider payout ID is required.",
        );
    });
    });
});
