import { HttpsError, onCall } from "firebase-functions/https";
import { FieldValue } from "firebase-admin/firestore";
import { db } from "../shared/firebase";
import { TutorNotificationType } from "../tutorApp/notifications/tutor_notification_types";
import { TutorNotificationService, tutorNotificationService } from "../tutorApp/notifications/tutor_notification_service";

const validStudentCancellationReasons = [
  "changedMind",
  "illness",
  "wantToPostpone",
  "scheduleChanged",
  "foundAnotherTutor",
  "tutorAskedMeToCancel",
  "technicalIssue",
  "other",
] as const;

type StudentCancellationReason = typeof validStudentCancellationReasons[number];

function isStudentCancellationReason(
  value: string,
): value is StudentCancellationReason {
  return validStudentCancellationReasons.includes(
    value as StudentCancellationReason,
  );
}

interface CancelBookingRequest {
  bookingId: string;
  reason: string;
  comment: string|null;
}

export function validateCancelBookingRequest(
  data: unknown,
): CancelBookingRequest {
  if (!data || typeof data !== "object") {
    throw new HttpsError(
      "invalid-argument",
      "Invalid cancellation request.",
    );
  }

  const request = data as Record<string, unknown>;

  if (
    typeof request.bookingId !== "string" || request.bookingId.trim().length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      "bookingId is required.",
    );
  }

  if(
    typeof request.reason !== "string" || request.reason.trim().length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Cancellation reason is required.",
    );
  }

  const reason = request.reason.trim();
  if (!isStudentCancellationReason(reason)) {
    throw new HttpsError(
      "invalid-argument",
      "Invalid cancellation reason.",
    );
  }

  if (
    typeof request.comment !== "string" && request.comment !== null && request.comment !== undefined
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Comment must be a string."
    );
  }


  return {
    bookingId: request.bookingId.trim(),
    reason,
    comment: typeof request.comment === 'string' 
            ? request.comment.trim() 
            : null,
  };
}

// Secure backend entry point that Flutter can call.
export const cancelBooking = onCall(
  async (request) => {
    return handleCancelBooking(request);
  },
);

export async function handleCancelBooking(
  request: {
    auth?: { uid: string } | null;
    data: unknown;
  },
  firestore = db,
  notifications: Pick<TutorNotificationService,"create" >= tutorNotificationService,
) {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "You must be signed in to cancel a booking.",
    );
  }

  const data = validateCancelBookingRequest(request.data,);

  const studentId = request.auth.uid;

  const bookingRef = firestore.collection("bookings").doc(data.bookingId);

  const result = await firestore.runTransaction(async (transaction) => {
    const bookingSnapshot = await transaction.get(bookingRef,);

    if (!bookingSnapshot.exists) {
      throw new HttpsError(
        "not-found",
        "Booking not found.",
      );
    }

    const booking = bookingSnapshot.data();

    if (!booking) {
      throw new HttpsError(
        "not-found",
        "Booking not found.",
      );
    }

    if (booking.studentId !== studentId) {
      throw new HttpsError(
        "permission-denied",
        "You cannot cancel this booking.",
      );
    }

    if (
      booking.status !== "pending" && booking.status !== "confirmed"
    ) {
      throw new HttpsError(
        "failed-precondition",
        "This booking cannot be cancelled.",
      );
    }

    transaction.update(bookingRef, {
      status: "cancelled",
      cancelledAt: FieldValue.serverTimestamp(),
      cancelledBy: "student",
      cancellationReason: data.reason,
      cancellationComment: data.comment,
      updatedAt: FieldValue.serverTimestamp(),
    });

    return {
      bookingId: data.bookingId,
      status: "cancelled",
      tutorId: booking.tutorId,
      studentId: booking.studentId,
    }
  });
 
  // CreateNofications for tutors
  try {
    await tutorNotificationService.create({
      tutorId: result.tutorId,
      type: TutorNotificationType.bookingCancelledByStudent,
      title: "Tutor cancelled your booking",
      body: "Your tutor has cancelled your booking.",
      target: {
        feature: "booking",
        resourceId: result.bookingId,
      },
    });
  } catch (error) {
    console.error(
      "Failed to send tutor cancellation notification.",
      {
        bookingId: result.bookingId,
        studentId: result.studentId,
        error,
      },
    );
  }

  return {
    success: true,
    bookingId: data.bookingId,
    status: "cancelled",
  };
}
