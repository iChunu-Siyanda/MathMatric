import {FieldValue,Firestore,Timestamp,} from "firebase-admin/firestore";
import {paymentFromFirestore,} from "../payment/payment_mapper";
import {PaymentStatus,} from "../payment/payment_entity";
import {Refund,RefundStatus,} from "./refund";
import {RefundDecisionType,} from "./refund_decision";
import {CancellationPolicy,} from "./cancellation_policy";
import {RefundResult,} from "./refund_result";
import {BookingStatus,} from "../../bookings/booking_status";
import { PaymentProviderValidator } from "../payment/payment_provider_validator";
import { PaymentProvider } from "../payment/payment_provider";
import { PaymentProviderRefundIdentity } from "./provider_refund_identity_service";

export interface CreateRefundInput {
  bookingId: string;
  studentId: string;
  idempotencyKey: string;
  cancellationRequestedAt: Date;
}

const MAX_IDEMPOTENCY_KEY_LENGTH = 128;

export class RefundService {
  constructor(
    private readonly firestore: Firestore,
    private readonly cancellationPolicy: CancellationPolicy,
    private readonly paymentProvider: PaymentProvider,
    private readonly providerRefundIdentity: PaymentProviderRefundIdentity,
  ) {}

  async createRefund({
    bookingId,
    studentId,
    idempotencyKey,
    cancellationRequestedAt,
  }: CreateRefundInput): Promise<RefundResult> {
    this.validateInput({
      bookingId,
      studentId,
      idempotencyKey,
      cancellationRequestedAt,
    });

    const paymentRef = this.firestore
      .collection("payments")
      .doc(bookingId);

    const bookingRef = this.firestore
      .collection("bookings")
      .doc(bookingId);

    const refundRef = paymentRef
      .collection("refunds")
      .doc(idempotencyKey);

    return this.firestore.runTransaction(
      async (transaction) => {
        /*
         * Check the idempotency record first.
         * A retry using the same idempotency key returns
         * the original refund rather than creating another one.
         */
        const existingRefundSnapshot = await transaction.get(refundRef);

        if (existingRefundSnapshot.exists) {
          const refund =this.parseExistingRefund(
            existingRefundSnapshot.data(),
            existingRefundSnapshot.id,
          );

          return {
            refund,
            created: false,
          };
        }

        const paymentSnapshot = await transaction.get(paymentRef);

        if (!paymentSnapshot.exists) {
          throw new Error(
            "Payment not found.",
          );
        }

        const payment = paymentFromFirestore(
          paymentSnapshot.id,
          paymentSnapshot.data()!,
        );

        if (
          payment.studentId !== studentId
        ) {
          throw new Error(
            "Payment does not belong to the student.",
          );
        }

        if (
          payment.status !== PaymentStatus.paid &&
          payment.status !== PaymentStatus.partiallyRefunded
        ) {
          throw new Error(
            "Payment is not refundable.",
          );
        }

        const bookingSnapshot = await transaction.get(bookingRef);

        if (!bookingSnapshot.exists) {
          throw new Error(
            "Booking not found.",
          );
        }

        const booking = bookingSnapshot.data()!;

        if (
          booking.studentId !== studentId
        ) {
          throw new Error(
            "Booking does not belong to the student.",
          );
        }

        if (
          booking.status !== BookingStatus.confirmed
        ) {
          throw new Error(
            "Booking is not eligible for cancellation.",
          );
        }

        if (
          typeof booking.tutorId !== "string" ||
          booking.tutorId !== payment.tutorId
        ) {
          throw new Error(
            "Payment tutor does not match booking.",
          );
        }

        if (
          typeof booking.priceCents !== "number" ||
          !Number.isInteger(booking.priceCents,) ||
          booking.priceCents <= 0
        ) {
          throw new Error(
            "Booking price is invalid.",
          );
        }

        if (
          booking.priceCents !== payment.amountCents
        ) {
          throw new Error(
            "Payment amount does not match booking price.",
          );
        }

        if (
          !(booking.lessonStartsAt instanceof Timestamp)
        ) {
          throw new Error(
            "Booking lessonStartsAt is invalid.",
          );
        }

        const lessonStartsAt = booking.lessonStartsAt.toDate();

        const remainingRefundableCents = payment.amountCents - payment.refundedAmountCents - payment.refundReservedAmountCents;

        if (remainingRefundableCents <= 0) {
          throw new Error(
            "Refund amount exceeds the available refundable amount.",
          );
        }

        const decision = this.cancellationPolicy.calculateRefund({
          lessonStartsAt,
          cancellationRequestedAt,
          amountCents: remainingRefundableCents,
        });

        if (
          decision.type === RefundDecisionType.none
        ) {
          throw new Error(
            decision.reason,
          );
        }

        if (
          decision.refundAmountCents <= 0
        ) {
          throw new Error(
            "Refund amount must be greater than zero.",
          );
        }

        if (
          decision.refundAmountCents > remainingRefundableCents
        ) {
          throw new Error(
            "Refund amount exceeds the remaining refundable amount.",
          );
        }

        const newRefundReservedAmountCents = payment.refundReservedAmountCents + decision.refundAmountCents;

        if (
          payment.refundedAmountCents + newRefundReservedAmountCents >
          payment.amountCents
        ) {
          throw new Error("Refund amount exceeds the available refundable amount.",);
        }

        const now = new Date();

        const refund: Refund = {
          id: idempotencyKey,

          paymentId: payment.id,
          bookingId: payment.bookingId,

          studentId: payment.studentId,
          tutorId: payment.tutorId,

          amountCents: decision.refundAmountCents,
          currency: payment.currency,

          status: RefundStatus.pending,

          provider: payment.provider,
          providerRefundId: null,

          reason: decision.reason,

          createdAt: now,
          updatedAt: now,

          completedAt: null,
          failureReason: null,
        };

        transaction.create(
          refundRef,
          {
            paymentId: refund.paymentId,
            bookingId: refund.bookingId,

            studentId: refund.studentId,
            tutorId: refund.tutorId,

            amountCents: refund.amountCents,
            currency: refund.currency,

            status: refund.status,

            provider: refund.provider,
            providerRefundId: refund.providerRefundId,

            reason: refund.reason,

            createdAt: FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp(),

            completedAt: null,
            failureReason: null,
          },
        );

        /*
         * Reserve the refund amount atomically.
         *
         * If another refund request races this transaction,
         * Firestore retries the transaction against the newer
         * payment state.
         */
        transaction.update(paymentRef, {
          refundReservedAmountCents: newRefundReservedAmountCents,
          updatedAt: FieldValue.serverTimestamp(),
        });

        return {
          refund,
          created: true,
        };
      },
    );
  }

  private validateInput({
    bookingId,
    studentId,
    idempotencyKey,
    cancellationRequestedAt,
  }: CreateRefundInput): void {
    if (
      typeof bookingId !== "string" ||
      bookingId.trim().length === 0
    ) {
      throw new Error(
        "bookingId is required.",
      );
    }

    if (
      typeof studentId !== "string" ||
      studentId.trim().length === 0
    ) {
      throw new Error(
        "studentId is required.",
      );
    }

    if (
      typeof idempotencyKey !== "string" ||
      idempotencyKey.trim().length === 0
    ) {
      throw new Error(
        "idempotencyKey is required.",
      );
    }

    if (
      idempotencyKey.length >
      MAX_IDEMPOTENCY_KEY_LENGTH
    ) {
      throw new Error(
        "idempotencyKey is too long.",
      );
    }

    if (
      !Number.isFinite(
        cancellationRequestedAt.getTime(),
      )
    ) {
      throw new Error(
        "cancellationRequestedAt is invalid.",
      );
    }
  }

  private parseExistingRefund(
    data:
      FirebaseFirestore.DocumentData
      | undefined,
    id: string,
  ): Refund {
    if (!data) {
      throw new Error(
        "Existing refund data is missing.",
      );
    }

    return {
      id,

      paymentId: data.paymentId,
      bookingId: data.bookingId,

      studentId: data.studentId,
      tutorId: data.tutorId,

      amountCents: data.amountCents,
      currency: data.currency,

      status: data.status,

      provider: data.provider ?? null,
      providerRefundId:
        data.providerRefundId ?? null,

      reason: data.reason,

      createdAt:
        data.createdAt instanceof Timestamp
          ? data.createdAt.toDate()
          : (() => {
              throw new Error(
                "Refund createdAt is invalid.",
              );
            })(),

      updatedAt:
        data.updatedAt instanceof Timestamp
          ? data.updatedAt.toDate()
          : (() => {
              throw new Error(
                "Refund updatedAt is invalid.",
              );
            })(),

      completedAt:
        data.completedAt instanceof Timestamp
          ? data.completedAt.toDate()
          : null,

      failureReason:
        data.failureReason ?? null,
    };
  }

  async markRefundProcessing({
    bookingId,
    refundId,
  }: {
    bookingId: string;
    refundId: string;
  }): Promise<void> {
    if (
      typeof bookingId !== "string" ||
      bookingId.trim().length === 0
    ) {
      throw new Error("bookingId is required.");
    }

    if (
      typeof refundId !== "string" ||
      refundId.trim().length === 0
    ) {
      throw new Error("refundId is required.");
    }

    const refundRef = this.firestore
      .collection("payments")
      .doc(bookingId)
      .collection("refunds")
      .doc(refundId);

    await this.firestore.runTransaction(
      async (transaction) => {
        const refundSnapshot =
          await transaction.get(refundRef);

        if (!refundSnapshot.exists) {
          throw new Error("Refund not found.");
        }

        const data = refundSnapshot.data();

        if (!data) {
          throw new Error("Refund data is missing.");
        }

        if (
          data.status === RefundStatus.processing
        ) {
          return;
        }

        if (
          data.status !== RefundStatus.pending
        ) {
          throw new Error(
            "Refund cannot be moved to processing.",
          );
        }

        transaction.update(refundRef, {
          status: RefundStatus.processing,
          updatedAt: FieldValue.serverTimestamp(),
        });
      },
    );
  }

  async attachProviderRefundId({
    bookingId,
    refundId,
    provider,
    providerRefundId,
  }: {
    bookingId: string;
    refundId: string;
    provider: string;
    providerRefundId: string;
  }): Promise<void> {
    PaymentProviderValidator.validateProviderName(
      provider,
    );

    PaymentProviderValidator.validateProviderRefundId(
      providerRefundId,
    );

    const paymentRef = this.firestore
      .collection("payments")
      .doc(bookingId);

    const refundRef = paymentRef
      .collection("refunds")
      .doc(refundId);

    await this.firestore.runTransaction(
      async (transaction) => {
        const refundSnapshot =
          await transaction.get(refundRef);

        if (!refundSnapshot.exists) {
          throw new Error("Refund not found.");
        }

        const refundData =
          refundSnapshot.data();

        if (!refundData) {
          throw new Error(
            "Refund data is missing.",
          );
        }

        if (
          refundData.provider !== null &&
          refundData.provider !== provider
        ) {
          throw new Error(
            "Refund provider does not match the existing refund.",
          );
        }

        if (
          refundData.providerRefundId !== null
        ) {
          if (
            refundData.providerRefundId !==
            providerRefundId
          ) {
            throw new Error(
              "Provider refund ID does not match the existing refund.",
            );
          }

          return;
        }

        await this.providerRefundIdentity
          .claimInTransaction(
            transaction,
            {
              provider,
              providerRefundId,
              bookingId,
              paymentId: bookingId,
              refundId,
            },
          );

        transaction.update(
          refundRef,
          {
            provider,
            providerRefundId,
            updatedAt:
              FieldValue.serverTimestamp(),
          },
        );
      },
    );
  }

  async initiateRefund({
    bookingId,
    studentId,
    idempotencyKey,
    cancellationRequestedAt,
  }: CreateRefundInput): Promise<RefundResult> {
    const result =
      await this.createRefund({
        bookingId,
        studentId,
        idempotencyKey,
        cancellationRequestedAt,
      });

    if (!result.created) {
      return result;
    }

    await this.markRefundProcessing({
      bookingId,
      refundId: result.refund.id,
    });

    // Load payment here
    const paymentRef = this.firestore
      .collection("payments")
      .doc(bookingId);

    const paymentSnapshot =
      await paymentRef.get();

    // Validate payment here
    // ...

    const payment =
      paymentFromFirestore(
        paymentSnapshot.id,
        paymentSnapshot.data()!,
      );

    if (!payment.providerPaymentId) {
      throw new Error(
        "Payment does not have a provider payment ID.",
      );
    }

    // 👇 YOUR try/catch GOES HERE
    try {
      const providerResult =
        await this.paymentProvider.refundPayment({
          providerPaymentId:
            payment.providerPaymentId,

          amountCents:
            result.refund.amountCents,

          currency:
            result.refund.currency,

          refundId:
            result.refund.id,

          bookingId,
        });

      PaymentProviderValidator
        .validateProviderRefundId(
          providerResult.providerRefundId,
        );

      await this.attachProviderRefundId({
        bookingId,
        refundId: result.refund.id,
        provider:
          this.paymentProvider.name,
        providerRefundId:
          providerResult.providerRefundId,
      });
    } catch (error) {
      await this.markRefundFailed({
        bookingId,
        refundId: result.refund.id,
        failureReason:
          error instanceof Error
            ? error.message
            : "Refund provider request failed.",
      });

      throw error;
    }

    return result;
  }

  async markRefundSucceeded({
    bookingId,
    refundId,
    providerRefundId,
  }: {
    bookingId: string;
    refundId: string;
    providerRefundId: string;
  }): Promise<void> {
    if (
      typeof bookingId !== "string" || bookingId.trim().length === 0
    ) {
      throw new Error("bookingId is required.");
    }

    if (
      typeof refundId !== "string" || refundId.trim().length === 0
    ) {
      throw new Error("refundId is required.");
    }

    PaymentProviderValidator.validateProviderRefundId(providerRefundId,);

    const paymentRef = this.firestore
      .collection("payments")
      .doc(bookingId);

    const refundRef = paymentRef
      .collection("refunds")
      .doc(refundId);

    await this.firestore.runTransaction(
      async (transaction) => {
        const refundSnapshot = await transaction.get(refundRef);

        if (!refundSnapshot.exists) {
          throw new Error("Refund not found.");
        }

        const refundData = refundSnapshot.data();

        if (!refundData) {
          throw new Error(
            "Refund data is missing.",
          );
        }

        if (
          refundData.provider !== null &&
          refundData.provider !== this.paymentProvider.name
        ) {
          throw new Error(
            "Refund provider does not match the configured payment provider.",
          );
        }

        /*
        * Idempotency:
        * A provider retry must not refund the payment twice.
        */
        if (refundData.status === RefundStatus.succeeded) {
          if (
            refundData.providerRefundId !== providerRefundId
          ) {
            throw new Error(
              "Provider refund ID does not match the existing refund.",
            );
          }

          return;
        }

        if (
          refundData.status !== RefundStatus.processing
        ) {
          throw new Error(
            "Refund cannot be marked as succeeded.",
          );
        }

        const paymentSnapshot = await transaction.get(paymentRef);

        if (!paymentSnapshot.exists) {
          throw new Error("Payment not found.");
        }

        const payment = paymentFromFirestore(
          paymentSnapshot.id,
          paymentSnapshot.data()!,
        );

        if (
          typeof refundData.amountCents !== "number" ||
          !Number.isInteger(refundData.amountCents,) ||
          refundData.amountCents <= 0
        ) {
          throw new Error(
            "Refund amountCents is invalid.",
          );
        }

        const refundAmountCents = refundData.amountCents;

        /*
        * The refund must have a corresponding
        * reservation before it can succeed.
        */
        if (
          refundAmountCents > payment.refundReservedAmountCents
        ) {
          throw new Error(
            "Refund amount exceeds the reserved amount.",
          );
        }

        const newRefundedAmountCents = payment.refundedAmountCents + refundAmountCents;

        if (
          newRefundedAmountCents > payment.amountCents
        ) {
          throw new Error(
            "Refunded amount exceeds payment amount.",
          );
        }

        const newRefundReservedAmountCents = payment.refundReservedAmountCents - refundAmountCents;

        if (
          newRefundReservedAmountCents < 0
        ) {
          throw new Error(
            "Refund reserved amount cannot be negative.",
          );
        }

        let newPaymentStatus:
          | PaymentStatus = PaymentStatus.partiallyRefunded;

        if (
          newRefundedAmountCents === payment.amountCents
        ) {
          newPaymentStatus = PaymentStatus.refunded;
        }

        transaction.update(paymentRef, {
          refundedAmountCents: newRefundedAmountCents,
          refundReservedAmountCents: newRefundReservedAmountCents,
          status: newPaymentStatus,
          updatedAt: FieldValue.serverTimestamp(),
        });

        transaction.update(refundRef, {
          status: RefundStatus.succeeded,
          providerRefundId,
          completedAt: FieldValue.serverTimestamp(),
          updatedAt: FieldValue.serverTimestamp(),
          failureReason: null,
        });
      },
    );
  }

  async markRefundFailed({
    bookingId,
    refundId,
    failureReason,
  }: {
    bookingId: string;
    refundId: string;
    failureReason: string;
  }): Promise<void> {
    if (
      typeof bookingId !== "string" ||
      bookingId.trim().length === 0
    ) {
      throw new Error("bookingId is required.");
    }

    if (
      typeof refundId !== "string" ||
      refundId.trim().length === 0
    ) {
      throw new Error("refundId is required.");
    }

    if (
      typeof failureReason !== "string" ||
      failureReason.trim().length === 0
    ) {
      throw new Error(
        "failureReason is required.",
      );
    }

    const paymentRef = this.firestore
      .collection("payments")
      .doc(bookingId);

    const refundRef = paymentRef
      .collection("refunds")
      .doc(refundId);

    await this.firestore.runTransaction(
      async (transaction) => {
        const refundSnapshot = await transaction.get(refundRef);

        if (!refundSnapshot.exists) {
          throw new Error("Refund not found.");
        }

        const refundData = refundSnapshot.data();

        if (!refundData) {
          throw new Error(
            "Refund data is missing.",
          );
        }

        /*
        * Idempotency:
        * A repeated failure notification should not
        * release the reservation twice.
        */
        if (
          refundData.status === RefundStatus.failed
        ) {
          return;
        }

        if (
          refundData.status !== RefundStatus.processing
        ) {
          throw new Error(
            "Refund cannot be marked as failed.",
          );
        }

        if (
          typeof refundData.amountCents !== "number" ||
          !Number.isInteger(refundData.amountCents,) ||
          refundData.amountCents <= 0
        ) {
          throw new Error(
            "Refund amountCents is invalid.",
          );
        }

        const paymentSnapshot = await transaction.get(paymentRef);

        if (!paymentSnapshot.exists) {
          throw new Error("Payment not found.");
        }

        const payment = paymentFromFirestore(paymentSnapshot.id,paymentSnapshot.data()!,);

        const refundAmountCents = refundData.amountCents;

        if (
          refundAmountCents > payment.refundReservedAmountCents
        ) {
          throw new Error(
            "Refund amount exceeds the reserved amount.",
          );
        }

        const newRefundReservedAmountCents =payment.refundReservedAmountCents - refundAmountCents;

        if (
          newRefundReservedAmountCents < 0
        ) {
          throw new Error(
            "Refund reserved amount cannot be negative.",
          );
        }

        transaction.update(paymentRef, {
          refundReservedAmountCents: newRefundReservedAmountCents,
          updatedAt: FieldValue.serverTimestamp(),
        });

        transaction.update(refundRef, {
          status: RefundStatus.failed,
          failureReason: failureReason.trim(),
          updatedAt: FieldValue.serverTimestamp(),
        });
      },
    );
  }
}
