// const blockingStatuses = [
//   "payment_required",
//   "confirmed",
// ] as const ;

export const BookingStatus = {
  pending: "pending",
  paymentRequired: "payment_required",
  confirmed: "confirmed",
  declined: "declined",
  cancelled: "cancelled",
  completed: "completed",
} as const;

export type BookingStatus = typeof BookingStatus[keyof typeof BookingStatus];
