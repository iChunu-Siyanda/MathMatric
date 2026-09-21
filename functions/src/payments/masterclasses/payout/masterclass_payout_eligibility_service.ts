import { MasterclassEnrollment, MasterclassEnrollmentStatus } from "../enrollment/masterclass_enrollment_entity";
import { MasterclassPayment, MasterclassPaymentStatus } from "../payment/masterclass_payment_entity";
import { PlatformFeeCalculator } from "../../payout/platform_fee_calculator";

const REFUND_WINDOW_MS = 7 * 24 * 60 * 60 * 1000;

export interface MasterclassPayoutEligibilityResult {
  eligible: boolean;
  reason: string | null;
  grossAmountCents: number;
  platformFeeCents: number;
  payoutAmountCents: number;
}

export class MasterclassPayoutEligibilityService {
  constructor(
    private readonly feeCalculator: PlatformFeeCalculator,
  ) {}

  evaluate({
    enrollment,
    payment,
    now = new Date(),
  }: {
    enrollment: MasterclassEnrollment;
    payment: MasterclassPayment;
    now?: Date;
  }): MasterclassPayoutEligibilityResult {
    const ineligible = (
      reason: string,
    ): MasterclassPayoutEligibilityResult => ({
      eligible: false,
      reason,
      grossAmountCents: 0,
      platformFeeCents: 0,
      payoutAmountCents: 0,
    });

    if (
      enrollment.status !==
      MasterclassEnrollmentStatus.confirmed
    ) {
      return ineligible(
        "Enrollment is not confirmed.",
      );
    }

    if (
      payment.status !==
      MasterclassPaymentStatus.paid
    ) {
      return ineligible(
        "Payment is not paid.",
      );
    }

    if (payment.enrollmentId !== enrollment.id) {
      return ineligible(
        "Payment does not belong to this enrollment.",
      );
    }

    if (payment.studentId !== enrollment.studentId) {
      return ineligible(
        "Payment student does not match the enrollment.",
      );
    }

    if (payment.tutorId !== enrollment.tutorId) {
      return ineligible(
        "Payment tutor does not match the enrollment.",
      );
    }

    if (payment.amountCents !== enrollment.priceCents) {
      return ineligible(
        "Payment amount does not match the enrollment price.",
      );
    }

    /*
     * Refund window: eligible for payout once the
     * refund door has closed, via whichever comes
     * first — the student downloaded (forfeiting
     * refund eligibility immediately), or 7 days
     * have elapsed since enrollment.
     */
    const downloaded =
      enrollment.downloadedAt !== null;

    const windowElapsed =
      now.getTime() -
        enrollment.enrolledAt.getTime() >=
      REFUND_WINDOW_MS;

    if (!downloaded && !windowElapsed) {
      return ineligible(
        "Refund window has not yet closed.",
      );
    }

    const platformFeeCents =
      this.feeCalculator.calculateFeeCents(
        payment.amountCents,
      );

    const payoutAmountCents =
      payment.amountCents - platformFeeCents;

    return {
      eligible: true,
      reason: null,
      grossAmountCents: payment.amountCents,
      platformFeeCents,
      payoutAmountCents,
    };
  }
}
