import {
  HttpsError,
  onCall,
} from "firebase-functions/v2/https";
import {
  FieldValue,
  Timestamp,
} from "firebase-admin/firestore";
import {db} from "../shared/firebase";

interface AcceptBookingRequest {
  bookingId: string;
}

export const acceptBooking = onCall(
  async (request) => {
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

    const result = await db.runTransaction(
      async (transaction) => {
        const bookingRef = db
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
        const requestedEnd = scheduledAt.getTime() + durationMinutes * 60 * 1000;
        
        const startOfDay = new Date(scheduledAt);
        startOfDay.setHours(0,0,0,0,);

        const endOfDay =new Date(scheduledAt);
        endOfDay.setHours(23,59,59,999,);

        const confirmedSnapshot = await transaction.get(
            db
              .collection("bookings")
              .where(
                "tutorId",
                "==",
                tutorId,
              )
              .where(
                "status",
                "==",
                "confirmed",
              )
              .where(
                "scheduledAt",
                ">=",
                Timestamp.fromDate(startOfDay,),
              )
              .where(
                "scheduledAt",
                "<=",
                Timestamp.fromDate(endOfDay,),
              ),
          );

        const conflict =
          confirmedSnapshot.docs.some(
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
          status: "confirmed",
        };
      },
    );

    return result;
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
// ⏳ Emulator integration testing
