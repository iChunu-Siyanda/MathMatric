import { FieldValue, Firestore } from "firebase-admin/firestore";
import {
  MasterclassPayment,
  MasterclassPaymentStatus,
} from "./masterclass_payment_entity";
import { masterclassPaymentFromFirestore } from "./masterclass_payment_mapper";
import { MasterclassEnrollmentStatus } from "../enrollment/masterclass_enrollment_entity";
import { PaymentProvider } from "../../provider/payment_provider";
import { MasterclassPaymentCheckout } from "./masterclass_payment_checkout";

export class MasterclassPaymentService {
  constructor(
    private readonly firestore: Firestore,
    private readonly paymentProvider: PaymentProvider,
  ) {}

  async createPayment({
    enrollmentId,
    studentId,
  }: {
    enrollmentId: string;
    studentId: string;
  }): Promise<MasterclassPaymentCheckout> {
    const enrollmentRef = this.firestore
      .collection("masterclassEnrollments")
      .doc(enrollmentId);

    const paymentRef = this.firestore
      .collection("masterclassPayments")
      .doc(enrollmentId);

    // --------------------------------------------------
    // Phase 1: Create or retrieve the payment
    // --------------------------------------------------

    const payment = await this.firestore.runTransaction(
      async (transaction) => {
        const enrollmentSnapshot =
          await transaction.get(
            enrollmentRef,
          );

        if (!enrollmentSnapshot.exists) {
          throw new Error(
            "Enrollment not found.",
          );
        }

        const enrollment =
          enrollmentSnapshot.data()!;

        if (
          enrollment.studentId !== studentId
        ) {
          throw new Error(
            "Student does not own this enrollment.",
          );
        }

        if (
          enrollment.status !==
          MasterclassEnrollmentStatus.pendingPayment
        ) {
          throw new Error(
            "Enrollment is not awaiting payment.",
          );
        }

        if (
          typeof enrollment.priceCents !== "number" ||
          enrollment.priceCents <= 0
        ) {
          throw new Error(
            "Enrollment has an invalid price.",
          );
        }

        const paymentSnapshot =
          await transaction.get(paymentRef);

        if (paymentSnapshot.exists) {
          return masterclassPaymentFromFirestore(
            paymentSnapshot.id,
            paymentSnapshot.data()!,
          );
        }

        const now = new Date();

        const payment: MasterclassPayment = {
          id: enrollmentId,
          enrollmentId,
          masterclassId: enrollment.masterclassId,
          studentId,
          tutorId: enrollment.tutorId,

          amountCents: enrollment.priceCents,
          currency: "ZAR",

          status: MasterclassPaymentStatus.pending,

          provider: null,
          providerPaymentId: null,

          createdAt: now,
          updatedAt: now,

          paidAt: null,
          failureReason: null,
        };

        transaction.create(paymentRef, {
          enrollmentId,
          masterclassId: enrollment.masterclassId,
          studentId,
          tutorId: enrollment.tutorId,

          amountCents: enrollment.priceCents,
          currency: "ZAR",

          status: MasterclassPaymentStatus.pending,

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

    const providerPayment =
      await this.paymentProvider.createPayment({
        amountCents: payment.amountCents,
        currency: payment.currency,
        bookingId: payment.enrollmentId,
        studentId: payment.studentId,
      });

    // --------------------------------------------------
    // Phase 3: Store provider information
    // --------------------------------------------------

    await paymentRef.update({
      provider: this.paymentProvider.name,
      providerPaymentId:
        providerPayment.providerPaymentId,
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
      providerPaymentId:
        providerPayment.providerPaymentId,
      checkoutUrl: providerPayment.checkoutUrl,
    };
  }

  async markProcessing(
    enrollmentId: string,
  ): Promise<void> {
    const paymentRef = this.firestore
      .collection("masterclassPayments")
      .doc(enrollmentId);

    await this.firestore.runTransaction(
      async (transaction) => {
        const snapshot =
          await transaction.get(paymentRef);

        if (!snapshot.exists) {
          throw new Error(
            "Masterclass payment not found.",
          );
        }

        const payment = snapshot.data()!;

        if (
          payment.status ===
          MasterclassPaymentStatus.processing
        ) {
          return;
        }

        if (
          payment.status !==
          MasterclassPaymentStatus.pending
        ) {
          throw new Error(
            `Masterclass payment cannot become processing from ${payment.status}.`,
          );
        }

        transaction.update(paymentRef, {
          status:
            MasterclassPaymentStatus.processing,
          updatedAt:
            FieldValue.serverTimestamp(),
        });
      },
    );
  }

  async markFailed({
    enrollmentId,
    failureReason,
  }: {
    enrollmentId: string;
    failureReason: string;
  }): Promise<void> {
    const paymentRef = this.firestore
      .collection("masterclassPayments")
      .doc(enrollmentId);

    await this.firestore.runTransaction(
      async (transaction) => {
        const snapshot =
          await transaction.get(paymentRef);

        if (!snapshot.exists) {
          throw new Error(
            "Masterclass payment not found.",
          );
        }

        const payment = snapshot.data()!;

        if (
          payment.status ===
          MasterclassPaymentStatus.failed
        )
          return;

        if (
          payment.status !==
            MasterclassPaymentStatus.pending &&
          payment.status !==
            MasterclassPaymentStatus.processing &&
            payment.status !== MasterclassPaymentStatus.stuck
        ) {
          throw new Error(
            `Masterclass payment cannot be marked failed from ${payment.status}.`,
          );
        }

        transaction.update(paymentRef, {
          status: MasterclassPaymentStatus.failed,
          failureReason,
          updatedAt: FieldValue.serverTimestamp(),
        });
      },
    );
  }

  async findStuckPaymentCandidates(
    stuckThresholdMs: number,
  ): Promise<MasterclassPayment[]> {
    const cutoff = new Date(
      Date.now() - stuckThresholdMs,
    );

    const snapshot = await this.firestore
      .collection("masterclassPayments")
      .where("status","==",MasterclassPaymentStatus.processing,)
      .where("updatedAt","<=",cutoff,)
      .get();

    return snapshot.docs.map((doc) =>
      masterclassPaymentFromFirestore(
        doc.id,
        doc.data(),
      ),
    );
  }

  async markStuck(
    enrollmentId: string,
  ): Promise<void> {
    const paymentRef = this.firestore
      .collection("masterclassPayments")
      .doc(enrollmentId);

    await this.firestore.runTransaction(
      async (transaction) => {
        const snapshot =
          await transaction.get(paymentRef);

        if (!snapshot.exists) {
          throw new Error(
            "Masterclass payment not found.",
          );
        }

        const data = snapshot.data()!;

        if (
          data.status ===
          MasterclassPaymentStatus.stuck
        ) {
          return;
        }

        if (
          data.status !==
          MasterclassPaymentStatus.processing
        ) {
          throw new Error(
            `Masterclass payment cannot become stuck from ${data.status}.`,
          );
        }

        transaction.update(paymentRef, {
          status: MasterclassPaymentStatus.stuck,
          updatedAt:
            FieldValue.serverTimestamp(),
        });
      },
    );
  }

  async resolvePaymentAsFailed(
    enrollmentId: string,
    resolutionNote: string,
  ): Promise<void> {
    if (!resolutionNote.trim()) {
      throw new Error(
        "Resolution note cannot be empty.",
      );
    }

    const paymentRef = this.firestore
      .collection("masterclassPayments")
      .doc(enrollmentId);

    await this.firestore.runTransaction(
      async (transaction) => {
        const snapshot =
          await transaction.get(paymentRef);

        if (!snapshot.exists) {
          throw new Error(
            "Masterclass payment not found.",
          );
        }

        const data = snapshot.data()!;

        if (
          data.status !==
          MasterclassPaymentStatus.stuck
        ) {
          throw new Error(
            "Only a stuck masterclass payment can be resolved as failed.",
          );
        }

        const note = resolutionNote.trim();

        transaction.update(paymentRef, {
          status: MasterclassPaymentStatus.failed,
          failureReason:
            `Resolved from stuck: ${note}`,
          updatedAt:
            FieldValue.serverTimestamp(),
        });
      },
    );
  }
}
