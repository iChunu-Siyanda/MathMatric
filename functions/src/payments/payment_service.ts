import {FieldValue,} from "firebase-admin/firestore";
import {PaymentStatus,Payment,} from "./payment_entity";
import { BookingStatus } from "../bookings/booking_status";
import { Timestamp } from "firebase-admin/firestore";
import { paymentFromFirestore } from "./payment_mapper";
import { PaymentProvider } from "./payment_provider";
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

  async markProcessing(paymentId: string): Promise<void> {
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

  async markPaid(
    bookingId: string,
    provider:string,
    providerPaymentId:string,
  ): Promise<void> {
    const paymentRef = this.firestore
      .collection("payments")
      .doc(bookingId);
    
    const bookingRef = this.firestore
      .collection("bookings")
      .doc(bookingId); 

    await this.firestore.runTransaction(async (transaction) => {
      const paymentSnapshot = await transaction.get(paymentRef);
 
      // =====================================
      // 1. Payment Auth and Validation:
      // =====================================
      if (!paymentSnapshot.exists) {
        throw new Error("Payment not found.");
      }

      const payment = paymentSnapshot.data()!;
      
      // duplicate provider webhook should do nothing.
      if (payment.status === PaymentStatus.paid) {
        return;
      }

      if (payment.status !== PaymentStatus.processing) {
        throw new Error(
          `Payment cannot become paid from ${payment.status}.`,
        );
      }

      // =====================================
      // 2. Booking Auth and Validation:
      // =====================================
      const bookingSnapshot = await transaction.get(bookingRef);

      if (!bookingSnapshot.exists) {
        throw new Error("Booking not found.");
      }

      const booking = bookingSnapshot.data();

      if (booking?.status !== BookingStatus.paymentRequired) {
        throw new Error(
            "Booking is not awaiting payment.",
        );
      }

      if (
        booking.studentId !== payment.studentId ||
        booking.tutorId !== payment.tutorId
      ) {
        throw new Error(
          "Payment does not belong to the booking.",
        );
      }

      if (
        booking.priceCents !== payment.amountCents
      ) {
        throw new Error(
          "Payment amount does not match booking price.",
        );
      }

      // Update payment and booking states:
      transaction.update(paymentRef, {
        status: PaymentStatus.paid,
        provider,
        providerPaymentId,
        paidAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });

      transaction.update(bookingRef, {
        status: BookingStatus.confirmed,
        updatedAt: FieldValue.serverTimestamp(),
      });
    });
  }

  async markFailed(
    bookingId: string,
    failureReason: string,
  ): Promise<void> {
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

  // private async updateStatus(
  //   paymentId: string,
  //   status: PaymentStatus,
  // ): Promise<void> {
  //   await this.firestore
  //     .collection("payments")
  //     .doc(paymentId)
  //     .update({
  //       status,
  //       updatedAt: FieldValue.serverTimestamp(),
  //     });
  // }
}
