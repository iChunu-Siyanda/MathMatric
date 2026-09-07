import {HttpsError,onCall,} from "firebase-functions/v2/https";
import {FieldValue,} from "firebase-admin/firestore";
import {db} from "../../shared/firebase";
import {NotificationService,notificationService,} from "../../notifications/notification_service";
import {NotificationType} from "../../notifications/notification_types";

interface DeclineBookingRequest {
  bookingId: string;
}

export function validateDeclineBookingRequest(
  data: unknown,
): DeclineBookingRequest {
  if (!data || typeof data !== "object") {
    throw new HttpsError(
      "invalid-argument",
      "Invalid decline booking request.",
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

  return {
    bookingId: request.bookingId.trim(),
  };
}

export async function handleDeclineBooking(
  request: {
    auth?: {uid: string} | null;
    data: unknown;
  },
  firestore = db,
  notifications: Pick<NotificationService, "create"> = notificationService,
) {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "You must be signed in to decline a booking.",
    );
  }

  const data = validateDeclineBookingRequest(request.data);

  const tutorId = request.auth.uid;

  const bookingRef = firestore
    .collection("bookings")
    .doc(data.bookingId);

  const bookingSnapshot = await bookingRef.get();

  if (
    !bookingSnapshot.exists || !bookingSnapshot.data()
  ) {
    throw new HttpsError(
      "not-found",
      "Booking not found.",
    );
  }

  const booking = bookingSnapshot.data()!;

  if (booking.tutorId !== tutorId) {
    throw new HttpsError(
      "permission-denied",
      "You cannot decline this booking.",
    );
  }

  if (booking.status !== "pending") {
    throw new HttpsError(
      "failed-precondition",
      "Only pending bookings can be declined.",
    );
  }

  await bookingRef.update({
    status: "declined",
    tutorId: booking.tutorId,
    respondedAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  });

  try {
    await notifications.create({
      studentType: booking.studentType,
      studentId: booking.studentId,
      type: NotificationType.tutorBookingDeclined,
      title: "Tutor booking declined",
      body: "Your tutor is unable to accept your booking.",
      target: {
        feature: "booking",
        resourceId: data.bookingId,
      },
    });
  } catch (error) {
    console.error(
      "Failed to send booking decline notification.",
      {
        bookingId: data.bookingId,
        studentId: booking.studentId,
        tutorId: booking.tutorId,
        error,
      },
    );
  }

  return {
    success: true,
    bookingId: data.bookingId,
    status: "declined",
  };
}

export const declineBooking = onCall(
  async (request) => {
    return handleDeclineBooking(request);
  },
);
