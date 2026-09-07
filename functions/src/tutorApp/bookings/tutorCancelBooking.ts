import { HttpsError, onCall } from "firebase-functions/https";
import { FieldValue } from "firebase-admin/firestore";
import { db } from "../../shared/firebase";
import {NotificationService,notificationService,} from "../../notifications/notification_service";
import {NotificationType} from "../../notifications/notification_types";

const validTutorCancellationReasons = [
  "emergency",
  "scheduleConflict",
  "illness",
  "technicalIssue",
  "studentRequestedCancellation",
  "other",
] as const;

type TutorCancellationReason = typeof validTutorCancellationReasons[number];

function isTutorCancellationReason(
  value: string,
): value is TutorCancellationReason {
  return validTutorCancellationReasons.includes(
    value as TutorCancellationReason,
  );
}

interface TutorCancelBookingRequest {
  bookingId: string;
  reason: string;
  comment: string | null;
}

export function validateTutorCancelBookingRequest(
  data: unknown,
): TutorCancelBookingRequest {
  if (!data || typeof data !== "object") {
    throw new HttpsError(
      "invalid-argument",
      "Invalid cancellation request.",
    );
  }

  const request = data as Record<string, unknown>;

  if (
    typeof request.bookingId !== "string" ||
    request.bookingId.trim().length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      "bookingId is required.",
    );
  }

  if (
    typeof request.reason !== "string" ||
    request.reason.trim().length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Cancellation reason is required.",
    );
  }

  const reason = request.reason.trim();

  if (!isTutorCancellationReason(reason)) {
    throw new HttpsError(
      "invalid-argument",
      "Invalid cancellation reason.",
    );
  }

  if (
    typeof request.comment !== "string" &&
    request.comment !== null &&
    request.comment !== undefined
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Comment must be a string.",
    );
  }

  return {
    bookingId: request.bookingId.trim(),
    reason,
    comment:
      typeof request.comment === "string"
        ? request.comment.trim()
        : null,
  };
}

export const tutorCancelBooking = onCall(
  async (request) => {
    return handleTutorCancelBooking(request);
  },
);

export async function handleTutorCancelBooking(
  request: {
    auth?: {uid: string} | null;
    data: unknown;
  },
  firestore = db,
  notifications: Pick<NotificationService,"create" >= notificationService,
) {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "You must be signed in to cancel a booking.",
    );
  }

  const data = validateTutorCancelBookingRequest(request.data);

  const tutorId = request.auth.uid;

  const bookingRef = firestore
    .collection("bookings")
    .doc(data.bookingId);

  const result = await firestore.runTransaction(
    async (transaction) => {
      const bookingSnapshot =
        await transaction.get(bookingRef);

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

      if (booking.tutorId !== tutorId) {
        throw new HttpsError(
          "permission-denied",
          "You cannot cancel this booking.",
        );
      }

      if (booking.status !== "confirmed") {
        throw new HttpsError(
          "failed-precondition",
          "Only confirmed bookings can be cancelled.",
        );
      }

      transaction.update(bookingRef, {
        status: "cancelled",
        cancelledAt: FieldValue.serverTimestamp(),
        cancelledBy: "tutor",
        cancellationReason: data.reason,
        cancellationComment: data.comment,
        updatedAt: FieldValue.serverTimestamp(),
      });

      return {
        bookingId: data.bookingId,
        status: "cancelled",
        studentId: booking.studentId,
      };
    },
  );

  try {
    await notifications.create({
      studentId: result.studentId,
      type: NotificationType.tutorBookingCancelled,
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
    status: result.status,
  };
}
