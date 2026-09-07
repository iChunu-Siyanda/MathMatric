import {HttpsError,onCall,
} from "firebase-functions/v2/https";
import {FieldValue,Timestamp,} from "firebase-admin/firestore";
import {db} from "../../shared/firebase";
import {getTutorDayBounds} from "../../shared/timezone";
import {NotificationService, notificationService} from "../../notifications/notification_service";
import { NotificationType } from "../../notifications/notification_types";
import { BookingStatus } from "../../bookings/booking_status";

interface AcceptBookingRequest {
  bookingId: string;
}

export async function handleAcceptBooking(
  request: {
    auth?: { uid: string } | null;
    data: unknown;
  },
  firestore = db,
  notifications: Pick<NotificationService, "create"> = notificationService,
) {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "You must be signed in.",
    );
  }

  const tutorId = request.auth.uid;
  const data = request.data as Partial<AcceptBookingRequest>;

  if (
    typeof data.bookingId !== "string" ||
    data.bookingId.trim().length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      "bookingId is required.",
    );
  }

  const bookingId = data.bookingId.trim();

  const result = await firestore.runTransaction(
    async (transaction) => {
      const bookingRef = firestore
        .collection("bookings")
        .doc(bookingId);

      const bookingSnapshot = await transaction.get(bookingRef);
      if (!bookingSnapshot.exists) {
        throw new HttpsError(
          "not-found",
          "Booking not found.",
        );
      }

      const booking = bookingSnapshot.data()!;
      if (booking.tutorId !== tutorId) {
        throw new HttpsError(
          "permission-denied",
          "You cannot accept this booking.",
        );
      }

      if (booking.status !== "pending") {
        throw new HttpsError(
          "failed-precondition",
          "Only pending bookings can be accepted.",
        );
      }

      const scheduledAt = booking.scheduledAt.toDate();
      const durationMinutes = booking.durationMinutes;

      const tutorAvailabilityRef = firestore
        .collection("tutorAvailability")
        .doc(tutorId);

      const tutorAvailabilitySnapshot = await transaction.get(tutorAvailabilityRef);

      if (
        !tutorAvailabilitySnapshot.exists ||
        !tutorAvailabilitySnapshot.data()
      ) {
        throw new HttpsError(
          "failed-precondition",
          "Tutor availability not found.",
        );
      }

      const tutorAvailability =
        tutorAvailabilitySnapshot.data()!;

      if (
        typeof tutorAvailability.timezone !== "string" ||
        tutorAvailability.timezone.trim().length === 0
      ) {
        throw new HttpsError(
          "failed-precondition",
          "Tutor timezone is missing.",
        );
      }

      const tutorTimezone = tutorAvailability.timezone;

      const requestedEnd = scheduledAt.getTime() + durationMinutes * 60 * 1000;

      const {start, end} = getTutorDayBounds(
        scheduledAt,
        tutorTimezone,
      );

      const confirmedSnapshot = await transaction.get(
        firestore.collection("bookings")
            .where("tutorId","==",tutorId,)
            .where("status","==","confirmed",)
            .where("scheduledAt",">=",Timestamp.fromDate(start),)
            .where("scheduledAt","<",Timestamp.fromDate(end),
            ),
        );

      const conflict = confirmedSnapshot.docs.some(
          (doc) => {
            const existing = doc.data();

            const existingStart = existing.scheduledAt
                .toDate()
                .getTime();

            const existingEnd = existingStart + existing.durationMinutes *60 *1000;

            return (
              scheduledAt.getTime() < existingEnd && requestedEnd > existingStart
            );
          },
        );

      if (conflict) {
        throw new HttpsError(
          "already-exists",
          "This time slot has already been booked.",
        );
      }

      transaction.update(
        bookingRef,
        {
          status: "confirmed",
          respondedAt: FieldValue.serverTimestamp(),
          updatedAt: FieldValue.serverTimestamp(),
        },
      );

      return {
        bookingId,
        status: BookingStatus.paymentRequired,
        studentId: booking.studentId,
      };
    },
  );

  try {
    await notifications.create({
      studentId: result.studentId,
      type: NotificationType.tutorBookingAccepted,
      title: "Tutor booking accepted",
      body: "Your tutor has accepted your booking.",
      target: {
        feature: "booking",
        resourceId: bookingId,
      },
    });
  } catch (error) {
    console.error(
      "Failed to send booking acceptance notification.",
      {
        bookingId,
        studentId: result.studentId,
        error,
      },
    );
  }

  return result;
}

export const acceptBooking = onCall(
  async (request) => {
    return handleAcceptBooking(request);
  },
);

// Partially Designed:
// ✅ Function structure
// ✅ Tutor authentication
// ✅ Booking ownership check
// ✅ Pending-status check
// ✅ Confirmed-slot conflict check
// ✅ Firestore transaction
// ⏳ Tests
// ⏳ Handling competing pending requests
// ⏳ Decline function
// ⏳ Notifications/state updates
// ⏳ Integration testing
