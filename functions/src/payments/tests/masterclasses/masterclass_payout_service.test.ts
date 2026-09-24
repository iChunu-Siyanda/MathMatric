import { Firestore } from "firebase-admin/firestore";
import { beforeEach, describe, expect, it, vi } from "vitest";
import {
  MasterclassPayoutService,
  MasterclassPayoutInitiationInProgressError,
} from "../../masterclasses/payout/masterclass_payout_service";
import { MasterclassPayoutStatus} from "../../masterclasses/payout/masterclass_payout_entity";
import { MasterclassPayoutEligibilityService } from "../../masterclasses/payout/masterclass_payout_eligibility_service";
import { MasterclassEnrollment, MasterclassEnrollmentStatus } from "../../masterclasses/enrollment/masterclass_enrollment_entity";
import { MasterclassPayment, MasterclassPaymentStatus } from "../../masterclasses/payment/masterclass_payment_entity";
import { TwentyPercentPlatformFeeCalculator } from "../../payout/platform_fee_calculator";
import { TransactionReferenceIdentity } from "../../transactions/transaction_reference_identity";
import { TransactionService } from "../../transactions/transaction_service";
import { TransactionStatus } from "../../transactions/transaction";
import { MockPayoutProvider } from "../../provider/mock_payout_provider";
import { PayoutProvider, PayoutProviderOutcomeUnknownError } from "../../provider/payout_provider";
import { PayoutProviderIdentity } from "../../provider/payout_provider_identity";
import { createMockFirestore } from "../../tests/mock_firestore";

class SpyPayoutProvider extends MockPayoutProvider {
  createPayout = vi.fn(
    async (params: {
      amountCents: number;
      currency: "ZAR";
      payoutId: string;
      tutorId: string;
    }) => {
      return super.createPayout(params);
    },
  );
}

describe("MasterclassPayoutService", () => {
  let firestore: Firestore;
  let mockFirestore: ReturnType<typeof createMockFirestore>;
  let transactionService: TransactionService;
  let eligibilityService: MasterclassPayoutEligibilityService;
  let payoutProvider: MockPayoutProvider;
  let payoutProviderIdentity: PayoutProviderIdentity;
  let service: MasterclassPayoutService;

  const enrollmentId = "masterclass-1_student-1";
  const payoutId = `masterclass-payout-${enrollmentId}`;

  function createEnrollment(
    overrides: Partial<MasterclassEnrollment> = {},
  ): MasterclassEnrollment {
    return {
      id: enrollmentId,
      masterclassId: "masterclass-1",
      studentId: "student-1",
      tutorId: "tutor-1",

      priceCents: 15000,
      currency: "ZAR",

      status: MasterclassEnrollmentStatus.confirmed,

      downloadedAt: new Date("2026-02-01T11:00:00.000Z"),

      enrolledAt: new Date("2026-02-01T10:00:00.000Z"),
      updatedAt: new Date("2026-02-01T10:00:00.000Z"),
      cancelledAt: null,
      refundedAt: null,

      ...overrides,
    };
  }

  function createPayment(
    overrides: Partial<MasterclassPayment> = {},
  ): MasterclassPayment {
    return {
      id: enrollmentId,
      enrollmentId,
      masterclassId: "masterclass-1",
      studentId: "student-1",
      tutorId: "tutor-1",

      amountCents: 15000,
      currency: "ZAR",

      status: MasterclassPaymentStatus.paid,

      provider: "mock",
      providerPaymentId: `mock-${enrollmentId}`,

      createdAt: new Date("2026-02-01T10:00:00.000Z"),
      updatedAt: new Date("2026-02-01T10:05:00.000Z"),

      paidAt: new Date("2026-02-01T10:05:00.000Z"),

      failureReason: null,

      ...overrides,
    };
  }

  function buildService(
    provider: PayoutProvider,
  ): MasterclassPayoutService {
    const identity = new PayoutProviderIdentity(
      firestore,
      provider,
    );

    return new MasterclassPayoutService(
      firestore,
      eligibilityService,
      transactionService,
      provider,
      identity,
    );
  }

  beforeEach(() => {
    mockFirestore = createMockFirestore();
    firestore = mockFirestore as unknown as Firestore;

    const referenceIdentity =
      new TransactionReferenceIdentity(firestore);

    transactionService = new TransactionService(
      firestore,
      referenceIdentity,
    );

    eligibilityService = new MasterclassPayoutEligibilityService(
      new TwentyPercentPlatformFeeCalculator(),
    );

    payoutProvider = new MockPayoutProvider();

    payoutProviderIdentity = new PayoutProviderIdentity(
      firestore,
      payoutProvider,
    );

    service = new MasterclassPayoutService(
      firestore,
      eligibilityService,
      transactionService,
      payoutProvider,
      payoutProviderIdentity,
    );
  });

  // ==================================================
  // createPayout
  // ==================================================

  describe("createPayout", () => {
    it("creates a pending payout and ledger transaction", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const result = await service.createPayout({
        enrollment,
        payment,
      });

      expect(result.created).toBe(true);
      expect(result.payout.id).toBe(payoutId);
      expect(result.payout.enrollmentId).toBe(enrollmentId);
      expect(result.payout.paymentId).toBe(payment.id);
      expect(result.payout.tutorId).toBe("tutor-1");
      expect(result.payout.amountCents).toBe(12000);
      expect(result.payout.status).toBe(
        MasterclassPayoutStatus.pending,
      );

      const storedPayout = mockFirestore.get(
        `masterclassPayouts/${payoutId}`,
      );

      expect(storedPayout).toBeDefined();

      const storedTransaction = mockFirestore.get(
        `transactions/masterclass-payout-${payoutId}`,
      );

      expect(storedTransaction).toBeDefined();
      expect(storedTransaction?.status).toBe(
        TransactionStatus.pending,
      );
    });

    it("is idempotent when the payout already exists", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const first = await service.createPayout({
        enrollment,
        payment,
      });

      const second = await service.createPayout({
        enrollment,
        payment,
      });

      expect(first.created).toBe(true);
      expect(second.created).toBe(false);
      expect(second.payout.id).toBe(first.payout.id);
      expect(second.payout.amountCents).toBe(
        first.payout.amountCents,
      );
    });
  });

  // ==================================================
  // attachProviderPayoutId
  // ==================================================

  describe("attachProviderPayoutId", () => {
    it("attaches the provider payout ID", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await service.attachProviderPayoutId(
        payout.id,
        "mock-provider-payout-1",
      );

      const stored = mockFirestore.get(
        `masterclassPayouts/${payout.id}`,
      );

      expect(stored?.provider).toBe("mock");
      expect(stored?.providerPayoutId).toBe(
        "mock-provider-payout-1",
      );
    });

    it("is idempotent when the same provider payout ID is attached", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await service.attachProviderPayoutId(
        payout.id,
        "mock-provider-payout-1",
      );

      await expect(
        service.attachProviderPayoutId(
          payout.id,
          "mock-provider-payout-1",
        ),
      ).resolves.toBeUndefined();
    });

    it("rejects a different provider payout ID", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await service.attachProviderPayoutId(
        payout.id,
        "mock-provider-payout-1",
      );

      await expect(
        service.attachProviderPayoutId(
          payout.id,
          "mock-provider-payout-2",
        ),
      ).rejects.toThrow(
        "Masterclass payout is already associated with a different provider payout ID.",
      );
    });

    it("rejects a provider payout ID already associated with another payout", async () => {
      const enrollment1 = createEnrollment();
      const payment1 = createPayment();

      const first = await service.createPayout({
        enrollment: enrollment1,
        payment: payment1,
      });

      const enrollment2 = createEnrollment({
        id: "masterclass-1_student-2",
        studentId: "student-2",
      });

      const payment2 = createPayment({
        id: "masterclass-1_student-2",
        enrollmentId: "masterclass-1_student-2",
        studentId: "student-2",
      });

      const second = await service.createPayout({
        enrollment: enrollment2,
        payment: payment2,
      });

      await service.attachProviderPayoutId(
        first.payout.id,
        "mock-provider-payout-collision",
      );

      await expect(
        service.attachProviderPayoutId(
          second.payout.id,
          "mock-provider-payout-collision",
        ),
      ).rejects.toThrow(
        "Provider payout ID is already associated with another payout.",
      );
    });
  });

  // ==================================================
  // initiatePayout
  // ==================================================

  describe("initiatePayout", () => {
    it("initiates the payout and attaches the provider payout ID", async () => {
      const spyProvider = new SpyPayoutProvider();

      service = buildService(spyProvider);

      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      const result = await service.initiatePayout(payout.id);

      expect(spyProvider.createPayout).toHaveBeenCalledTimes(1);

      expect(spyProvider.createPayout).toHaveBeenCalledWith({
        amountCents: 12000,
        currency: "ZAR",
        payoutId: payout.id,
        tutorId: "tutor-1",
      });

      expect(result.status).toBe(MasterclassPayoutStatus.processing);
      expect(result.provider).toBe("mock");
      expect(result.providerPayoutId).toBe(
        `mock-payout-${payout.id}`,
      );
    });

    it("is idempotent when the provider payout ID already exists", async () => {
      const spyProvider = new SpyPayoutProvider();

      service = buildService(spyProvider);

      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await service.attachProviderPayoutId(
        payout.id,
        "mock-payout-existing",
      );

      const result = await service.initiatePayout(payout.id);

      expect(spyProvider.createPayout).not.toHaveBeenCalled();
      expect(result.providerPayoutId).toBe("mock-payout-existing");
    });

    it("rejects a missing payout", async () => {
      await expect(
        service.initiatePayout("does-not-exist"),
      ).rejects.toThrow("Masterclass payout does not exist.");
    });

    it("marks the payout failed when provider initiation fails", async () => {
      const failingProvider: PayoutProvider = {
        name: "mock",
        createPayout: vi.fn(async () => {
          throw new Error("Provider payout failed.");
        }),
        verifyWebhook: vi.fn(() => {
          throw new Error("Not used in this test.");
        }),
      };

      service = buildService(failingProvider);

      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await expect(
        service.initiatePayout(payout.id),
      ).rejects.toThrow("Provider payout failed.");

      const stored = mockFirestore.get(
        `masterclassPayouts/${payout.id}`,
      );

      expect(stored?.status).toBe(MasterclassPayoutStatus.failed);
      expect(stored?.failureReason).toBe(
        "Provider payout failed.",
      );
    });

    it("leaves the payout processing and does not mark it failed when the provider outcome is unknown", async () => {
      const timeoutProvider: PayoutProvider = {
        name: "mock",
        createPayout: vi.fn(async () => {
          throw new PayoutProviderOutcomeUnknownError(
            "Provider request timed out.",
          );
        }),
        verifyWebhook: vi.fn(() => {
          throw new Error("Not used in this test.");
        }),
      };

      service = buildService(timeoutProvider);

      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await expect(
        service.initiatePayout(payout.id),
      ).rejects.toThrow("Provider request timed out.");

      const stored = mockFirestore.get(
        `masterclassPayouts/${payout.id}`,
      );

      expect(stored?.status).toBe(MasterclassPayoutStatus.processing);
      expect(stored?.providerPayoutId).toBeNull();
      expect(stored?.failureReason).toBeNull();
    });

    it("rejects a payout that is already processing (in-progress claim)", async () => {
      const spyProvider = new SpyPayoutProvider();

      service = buildService(spyProvider);

      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await service.markProcessing(payout.id);

      await expect(
        service.initiatePayout(payout.id),
      ).rejects.toThrow(
        MasterclassPayoutInitiationInProgressError,
      );

      expect(spyProvider.createPayout).not.toHaveBeenCalled();
    });
  });

  // ==================================================
  // retryPayout
  // ==================================================

  describe("retryPayout", () => {
    it("resets a failed payout with no provider payout ID back to pending", async () => {
      const failingProvider: PayoutProvider = {
        name: "mock",
        createPayout: vi.fn(async () => {
          throw new Error("Provider payout failed.");
        }),
        verifyWebhook: vi.fn(() => {
          throw new Error("Not used in this test.");
        }),
      };

      service = buildService(failingProvider);

      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await expect(
        service.initiatePayout(payout.id),
      ).rejects.toThrow("Provider payout failed.");

      const result = await service.retryPayout(payout.id);

      expect(result.status).toBe(MasterclassPayoutStatus.pending);
      expect(result.failureReason).toBeNull();

      const transaction = mockFirestore.get(
        `transactions/masterclass-payout-${payout.id}`,
      );

      expect(transaction?.status).toBe(TransactionStatus.pending);
    });

    it("is idempotent on an already-pending payout", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      const first = await service.retryPayout(payout.id);
      const second = await service.retryPayout(payout.id);

      expect(first.status).toBe(MasterclassPayoutStatus.pending);
      expect(second.status).toBe(MasterclassPayoutStatus.pending);
    });

    it("rejects retry on a processing payout", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await service.markProcessing(payout.id);

      await expect(
        service.retryPayout(payout.id),
      ).rejects.toThrow(
        "Cannot retry a masterclass payout that is currently processing.",
      );
    });

    it("rejects retry on a failed payout that already has a provider payout ID attached", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await service.attachProviderPayoutId(
        payout.id,
        "mock-provider-payout-orphan",
      );

      await service.markFailed(
        payout.id,
        "Simulated post-attach failure.",
      );

      await expect(
        service.retryPayout(payout.id),
      ).rejects.toThrow(
        "Masterclass payout already has a provider payout ID attached and cannot be retried automatically. Resolve via reconciliation.",
      );
    });

    it("allows initiatePayout to succeed again after a successful retry", async () => {
      const flakyProvider = new SpyPayoutProvider();

      flakyProvider.createPayout.mockImplementationOnce(
        async () => {
          throw new Error("Provider payout failed.");
        },
      );

      service = buildService(flakyProvider);

      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await expect(
        service.initiatePayout(payout.id),
      ).rejects.toThrow("Provider payout failed.");

      await service.retryPayout(payout.id);

      const result = await service.initiatePayout(payout.id);

      expect(flakyProvider.createPayout).toHaveBeenCalledTimes(2);
      expect(result.status).toBe(MasterclassPayoutStatus.processing);
      expect(result.providerPayoutId).toBe(
        `mock-payout-${payout.id}`,
      );
    });
  });

  // ==================================================
  // markStuck
  // ==================================================

  describe("markStuck", () => {
    it("marks a processing payout with no provider payout ID as stuck", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await service.markProcessing(payout.id);

      const result = await service.markStuck(payout.id);

      expect(result.status).toBe(MasterclassPayoutStatus.stuck);
    });

    it("is idempotent when already stuck", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await service.markProcessing(payout.id);
      await service.markStuck(payout.id);

      const result = await service.markStuck(payout.id);

      expect(result.status).toBe(MasterclassPayoutStatus.stuck);
    });

    it("rejects a payout that is not processing", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await expect(
        service.markStuck(payout.id),
      ).rejects.toThrow(
        "Only a processing masterclass payout can be marked stuck.",
      );
    });

    it("rejects a processing payout that already has a provider payout ID attached", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await service.attachProviderPayoutId(
        payout.id,
        "mock-provider-payout-in-flight",
      );

      await service.markProcessing(
        payout.id,
        "mock-provider-payout-in-flight",
      );

      await expect(
        service.markStuck(payout.id),
      ).rejects.toThrow(
        "Masterclass payout has a provider payout ID attached and is not stuck; it is awaiting a provider webhook.",
      );
    });
  });

  // ==================================================
  // resolveStuckPayoutAsFailed
  // ==================================================

  describe("resolveStuckPayoutAsFailed", () => {
    it("resets a stuck payout to pending with a failure note", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await service.markProcessing(payout.id);
      await service.markStuck(payout.id);

      const result = await service.resolveStuckPayoutAsFailed(
        payout.id,
        "Confirmed with provider support: never received.",
      );

      expect(result.status).toBe(MasterclassPayoutStatus.pending);
      expect(result.failureReason).toContain(
        "Confirmed with provider support",
      );

      const transaction = mockFirestore.get(
        `transactions/masterclass-payout-${payout.id}`,
      );

      expect(transaction?.status).toBe(TransactionStatus.pending);
    });

    it("rejects a payout that is not stuck", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await expect(
        service.resolveStuckPayoutAsFailed(payout.id, "note"),
      ).rejects.toThrow(
        "Only a stuck masterclass payout can be resolved as failed.",
      );
    });

    it("rejects an empty resolution note", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await service.markProcessing(payout.id);
      await service.markStuck(payout.id);

      await expect(
        service.resolveStuckPayoutAsFailed(payout.id, "   "),
      ).rejects.toThrow("Resolution note cannot be empty.");
    });
  });

  // ==================================================
  // resolveStuckPayoutAsSucceeded
  // ==================================================

  describe("resolveStuckPayoutAsSucceeded", () => {
    it("resolves a stuck payout as succeeded and attaches the confirmed provider payout ID", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await service.markProcessing(payout.id);
      await service.markStuck(payout.id);

      const result = await service.resolveStuckPayoutAsSucceeded(
        payout.id,
        "mock-provider-payout-confirmed-1",
      );

      expect(result.status).toBe(MasterclassPayoutStatus.succeeded);
      expect(result.providerPayoutId).toBe(
        "mock-provider-payout-confirmed-1",
      );

      const transaction = mockFirestore.get(
        `transactions/masterclass-payout-${payout.id}`,
      );

      expect(transaction?.status).toBe(TransactionStatus.completed);

      const identity = mockFirestore.get(
        "payoutProviderIds/mock:mock-provider-payout-confirmed-1",
      );

      expect(identity).toBeDefined();
    });

    it("rejects a payout that is not stuck", async () => {
      const enrollment = createEnrollment();
      const payment = createPayment();

      const { payout } = await service.createPayout({
        enrollment,
        payment,
      });

      await expect(
        service.resolveStuckPayoutAsSucceeded(
          payout.id,
          "mock-provider-payout-x",
        ),
      ).rejects.toThrow(
        "Only a stuck masterclass payout can be resolved as succeeded.",
      );
    });

    it("rejects a provider payout ID already claimed by another payout", async () => {
      const enrollment1 = createEnrollment();
      const payment1 = createPayment();

      const first = await service.createPayout({
        enrollment: enrollment1,
        payment: payment1,
      });

      await service.attachProviderPayoutId(
        first.payout.id,
        "mock-provider-payout-collision-stuck",
      );

      const enrollment2 = createEnrollment({
        id: "masterclass-1_student-2",
        studentId: "student-2",
      });

      const payment2 = createPayment({
        id: "masterclass-1_student-2",
        enrollmentId: "masterclass-1_student-2",
        studentId: "student-2",
      });

      const second = await service.createPayout({
        enrollment: enrollment2,
        payment: payment2,
      });

      await service.markProcessing(second.payout.id);
      await service.markStuck(second.payout.id);

      await expect(
        service.resolveStuckPayoutAsSucceeded(
          second.payout.id,
          "mock-provider-payout-collision-stuck",
        ),
      ).rejects.toThrow(
        "Provider payout ID is already associated with another payout.",
      );
    });
  });
});
