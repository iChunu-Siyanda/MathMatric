import {HttpsError,onCall,} from "firebase-functions/v2/https";
import {FieldValue,} from "firebase-admin/firestore";
import { db } from "../../shared/firebase";
import {NotificationType,} from "../../notifications/notification_types";
import { notificationService, NotificationService } from "../../notifications/notification_service";

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
    typeof request.bookingId !== "string" ||
    request.bookingId.trim().length === 0
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
    auth?: {
      uid: string;
    } | null;
    data: unknown;
  },
  firestore = db,
  notifications: Pick<NotificationService, "create" > = notificationService,
) {
  // ------------------------------------------------
  // Authentication:
  // ------------------------------------------------

  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "You must be signed in to decline a booking.",
    );
  }

  const data = validateDeclineBookingRequest(
    request.data,
  );

  const tutorId = request.auth.uid;

  // ------------------------------------------------
  // Booking reference:
  // ------------------------------------------------

  const bookingRef = firestore
    .collection("bookings")
    .doc(data.bookingId);

  // ------------------------------------------------
  // Read booking:
  // ------------------------------------------------

  const bookingSnapshot = await bookingRef.get();

  if (
    !bookingSnapshot.exists ||
    !bookingSnapshot.data()
  ) {
    throw new HttpsError(
      "not-found",
      "Booking not found.",
    );
  }

  const booking = bookingSnapshot.data()!;

  // ------------------------------------------------
  // Ownership:
  // ------------------------------------------------

  if (booking.tutorId !== tutorId) {
    throw new HttpsError(
      "permission-denied",
      "You cannot decline this booking.",
    );
  }

  // ------------------------------------------------
  // Status:
  // ------------------------------------------------

  if (booking.status !== "pending") {
    throw new HttpsError(
      "failed-precondition",
      "Only pending bookings can be declined.",
    );
  }

  // ------------------------------------------------
  // Decline booking:
  // ------------------------------------------------

  await bookingRef.update({
    status: "declined",
    tutorId: booking.tutorId,
    respondedAt:
      FieldValue.serverTimestamp(),
    updatedAt:
      FieldValue.serverTimestamp(),
  });

  // ------------------------------------------------
  // Notify student:
  // ------------------------------------------------
  // NotificationService resolves studentType from
  // studentAccounts/{studentId}.
  //
  // We therefore only provide studentId here.

  try {
    await notifications.create({
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
