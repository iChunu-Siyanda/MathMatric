import { HttpsError, onCall } from "firebase-functions/https";
import {FieldValue,Timestamp,} from "firebase-admin/firestore";
import {db} from "../shared/firebase";
import {
  calculateBookingPrice,
  getTutor,
  hasConfirmedBookingConflict,
  validateTeachingMode,
} from "./bookingValidation";

interface CreateBookingRequest {
    tutorId: string;
    scheduledAt: string;
    durationMinutes: number;
    teachingMode: "online"|"inPerson";
}

export function validateCreateBookingRequest(
    data: unknown,
): CreateBookingRequest{
    if (!data || typeof data !== "object") {
        throw new HttpsError(
            "invalid-argument",
            "Invalid booking request.",
        )
    }

    const request = data as Record<string, unknown>;

    if (
        typeof request.tutorId !== "string" ||
        request.tutorId.trim().length === 0
    ) {
        throw new HttpsError(
        "invalid-argument",
        "tutorId is required.",
        );
    }    

    if (typeof request.scheduledAt !== "string") {
    throw new HttpsError(
      "invalid-argument",
      "scheduledAt is required.",
    );
  }

  const scheduledAt = new Date(request.scheduledAt);

  if (Number.isNaN(scheduledAt.getTime())) {
    throw new HttpsError(
      "invalid-argument",
      "scheduledAt must be a valid ISO date.",
    );
  }

   if (
    typeof request.durationMinutes !== "number" ||
    !Number.isInteger(request.durationMinutes) ||
    request.durationMinutes <= 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      "durationMinutes must be a positive integer.",
    );
  }

  if (
    request.teachingMode !== "online" &&
    request.teachingMode !== "inPerson"
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Invalid teaching mode.",
    );
  }

  return {
    tutorId: request.tutorId.trim(),
    scheduledAt: request.scheduledAt,
    durationMinutes: request.durationMinutes,
    teachingMode: request.teachingMode,
  };
}

// createBooking is a secure backend entry point that Flutter can call, 
// which authenticates the student and validates the booking request before any database operation happens.
export const createBooking = onCall(
    async (request) => {
      return handleCreateBooking(request);
    }
)


export async function handleCreateBooking(
  request: {
    auth?: {uid: string;} | null;
    data: unknown;
  },
  firestore = db,
) {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "You must be signed in to create a booking.",
    );
  }

  const data = validateCreateBookingRequest(
    request.data,
  );

  const studentId = request.auth.uid;

  const scheduledAt = new Date(
    data.scheduledAt,
  );

  if (scheduledAt <= new Date()) {
    throw new HttpsError(
      "invalid-argument",
      "Booking time must be in the future.",
    );
  }

  const tutor = await getTutor(data.tutorId);

  validateTeachingMode(
    tutor,
    data.teachingMode,
  );

  const priceCents = calculateBookingPrice(
    tutor,
    data.teachingMode,
    data.durationMinutes,
  );

  const conflict = await hasConfirmedBookingConflict({
      tutorId: data.tutorId,
      scheduledAt,
      durationMinutes: data.durationMinutes,
    });

  if (conflict) {
    throw new HttpsError(
      "already-exists",
      "This time slot is already booked.",
    );
  }

  const bookingRef = firestore.collection("bookings").doc();

  const booking = {
    id: bookingRef.id,
    studentId,
    tutorId: data.tutorId,
    scheduledAt:
      Timestamp.fromDate(scheduledAt),
    durationMinutes:
      data.durationMinutes,
    teachingMode:
      data.teachingMode,
    priceCents,
    currency: "ZAR",
    status: "pending",
    createdAt:
      FieldValue.serverTimestamp(),
    updatedAt:
      FieldValue.serverTimestamp(),
    respondedAt: null,
  };

  await bookingRef.set(booking);

  return {
    success: true,
    bookingId: bookingRef.id,
    priceCents,
    currency: "ZAR",
    status: "pending",
  };
}
