export const RefundDecisionType = {
  none: "none",
  partial: "partial",
  full: "full",
} as const;

export type RefundDecisionType = typeof RefundDecisionType[keyof typeof RefundDecisionType];

export interface RefundDecision {
  type: RefundDecisionType;
  refundAmountCents: number;
  reason: string;
}
