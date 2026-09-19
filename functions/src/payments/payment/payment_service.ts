import {FieldValue,} from "firebase-admin/firestore";
import {PaymentStatus,Payment,} from "./payment_entity";
import { BookingStatus } from "../../bookings/booking_status";
import { Timestamp } from "firebase-admin/firestore";
import { paymentFromFirestore } from "./payment_mapper";
import { PaymentProvider } from "../provider/payment_provider";
import { PaymentCheckout } from "./payment_checkout";

export interface PaymentDocument {
  bookingId: string;
  studentId: string;
  tutorId: string;

  amountCents: number;
  currency: "ZAR";

  status: PaymentStatus;

  provider: string | null;
  providerPaymentId: string | null;

  createdAt: Timestamp;
  updatedAt: Timestamp;

  paidAt: Timestamp | null;
  failureReason: string | null;
}

export class PaymentService {
  constructor(
    private readonly firestore: FirebaseFirestore.Firestore,
    private readonly paymentProvider: PaymentProvider,
  ) {}

  async createPayment({
    bookingId,
    studentId,
  }: {
    bookingId: string;
    studentId: string;
  }): Promise<PaymentCheckout> {
    const bookingRef = this.firestore
      .collection("bookings")
      .doc(bookingId);

    const paymentRef = this.firestore
      .collection("payments")
      .doc(bookingId);

    // --------------------------------------------------
    // Phase 1: Create or retrieve the payment
    // --------------------------------------------------

    const payment = await this.firestore.runTransaction(
      async (transaction) => {
        const bookingSnapshot = await transaction.get(bookingRef);

        if (!bookingSnapshot.exists) {
          throw new Error("Booking not found.");
        }

        const booking = bookingSnapshot.data();

        if (booking?.studentId !== studentId) {
          throw new Error(
            "Student does not own this booking.",
          );
        }

        if (
          booking.status !==
          BookingStatus.paymentRequired
        ) {
          throw new Error(
            "Booking is not awaiting payment.",
          );
        }

        if (
          typeof booking.priceCents !== "number" ||
          booking.priceCents <= 0
        ) {
          throw new Error(
            "Booking has an invalid price.",
          );
        }

        const paymentSnapshot = await transaction.get(paymentRef);

        if (paymentSnapshot.exists) {
          return paymentFromFirestore(
            paymentSnapshot.id,
            paymentSnapshot.data()!,
          );
        }

        const now = new Date();

        const payment: Payment = {
          id: bookingId,
          bookingId,
          studentId,
          tutorId: booking.tutorId,

          amountCents: booking.priceCents,
          refundedAmountCents: 0,
          refundReservedAmountCents: 0,
          currency: "ZAR",

          status: PaymentStatus.pending,

          provider: null,
          providerPaymentId: null,

          createdAt: now,
          updatedAt: now,

          paidAt: null,
          failureReason: null,
        };

        transaction.create(paymentRef, {
          bookingId,
          studentId,
          tutorId: booking.tutorId,

          amountCents: booking.priceCents,
          refundedAmountCents: 0,
          refundReservedAmountCents: 0,
          currency: "ZAR",

          status: PaymentStatus.pending,

          provider: null,
          providerPaymentId: null,

          createdAt: FieldValue.serverTimestamp(),
          updatedAt: FieldValue.serverTimestamp(),

          paidAt: null,
          failureReason: null,
        });

        return payment;
      },
    );

    // --------------------------------------------------
    // Phase 2: Create provider checkout
    // --------------------------------------------------

    const providerPayment = await this.paymentProvider.createPayment({
      amountCents: payment.amountCents,
      currency: payment.currency,
      bookingId: payment.bookingId,
      studentId: payment.studentId,
    });

    // --------------------------------------------------
    // Phase 3: Store provider information
    // --------------------------------------------------

    await paymentRef.update({
      provider: this.paymentProvider.name,
      providerPaymentId: providerPayment.providerPaymentId,
      updatedAt: FieldValue.serverTimestamp(),
    });

    // --------------------------------------------------
    // Phase 4: Return checkout information
    // --------------------------------------------------

    return {
      payment: {
        ...payment,
        provider: this.paymentProvider.name,
        providerPaymentId: providerPayment.providerPaymentId,
      },
      provider: this.paymentProvider.name,
      providerPaymentId: providerPayment.providerPaymentId,
      checkoutUrl: providerPayment.checkoutUrl,
    };
  }

  async markProcessing(
    {
      paymentId,
    }:{
      paymentId: string,
    }): Promise<void> {
    const paymentRef = this.firestore
      .collection("payments")
      .doc(paymentId)
    
    await this.firestore.runTransaction( async (transaction) => {
      const snapshot = await transaction.get(paymentRef);

      if (!snapshot.exists) {
        throw new Error("Payment not found.");
      }

      const payment = snapshot.data()!;

      if (payment.status === PaymentStatus.processing) {
        return;
      }

      if (payment.status !== PaymentStatus.pending) {
        throw new Error(
          `Payment cannot become processing from ${payment.status}.`,
        );
      }

      transaction.update(paymentRef, {
        status: PaymentStatus.processing,
        updatedAt: FieldValue.serverTimestamp(),
      });
    });
  }

  async markFailed({
    bookingId,
    failureReason,
  }:{
    bookingId: string,
    failureReason: string,
  }): Promise<void> {
    const paymentRef = this.firestore
      .collection("payments")
      .doc(bookingId);

    await this.firestore.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(paymentRef);

      if (!snapshot.exists) {
        throw new Error("Payment not found.");
      }

      const payment = snapshot.data()!;

      if (payment.status === PaymentStatus.failed) return;

      if (
        payment.status !== PaymentStatus.pending &&
        payment.status !== PaymentStatus.processing
      ) {
        throw new Error(
          `Payment cannot be marked failed from ${payment.status}.`,
        );
      }

      transaction.update(paymentRef, {
        status: PaymentStatus.failed,
        failureReason,
        updatedAt: FieldValue.serverTimestamp(),
      });
    });
  }

  async findStuckPaymentCandidates(
    stuckThresholdMs: number,
  ): Promise<Payment[]> {
    const cutoff = new Date(
      Date.now() - stuckThresholdMs,
    );

    const snapshot = await this.firestore
      .collection("payments")
      .where(
        "status",
        "==",
        PaymentStatus.processing,
      )
      .where(
        "updatedAt",
        "<=",
        cutoff,
      )
      .get();

    return snapshot.docs.map((doc) =>
      paymentFromFirestore(
        doc.id,
        doc.data(),
      ),
    );
  }

  async markStuck(
    paymentId: string,
  ): Promise<void> {
    const paymentRef = this.firestore
      .collection("payments")
      .doc(paymentId);

    await this.firestore.runTransaction(
      async (transaction) => {
        const snapshot =
          await transaction.get(
            paymentRef,
          );

        if (!snapshot.exists) {
          throw new Error(
            "Payment not found.",
          );
        }

        const data = snapshot.data()!;

        /*
         * Idempotent.
         */
        if (
          data.status ===
          PaymentStatus.stuck
        ) {
          return;
        }

        if (
          data.status !==
          PaymentStatus.processing
        ) {
          throw new Error(
            `Payment cannot become stuck from ${data.status}.`,
          );
        }

        transaction.update(paymentRef, {
          status: PaymentStatus.stuck,
          updatedAt:
            FieldValue.serverTimestamp(),
        });
      },
    );
  }

  /*
   * Operator confirmed (via provider dashboard/support)
   * that the student's charge never actually went
   * through. Terminal — unlike payout, there is no safe
   * automatic retry here; the student must re-initiate
   * checkout, which createPayment already handles on its
   * own via a fresh call.
   */
  async resolvePaymentAsFailed(
    bookingId: string,
    resolutionNote: string,
  ): Promise<void> {
    if (!resolutionNote.trim()) {
      throw new Error(
        "Resolution note cannot be empty.",
      );
    }

    const paymentRef = this.firestore
      .collection("payments")
      .doc(bookingId);

    await this.firestore.runTransaction(
      async (transaction) => {
        const snapshot =
          await transaction.get(
            paymentRef,
          );

        if (!snapshot.exists) {
          throw new Error(
            "Payment not found.",
          );
        }

        const data = snapshot.data()!;

        if (
          data.status !==
          PaymentStatus.stuck
        ) {
          throw new Error(
            "Only a stuck payment can be resolved as failed.",
          );
        }

        const note =
          resolutionNote.trim();

        transaction.update(paymentRef, {
          status: PaymentStatus.failed,
          failureReason:
            `Resolved from stuck: ${note}`,
          updatedAt:
            FieldValue.serverTimestamp(),
        });
      },
    );
  }
}
