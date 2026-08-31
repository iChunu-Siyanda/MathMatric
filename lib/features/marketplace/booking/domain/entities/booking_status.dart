enum BookingStatus {
  pending, // Student submitted request.
  confirmed, // Tutor accepted request.
  declined, // Tutor declined the request.
  cancelled, // Student/tutor/system cancelled.
  completed, // Lesson Finished.
}

// student clicks Book:
// Status is pending

// The tutor then sees in the Tutor App:

// Siyanda wants a Mathematics lesson
// 15 September · 15:00–16:00
// Online · R180

// [Accept] [Decline]

// If they accept:

// pending → confirmed

// If they decline:

// pending → declined
