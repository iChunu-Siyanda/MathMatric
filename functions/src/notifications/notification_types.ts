export const NotificationType = {
  quizAvailable: "quiz_available",
  quizAssigned: "quiz_assigned",

  studyMaterialAvailable: "study_material_available",

  tutorBookingAccepted: "tutor_booking_accepted",
  tutorBookingDeclined: "tutor_booking_declined",
  tutorBookingCancelled: "tutor_booking_cancelled",
  tutorBookingReminder: "tutor_booking_reminder",

  masterclassAvailable: "masterclass_available",
  masterclassReminder: "masterclass_reminder",

  system: "system",
} as const;

export type NotificationType = typeof NotificationType[keyof typeof NotificationType];
