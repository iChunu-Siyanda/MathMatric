export const TransactionType = {
  payment: "payment",
  refund: "refund",
  payout: "payout",
  platformFee: "platform_fee",
  adjustment: "adjustment",
} as const;

export type TransactionType =
  typeof TransactionType[
    keyof typeof TransactionType
  ];

export const TransactionDirection = {
  credit: "credit",
  debit: "debit",
} as const;

export type TransactionDirection =
  typeof TransactionDirection[
    keyof typeof TransactionDirection
  ];

export const TransactionStatus = {
  pending: "pending",
  completed: "completed",
  failed: "failed",
  reversed: "reversed",
} as const;

export type TransactionStatus =
  typeof TransactionStatus[
    keyof typeof TransactionStatus
  ];

export interface Transaction {
  id: string;
  bookingId: string;
  paymentId: string;

  type: TransactionType;
  direction: TransactionDirection;
  status: TransactionStatus;

  amountCents: number;
  currency: "ZAR";

  studentId: string;
  tutorId: string;

  referenceId: string;
  description: string;

  createdAt: Date;
  completedAt: Date | null;
}

export function isTransactionType(
  value: unknown,
): value is TransactionType {
  return Object.values(TransactionType).includes(
    value as TransactionType,
  );
}

export function isTransactionDirection(
  value: unknown,
): value is TransactionDirection {
  return Object.values(TransactionDirection).includes(
    value as TransactionDirection,
  );
}

export function isTransactionStatus(
  value: unknown,
): value is TransactionStatus {
  return Object.values(TransactionStatus).includes(
    value as TransactionStatus,
  );
}
