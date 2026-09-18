import {
  describe,
  expect,
  it,
  beforeEach,
  vi,
} from "vitest";

import { Timestamp } from "firebase-admin/firestore";

import { db } from "../../../shared/firebase";

import {
  PayoutStatus,
} from "../../payout/payout_entity";

import {
  PayoutService,
} from "../../payout/payout_service";

import {
  TutorPayoutEligibilityService,
} from "../../payout/tutor_payout_eligibility_service";

import {
  TwentyPercentPlatformFeeCalculator,
} from "../../payout/platform_fee_calculator";

import {
  PayoutTransactionService,
} from "../../transactions/payout_transaction_service";

import {
  TransactionService,
} from "../../transactions/transaction_service";

import {
  TransactionReferenceIdentity,
} from "../../transactions/transaction_reference_identity";

import {
  TransactionStatus,
} from "../../transactions/transaction";

import {
  MockPayoutProvider,
} from "../../provider/mock_payout_provider";

import {
  PayoutProviderIdentity,
} from "../../provider/payout_provider_identity";

import {
  PayoutWebhookEvent,
} from "../../provider/payout_provider";

import {
  WebhookEventService,
  WebhookEventStatus,
} from "../../webhooks/webhook_event_service";

import {
  PayoutWebhookHandler,
} from "../../webhooks/payout_webhook_handler";

import { Payment, PaymentStatus } from "../../payment/payment_entity";


async function clearCollection(
  collectionName: string,
): Promise<void> {
  const snapshot =
    await db
      .collection(collectionName)
      .get();

  if (snapshot.empty) {
    return;
  }

  const batch = db.batch();

  for (const document of snapshot.docs) {
    batch.delete(document.ref);
  }

  await batch.commit();
}


async function seedEligiblePayout(): Promise<{
  booking: {
    id: string;
    studentId: string;
    tutorId: string;
    priceCents: number;
    status: "completed";
  };
  payment: Payment;
}> {
  const booking = {
    id: "booking-webhook-123",
    studentId: "student-123",
    tutorId: "tutor-123",
    priceCents: 50000,
    status: "completed" as const,
  };

  const payment: Payment = {
    id: "booking-webhook-123",
    bookingId: "booking-webhook-123",
    studentId: "student-123",
    tutorId: "tutor-123",

    amountCents: 50000,
    refundedAmountCents: 0,
    refundReservedAmountCents: 0,

    currency: "ZAR",

    status: PaymentStatus.paid,

    provider: "mock",
    providerPaymentId: "mock-booking-webhook-123",

    createdAt: new Date(),
    updatedAt: new Date(),

    paidAt: new Date(),
    failureReason: null,
  };

  return { booking, payment };
}


describe(
  "PayoutWebhookHandler",
  () => {
    let payoutService: PayoutService;
    let webhookEventService: WebhookEventService;
    let handler: PayoutWebhookHandler;

    beforeEach(async () => {
      await clearCollection("tutorPayouts");
      await clearCollection("transactions");
      await clearCollection("transactionReferences");
      await clearCollection("payoutProviderIds");
      await clearCollection("payoutWebhookEvents");

      const referenceIdentity =
        new TransactionReferenceIdentity(db);

      const transactionService =
        new TransactionService(
          db,
          referenceIdentity,
        );

      const payoutTransactionService =
        new PayoutTransactionService(
          db,
          transactionService,
        );

      const feeCalculator =
        new TwentyPercentPlatformFeeCalculator();

      const eligibilityService =
        new TutorPayoutEligibilityService(
          feeCalculator,
        );

      const payoutProvider =
        new MockPayoutProvider();

      const payoutProviderIdentity =
        new PayoutProviderIdentity(
          db,
          payoutProvider,
        );

      payoutService =
        new PayoutService(
          db,
          eligibilityService,
          payoutTransactionService,
          payoutProvider,
          payoutProviderIdentity,
        );

      webhookEventService =
        new WebhookEventService(
          db,
          "payoutWebhookEvents",
        );

      handler =
        new PayoutWebhookHandler({
          payoutService,
          webhookEventService,
        });
    });


    async function createAttachedPayout(
      providerPayoutId: string,
    ) {
      const { booking, payment } =
        await seedEligiblePayout();

      const { payout } =
        await payoutService.createPayout({
          booking,
          payment,
        });

      await payoutService
        .attachProviderPayoutId(
          payout.id,
          providerPayoutId,
        );

      return payout;
    }


    it(
      "processes a 'processing' event and moves the payout to processing",
      async () => {
        const payout =
          await createAttachedPayout(
            "mock-payout-processing-1",
          );

        const event: PayoutWebhookEvent = {
          providerPayoutId:
            "mock-payout-processing-1",
          payoutId: payout.id,
          status: "processing",
          failureReason: null,
          eventId: "evt-processing-1",
          occurredAt: new Date(),
        };

        const result =
          await handler.handle(event);

        expect(result.statusCode).toBe(200);

        const snapshot =
          await db
            .collection("tutorPayouts")
            .doc(payout.id)
            .get();

        expect(
          snapshot.data()?.status,
        ).toBe(
          PayoutStatus.processing,
        );

        const eventSnapshot =
          await db
            .collection("payoutWebhookEvents")
            .doc("evt-processing-1")
            .get();

        expect(
          eventSnapshot.data()?.status,
        ).toBe(
          WebhookEventStatus.processed,
        );
      },
    );


    it(
      "processes a 'succeeded' event and completes the payout and ledger",
      async () => {
        const payout =
          await createAttachedPayout(
            "mock-payout-succeeded-1",
          );

        await payoutService
          .markProcessing(payout.id);

        const event: PayoutWebhookEvent = {
          providerPayoutId:
            "mock-payout-succeeded-1",
          payoutId: payout.id,
          status: "succeeded",
          failureReason: null,
          eventId: "evt-succeeded-1",
          occurredAt: new Date(),
        };

        await handler.handle(event);

        const payoutSnapshot =
          await db
            .collection("tutorPayouts")
            .doc(payout.id)
            .get();

        expect(
          payoutSnapshot.data()?.status,
        ).toBe(
          PayoutStatus.succeeded,
        );

        const transactionSnapshot =
          await db
            .collection("transactions")
            .doc(`payout-${payout.id}`)
            .get();

        expect(
          transactionSnapshot.data()?.status,
        ).toBe(
          TransactionStatus.completed,
        );
      },
    );


    it(
      "processes a 'failed' event and fails the payout and ledger",
      async () => {
        const payout =
          await createAttachedPayout(
            "mock-payout-failed-1",
          );

        await payoutService
          .markProcessing(payout.id);

        const event: PayoutWebhookEvent = {
          providerPayoutId:
            "mock-payout-failed-1",
          payoutId: payout.id,
          status: "failed",
          failureReason:
            "Bank account rejected.",
          eventId: "evt-failed-1",
          occurredAt: new Date(),
        };

        await handler.handle(event);

        const payoutSnapshot =
          await db
            .collection("tutorPayouts")
            .doc(payout.id)
            .get();

        expect(
          payoutSnapshot.data()?.status,
        ).toBe(
          PayoutStatus.failed,
        );

        expect(
          payoutSnapshot.data()?.failureReason,
        ).toBe(
          "Bank account rejected.",
        );

        const transactionSnapshot =
          await db
            .collection("transactions")
            .doc(`payout-${payout.id}`)
            .get();

        expect(
          transactionSnapshot.data()?.status,
        ).toBe(
          TransactionStatus.failed,
        );
      },
    );


    it(
      "is idempotent on replay of the same event ID",
      async () => {
        const payout =
          await createAttachedPayout(
            "mock-payout-replay-1",
          );

        await payoutService
          .markProcessing(payout.id);

        const event: PayoutWebhookEvent = {
          providerPayoutId:
            "mock-payout-replay-1",
          payoutId: payout.id,
          status: "succeeded",
          failureReason: null,
          eventId: "evt-replay-1",
          occurredAt: new Date(),
        };

        const markSucceededSpy =
          vi.spyOn(
            payoutService,
            "markSucceeded",
          );

        const first =
          await handler.handle(event);

        const second =
          await handler.handle(event);

        expect(first.statusCode).toBe(200);
        expect(second.statusCode).toBe(200);
        expect(second.message).toBe(
          "Already processed.",
        );

        expect(
          markSucceededSpy,
        ).toHaveBeenCalledTimes(1);
      },
    );


    it(
      "retries after the processing lease has expired",
      async () => {
        const payout =
          await createAttachedPayout(
            "mock-payout-lease-1",
          );

        await payoutService
          .markProcessing(payout.id);

        const staleStart = new Date(
          Date.now() - 10 * 60 * 1000,
        );

        await db
          .collection("payoutWebhookEvents")
          .doc("evt-lease-1")
          .set({
            eventId: "evt-lease-1",
            status:
              WebhookEventStatus.processing,
            attempts: 1,
            processingStartedAt:
              Timestamp.fromDate(
                staleStart,
              ),
            createdAt:
              Timestamp.fromDate(
                staleStart,
              ),
            updatedAt:
              Timestamp.fromDate(
                staleStart,
              ),
            processedAt: null,
            lastError: null,
          });

        const event: PayoutWebhookEvent = {
          providerPayoutId:
            "mock-payout-lease-1",
          payoutId: payout.id,
          status: "succeeded",
          failureReason: null,
          eventId: "evt-lease-1",
          occurredAt: new Date(),
        };

        const result =
          await handler.handle(event);

        expect(result.statusCode).toBe(200);
        expect(result.message).toBe(
          "Webhook processed.",
        );

        const payoutSnapshot =
          await db
            .collection("tutorPayouts")
            .doc(payout.id)
            .get();

        expect(
          payoutSnapshot.data()?.status,
        ).toBe(
          PayoutStatus.succeeded,
        );

        const eventSnapshot =
          await db
            .collection("payoutWebhookEvents")
            .doc("evt-lease-1")
            .get();

        expect(
          eventSnapshot.data()?.attempts,
        ).toBe(2);
      },
    );


    it(
      "does not retry while the processing lease is still active",
      async () => {
        const payout =
          await createAttachedPayout(
            "mock-payout-active-lease-1",
          );

        await payoutService
          .markProcessing(payout.id);

        await db
          .collection("payoutWebhookEvents")
          .doc("evt-active-lease-1")
          .set({
            eventId: "evt-active-lease-1",
            status:
              WebhookEventStatus.processing,
            attempts: 1,
            processingStartedAt:
              Timestamp.fromDate(
                new Date(),
              ),
            createdAt:
              Timestamp.fromDate(
                new Date(),
              ),
            updatedAt:
              Timestamp.fromDate(
                new Date(),
              ),
            processedAt: null,
            lastError: null,
          });

        const event: PayoutWebhookEvent = {
          providerPayoutId:
            "mock-payout-active-lease-1",
          payoutId: payout.id,
          status: "succeeded",
          failureReason: null,
          eventId: "evt-active-lease-1",
          occurredAt: new Date(),
        };

        const result =
          await handler.handle(event);

        expect(result.message).toBe(
          "Already processed.",
        );

        const payoutSnapshot =
          await db
            .collection("tutorPayouts")
            .doc(payout.id)
            .get();

        expect(
          payoutSnapshot.data()?.status,
        ).toBe(
          PayoutStatus.processing,
        );
      },
    );


        it(
      "attaches the provider payout ID and resolves when the webhook arrives before initiatePayout has attached one",
      async () => {
        const { booking, payment } =
          await seedEligiblePayout();

        const { payout } =
          await payoutService.createPayout({
            booking,
            payment,
          });

        await payoutService
          .markProcessing(payout.id);

        const event: PayoutWebhookEvent = {
          providerPayoutId:
            "mock-payout-race-1",
          payoutId: payout.id,
          status: "succeeded",
          failureReason: null,
          eventId: "evt-race-1",
          occurredAt: new Date(),
        };

        const result =
          await handler.handle(event);

        expect(result.statusCode).toBe(200);

        const payoutSnapshot =
          await db
            .collection("tutorPayouts")
            .doc(payout.id)
            .get();

        expect(
          payoutSnapshot.data()?.status,
        ).toBe(
          PayoutStatus.succeeded,
        );

        expect(
          payoutSnapshot.data()?.providerPayoutId,
        ).toBe(
          "mock-payout-race-1",
        );
      },
    );

    it(
      "rejects an unsupported status and records failure",
      async () => {
        const payout =
          await createAttachedPayout(
            "mock-payout-unsupported-1",
          );

        const event = {
          providerPayoutId:
            "mock-payout-unsupported-1",
          payoutId: payout.id,
          status: "unknown",
          failureReason: null,
          eventId: "evt-unsupported-1",
          occurredAt: new Date(),
        } as unknown as PayoutWebhookEvent;

        await expect(
          handler.handle(event),
        ).rejects.toThrow(
          "Unsupported payout status.",
        );

        const eventSnapshot =
          await db
            .collection("payoutWebhookEvents")
            .doc("evt-unsupported-1")
            .get();

        expect(
          eventSnapshot.data()?.status,
        ).toBe(
          WebhookEventStatus.failed,
        );
      },
    );
  },
);
