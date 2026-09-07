export const TutorNotificationType = {
  newBookingRequest: "new_booking_request",
  bookingCancelledByStudent: "booking_cancelled_by_student",
  bookingRescheduledByStudent: "booking_rescheduled_by_student",
  bookingReminder: "booking_reminder",
  masterclassApproved: "masterclass_approved",
  masterclassReminder: "masterclass_reminder",
  newMessage: "new_message",
  paymentReceived: "payment_received",
  payoutProcessed: "payout_processed",
  reviewReceived: "review_received",
  system: "system",
} as const;

export type TutorNotificationType = typeof TutorNotificationType[keyof typeof TutorNotificationType];
