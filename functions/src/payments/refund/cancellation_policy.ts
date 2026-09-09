import {RefundDecision,RefundDecisionType,} from "./refund_decision";

export interface CancellationPolicyInput {
  lessonStartsAt: Date;
  cancellationRequestedAt: Date;
  amountCents: number;
}

export class CancellationPolicy {
  calculateRefund({
    lessonStartsAt,
    cancellationRequestedAt,
    amountCents,
  }: CancellationPolicyInput): RefundDecision {
    if (amountCents <= 0) {
      throw new Error(
        "Refund amount must be greater than zero.",
      );
    }

    if (
      cancellationRequestedAt >= lessonStartsAt
    ) {
      return {
        type: RefundDecisionType.none,
        refundAmountCents: 0,
        reason: "The lesson has already started.",
      };
    }

    const millisecondsUntilLesson = lessonStartsAt.getTime() - cancellationRequestedAt.getTime();

    const hoursUntilLesson = millisecondsUntilLesson / (1000 * 60 * 60);

    if (hoursUntilLesson > 24) {
      return {
        type: RefundDecisionType.full,
        refundAmountCents: amountCents,
        reason: "Cancellation was made more than 24 hours before the lesson.",
      };
    }

    if (hoursUntilLesson >= 12) {
      return {
        type: RefundDecisionType.partial,
        refundAmountCents: Math.floor(amountCents * 0.5,),
        reason: "Cancellation was made between 12 and 24 hours before the lesson.",
      };
    }

    return {
      type: RefundDecisionType.none,
      refundAmountCents: 0,
      reason: "Cancellation was made less than 12 hours before the lesson.",
    };
  }
}
