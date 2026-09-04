import { HttpsError, onCall } from "firebase-functions/https";
import {FieldValue, Timestamp, Transaction} from "firebase-admin/firestore";
import { db } from "../shared/firebase";

interface RescheduleBookingRequest {
  bookingId: string;
  newScheduledAt: string;
}

interface AvailabilityWindow {
  start: string;
  end: string;
}

interface TutorAvailability {
  timezone: string;
  weeklySchedule: Record<string, AvailabilityWindow[]>;
}

export function validateRescheduleBookingRequest(
  data: unknown,
): RescheduleBookingRequest {
  if (!data || typeof data !== "object") {
    throw new HttpsError(
      "invalid-argument",
      "Invalid reschedule request.",
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

  if (typeof request.newScheduledAt !== "string") {
    throw new HttpsError(
      "invalid-argument",
      "newScheduledAt is required.",
    );
  }

  const newScheduledAt = new Date(request.newScheduledAt,);

  if (Number.isNaN(newScheduledAt.getTime())) {
    throw new HttpsError(
      "invalid-argument",
      "newScheduledAt must be a valid ISO date.",
    );
  }

  return {
    bookingId: request.bookingId.trim(),
    newScheduledAt: request.newScheduledAt,
  };
}

async function getTutorAvailability(
  transaction: Transaction,
  firestore: FirebaseFirestore.Firestore,
  tutorId: string,
): Promise<TutorAvailability> {
  const availabilityRef = firestore
    .collection("tutorAvailability")
    .doc(tutorId);

  const snapshot = await transaction.get(availabilityRef);

  if (!snapshot.exists || !snapshot.data()) {
    throw new HttpsError(
      "failed-precondition",
      "Tutor availability is unavailable.",
    );
  }

  const data = snapshot.data()!;

  if (typeof data.timezone !== "string") {
    throw new HttpsError(
      "failed-precondition",
      "Tutor timezone is unavailable.",
    );
  }

  const weeklySchedule =
    data.weeklySchedule ?? {};

  if (
    typeof weeklySchedule !== "object" ||
    weeklySchedule === null
  ) {
    throw new HttpsError(
      "failed-precondition",
      "Tutor availability is invalid.",
    );
  }

  return {
    timezone: data.timezone,
    weeklySchedule:
      weeklySchedule as Record<
        string,
        AvailabilityWindow[]
      >,
  };
}

function getTutorLocalParts(
  date: Date,
  timezone: string,
): {
  weekday: number;
  hour: number;
  minute: number;
} {
  try {
    const formatter = new Intl.DateTimeFormat(
      "en-US",
      {
        timeZone: timezone,
        weekday: "short",
        hour: "2-digit",
        minute: "2-digit",
        hourCycle: "h23",
      },
    );

    const parts = formatter.formatToParts(date);

    const values: Record<string, string> = {};

    for (const part of parts) {
      if (part.type !== "literal") {
        values[part.type] = part.value;
      }
    }

    const weekdayMap: Record<string, number> = {
      Mon: 1,
      Tue: 2,
      Wed: 3,
      Thu: 4,
      Fri: 5,
      Sat: 6,
      Sun: 7,
    };

    const weekday = weekdayMap[values.weekday];

    if (!weekday) {
      throw new Error("Invalid weekday.");
    }

    return {
      weekday,
      hour: Number(values.hour),
      minute: Number(values.minute),
    };
  } catch {
    throw new HttpsError(
      "failed-precondition",
      "Tutor timezone is invalid.",
    );
  }
}

export function isWithinTutorAvailability(
  scheduledAt: Date,
  durationMinutes: number,
  availability: TutorAvailability,
): boolean {
  const localStart = getTutorLocalParts(
    scheduledAt,
    availability.timezone,
  );

  const startMinutes = localStart.hour * 60 + localStart.minute;

  const endMinutes = startMinutes + durationMinutes;

  const windows = availability.weeklySchedule[
      String(localStart.weekday)
    ] ?? [];

  return windows.some((window) => {
    if (
      typeof window.start !== "string" || typeof window.end !== "string"
    ) {
      return false;
    }

    const startParts = window.start.split(":").map(Number);
    const endParts = window.end.split(":").map(Number);

    if (
      startParts.length !== 2 ||
      endParts.length !== 2 ||
      startParts.some(Number.isNaN) ||
      endParts.some(Number.isNaN)
    ) {
      return false;
    }

    const windowStart = startParts[0] * 60 + startParts[1];

    const windowEnd = endParts[0] * 60 + endParts[1];

    return (startMinutes >= windowStart && endMinutes <= windowEnd);
  });
}

export async function hasRescheduleConflict(
  transaction: Transaction,
  firestore: FirebaseFirestore.Firestore,
  {
    tutorId,
    bookingId,
    scheduledAt,
    durationMinutes,
  }: {
    tutorId: string;
    bookingId: string;
    scheduledAt: Date;
    durationMinutes: number;
  },
): Promise<boolean> {
  const requestedStart = scheduledAt.getTime();
  const requestedEnd = requestedStart + durationMinutes * 60 * 1000;
  /*
   * We use a broad UTC range because the tutor's
   * availability is timezone-aware.
   *
   * The actual overlap check happens below.
   */
  const rangeStart = new Date(requestedStart -2 * 24 * 60 * 60 * 1000,);
  const rangeEnd = new Date(requestedEnd + 2 * 24 * 60 * 60 * 1000,);

  const query = firestore
    .collection("bookings")
    .where("tutorId", "==", tutorId)
    .where("status", "==", "confirmed")
    .where(
      "scheduledAt",
      ">=",
      Timestamp.fromDate(rangeStart),
    )
    .where(
      "scheduledAt",
      "<=",
      Timestamp.fromDate(rangeEnd),
    );

  const snapshot = await transaction.get(query);

  return snapshot.docs.some((doc) => {
    /*
     * The booking being rescheduled already exists
     * as a confirmed booking. It must not conflict
     * with itself.
     */
    if (doc.id === bookingId) {
      return false;
    }

    const booking = doc.data();

    if (
      !booking.scheduledAt || typeof booking.durationMinutes !== "number"
    ) {
      return false;
    }

    const bookingStart = booking.scheduledAt.toDate().getTime();

    const bookingEnd = bookingStart + booking.durationMinutes * 60 * 1000;

    return (
      requestedStart < bookingEnd && requestedEnd > bookingStart
    );
  });
}

export const rescheduleBooking = onCall(
  async (request) => {
    return handleRescheduleBooking(request);
  },
);

export async function handleRescheduleBooking(
  request: {
    auth?: { uid: string } | null;
    data: unknown;
  },
  firestore = db,
) {
  // ------------------------------------------------
  // Authentication:
  // ------------------------------------------------
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "You must be signed in to reschedule a booking.",
    );
  }

  const data = validateRescheduleBookingRequest(request.data,);
  const studentId = request.auth.uid;
  const newScheduledAt = new Date(data.newScheduledAt);

  if (newScheduledAt <= new Date()) {
    throw new HttpsError(
      "invalid-argument",
      "The new booking time must be in the future.",
    );
  }

  const bookingRef = firestore
    .collection("bookings")
    .doc(data.bookingId);

  await firestore.runTransaction(
    async (transaction) => {
      /*
       * IMPORTANT:
       * Every read happens before the update.
       */

      // --------------------------------------------------
      // 1. Read booking
      // --------------------------------------------------

      const bookingSnapshot = await transaction.get(bookingRef);

      if (
        !bookingSnapshot.exists || !bookingSnapshot.data()
      ) {
        throw new HttpsError(
          "not-found",
          "Booking not found.",
        );
      }

      const booking = bookingSnapshot.data()!;

      // --------------------------------------------------
      // 2. Ownership
      // --------------------------------------------------

      if (booking.studentId !== studentId) {
        throw new HttpsError(
          "permission-denied",
          "You cannot reschedule this booking.",
        );
      }

      // --------------------------------------------------
      // 3. Status
      // --------------------------------------------------

      if (booking.status !== "confirmed") {
        throw new HttpsError(
          "failed-precondition",
          "Only confirmed bookings can be rescheduled.",
        );
      }

      // --------------------------------------------------
      // 4. Validate existing booking data
      // --------------------------------------------------

      if (
        !booking.scheduledAt || typeof booking.durationMinutes !== "number"
      ) {
        throw new HttpsError(
          "failed-precondition",
          "Booking data is invalid.",
        );
      }

      const originalScheduledAt = booking.scheduledAt.toDate();
      const durationMinutes = booking.durationMinutes;
      const tutorId = booking.tutorId;

      // --------------------------------------------------
      // 5. 24-hour reschedule rule
      // --------------------------------------------------

      const now = new Date();
      const minimumRescheduleTime = new Date(originalScheduledAt.getTime() -24 * 60 * 60 * 1000,);

      if (now > minimumRescheduleTime) {
        throw new HttpsError(
          "failed-precondition",
          "Bookings can only be rescheduled at least 24 hours before the lesson.",
        );
      }

      // --------------------------------------------------
      // 6. Read tutor availability
      // --------------------------------------------------
      const availability = await getTutorAvailability(
          transaction,
          firestore,
          tutorId,
        );

      // --------------------------------------------------
      // 7. Check availability
      // --------------------------------------------------

      const fitsAvailability = isWithinTutorAvailability(
          newScheduledAt,
          durationMinutes,
          availability,
        );

      if (!fitsAvailability) {
        throw new HttpsError(
          "failed-precondition",
          "The new time is outside the tutor's availability.",
        );
      }

      // --------------------------------------------------
      // 8. Check confirmed booking conflicts
      // --------------------------------------------------

      const conflict = await hasRescheduleConflict(
          transaction,
          firestore,
          {
            tutorId,
            bookingId: data.bookingId,
            scheduledAt: newScheduledAt,
            durationMinutes,
          },
        );

      if (conflict) {
        throw new HttpsError(
          "already-exists",
          "The new time is already booked.",
        );
      }

      // --------------------------------------------------
      // 9. Update existing booking
      // --------------------------------------------------

      transaction.update(bookingRef, {
        scheduledAt: Timestamp.fromDate(newScheduledAt),

        updatedAt: FieldValue.serverTimestamp(),

        rescheduledAt: FieldValue.serverTimestamp(),

        rescheduledBy: "student",

        previousScheduledAt:Timestamp.fromDate(originalScheduledAt,),
      });
    },
  );

  return {
    success: true,
    bookingId: data.bookingId,
    status: "confirmed",
  };
}
