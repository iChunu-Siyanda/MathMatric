import {
  beforeEach,
  describe,
  expect,
  it,
} from "vitest";

import {
  Timestamp,
} from "firebase-admin/firestore";

import {
  db,
} from "../../shared/firebase";

import {
  PaymentStatus,
} from "../payment/payment_entity";

import {
  BookingStatus,
} from "../../bookings/booking_status";

import {
  TransactionType,
  TransactionStatus,
  TransactionDirection,
} from "../transactions/transaction";;


import {
  PaymentService,
} from "../payment/payment_service";

import {
  PaymentSuccessService,
} from "../payment/payment_success_service";

import {
  TransactionReferenceIdentity,
} from "../transactions/transaction_reference_identity";

import {
  TransactionService,
} from "../transactions/transaction_service";

import {
  MockPaymentProvider,
} from "../provider/mock_payment_provider";

import {
  PaymentProvider,
} from "../provider/payment_provider";

import {
  WebhookEventService,
} from "../webhooks/webhook_event_service";

import {
  PaymentWebhookHandler,
} from "../webhooks/payment_webhook_handler";

describe("payment webhook integration", () => {
  const bookingId = "booking-integration-123";
  const studentId = "student-integration-123";
  const tutorId = "tutor-integration-123";
  const providerPaymentId ="mock-booking-integration-123";
  const paidAt = new Date("2026-02-01T15:00:00.000Z",);

  let paymentProvider: PaymentProvider;
  let paymentService: PaymentService;
  let paymentSuccessService: PaymentSuccessService;
  let webhookEventService: WebhookEventService;
  let paymentWebhookHandler: PaymentWebhookHandler;

  beforeEach(async () => {
    // Clear Firestore state from previous test runs
    await db.recursiveDelete(
      db.collection("paymentWebhookEvents"),
    );
    await db.recursiveDelete(
      db.collection("transactions"),
    );
    await db.recursiveDelete(
      db.collection("transactionReferences"),
    );
    await db.recursiveDelete(
      db.collection("payments"),
    );
    await db.recursiveDelete(
      db.collection("bookings"),
    );

    console.log("Firestore test data cleared");

    console.log("1. beforeEach started");

    paymentProvider =
      new MockPaymentProvider();
    console.log("2. provider created");

    paymentService =
      new PaymentService(
        db,
        paymentProvider,
      );  
    console.log("3. payment service created");

    const referenceIdentity =
      new TransactionReferenceIdentity(db);
    console.log("4. reference identity created");  

    const transactionService =
      new TransactionService(
        db,
        referenceIdentity,
      );
    console.log("5. transaction service created");
    
    paymentSuccessService =
      new PaymentSuccessService(
        db,
        transactionService,
      );
    console.log("6. payment success service created");

    webhookEventService =
      new WebhookEventService(db, "paymentWebhookEvents");
    console.log("7. webhook event service created");  

    paymentWebhookHandler =
      new PaymentWebhookHandler({
        paymentService,
        paymentSuccessService,
        webhookEventService,
      });
    console.log("8. handler created");  

    await db
      .collection("bookings")
      .doc(bookingId)
      .set({
        studentId,
        tutorId,
        priceCents: 50000,
        status:
          BookingStatus.paymentRequired,
        createdAt:
          Timestamp.fromDate(paidAt),
        updatedAt:
          Timestamp.fromDate(paidAt),
      });
    console.log("9. booking written");  

    await db
      .collection("payments")
      .doc(bookingId)
      .set({
        bookingId,
        studentId,
        tutorId,

        amountCents: 50000,
        refundedAmountCents: 0,
        refundReservedAmountCents: 0,
        currency: "ZAR",

        status: PaymentStatus.processing,

        provider: "mock",
        providerPaymentId,

        createdAt:
          Timestamp.fromDate(paidAt),
        updatedAt:
          Timestamp.fromDate(paidAt),

        paidAt: null,
        failureReason: null,
      });
    console.log("10. payment written");  
  });

  it(
    "processes a paid webhook atomically",
    async () => {
      const event = {
        eventId:
          "payment-paid-integration-123",
        bookingId,
        providerPaymentId,
        status: "paid" as const,
        failureReason: null,
        occurredAt: paidAt,
      };

      console.log("11. calling webhook handler");

      const existingEvent =
        await db
          .collection("paymentWebhookEvents")
          .doc(event.eventId)
          .get();

      console.log(
        "EXISTING WEBHOOK EVENT:",
        existingEvent.exists,
        existingEvent.data(),
      );

      const result =
        await paymentWebhookHandler.handle(
          event,
        );

      console.log("12. webhook handler returned");  

      expect(result).toEqual({
        statusCode: 200,
        message:
          "Webhook processed.",
      });

      // ------------------------------------------
      // Payment
      // ------------------------------------------

      const paymentSnapshot =
        await db
          .collection("payments")
          .doc(bookingId)
          .get();

      expect(
        paymentSnapshot.exists,
      ).toBe(true);

      const payment =
        paymentSnapshot.data();

      expect(payment?.status).toBe(
        PaymentStatus.paid,
      );

      expect(
        payment?.providerPaymentId,
      ).toBe(providerPaymentId);

      expect(
        payment?.paidAt,
      ).toEqual(
        Timestamp.fromDate(paidAt),
      );

      expect(
        payment?.failureReason,
      ).toBeNull();

      // ------------------------------------------
      // Booking
      // ------------------------------------------

      const bookingSnapshot =
        await db
          .collection("bookings")
          .doc(bookingId)
          .get();

      expect(
        bookingSnapshot.exists,
      ).toBe(true);

      expect(
        bookingSnapshot.data()?.status,
      ).toBe(
        BookingStatus.confirmed,
      );

      // ------------------------------------------
      // Ledger transaction
      // ------------------------------------------

      const transactionSnapshot =
        await db
          .collection("transactions")
          .doc(
            `payment-${bookingId}`,
          )
          .get();

      expect(
        transactionSnapshot.exists,
      ).toBe(true);

      const transaction =
        transactionSnapshot.data();

      expect(
        transaction?.bookingId,
      ).toBe(bookingId);

      expect(
        transaction?.paymentId,
      ).toBe(bookingId);

      expect(
        transaction?.type,
      ).toBe(
        TransactionType.payment,
      );

      expect(
        transaction?.direction,
      ).toBe(
        TransactionDirection.credit,
      );

      expect(
        transaction?.status,
      ).toBe(
        TransactionStatus.completed,
      );

      expect(
        transaction?.amountCents,
      ).toBe(50000);

      expect(
        transaction?.currency,
      ).toBe("ZAR");

      expect(
        transaction?.studentId,
      ).toBe(studentId);

      expect(
        transaction?.tutorId,
      ).toBe(tutorId);

      expect(
        transaction?.referenceId,
      ).toBe(bookingId);

      expect(
        transaction?.completedAt,
      ).toEqual(
        Timestamp.fromDate(paidAt),
      );

      // ------------------------------------------
      // Transaction reference identity
      // ------------------------------------------

      const referenceSnapshot =
        await db
          .collection(
            "transactionReferences",
          )
          .doc(
            `${TransactionType.payment}:${bookingId}`,
          )
          .get();

      expect(
        referenceSnapshot.exists,
      ).toBe(true);

      const reference =
        referenceSnapshot.data();

      expect(
        reference?.type,
      ).toBe(
        TransactionType.payment,
      );

      expect(
        reference?.referenceId,
      ).toBe(bookingId);

      expect(
        reference?.transactionId,
      ).toBe(
        `payment-${bookingId}`,
      );

      expect(
        reference?.bookingId,
      ).toBe(bookingId);

      expect(
        reference?.paymentId,
      ).toBe(bookingId);

      // ------------------------------------------
      // Webhook event
      // ------------------------------------------

      const webhookSnapshot =
        await db
          .collection(
            "paymentWebhookEvents",
          )
          .doc(
            event.eventId,
          )
          .get();

      expect(
        webhookSnapshot.exists,
      ).toBe(true);

      const webhook =
        webhookSnapshot.data();

      expect(
        webhook?.eventId,
      ).toBe(event.eventId);

      expect(
        webhook?.status,
      ).toBe("processed");

      expect(
        webhook?.attempts,
      ).toBe(1);

      expect(
        webhook?.processingStartedAt,
      ).toBeNull();

      expect(
        webhook?.lastError,
      ).toBeNull();

      expect(
        webhook?.processedAt,
      ).toBeDefined();
    },
  );
});

// Testing the following:
// A. starting webhook processing
// B. startProcessing returned: true
// C. entering event switch
// D. paid event
// E. calling markPaymentPaid

// Webhook → idempotency → payment paid → booking confirmed → ledger transaction → transaction reference → webhook marked processed


    //               Firestore Emulator
    //                      │
    //           ┌──────────▼──────────┐
    //           │   Payment Webhook   │
    //           └──────────┬──────────┘
    //                      │
    //                 paid event
    //                      │
    //           ┌──────────▼──────────┐
    //           │ PaymentSuccessSvc   │
    //           └──────────┬──────────┘
    //                      │
    //           REAL Firestore transaction
    //                      │
    //    ┌─────────────────┼─────────────────┐
    //    ▼                 ▼                 ▼
    // Payment           Booking          Transaction
    //   paid            confirmed         completed
    //                                        │
    //                                        ▼
    //                               Transaction Reference