import {HttpsError} from "firebase-functions/v2/https";
import {db} from "../shared/firebase";
import {Timestamp} from "firebase-admin/firestore";

export interface TutorData {
  displayName?: string;
  teachingModes?: string[];
  onlinePrice?: number;
  inPersonPrice?: number;
}

export async function getTutor(
  tutorId: string,
): Promise<TutorData> {
  const tutorSnapshot = await db
    .collection("tutors")
    .doc(tutorId)
    .get();

  if (!tutorSnapshot.exists) {
    throw new HttpsError(
      "not-found",
      "Tutor not found.",
    );
  }

  return tutorSnapshot.data() as TutorData;
}


export function validateTeachingMode(
  tutor: TutorData,
  teachingMode: "online" | "inPerson",
): void {
  if (!tutor.teachingModes?.includes(teachingMode)) {
    throw new HttpsError(
      "failed-precondition",
      "Tutor does not offer the selected teaching mode.",
    );
  }
}


export function calculateBookingPrice(
  tutor: TutorData,
  teachingMode: "online" | "inPerson",
  durationMinutes: number,
): number {
  const hourlyPrice = teachingMode === "online"
      ? tutor.onlinePrice
      : tutor.inPersonPrice;

  if (
    typeof hourlyPrice !== "number" ||
    hourlyPrice < 0
  ) {
    throw new HttpsError(
      "failed-precondition",
      "Tutor pricing is unavailable.",
    );
  }

  return Math.round((hourlyPrice / 60) * durationMinutes,);
}
// So if the tutor has:
// onlinePrice    = 18000 cents/hour
// inPersonPrice  = 25000 cents/hour

// and the student requests 90 minutes online:
// 18000 / 60 × 90
// = 27000 cents
// = R270


export async function hasConfirmedBookingConflict({
  tutorId,
  scheduledAt,
  durationMinutes,
}: {
  tutorId: string;
  scheduledAt: Date;
  durationMinutes: number;
}): Promise<boolean> {
  const requestedStart = scheduledAt.getTime();
  const requestedEnd = requestedStart + durationMinutes * 60 * 1000;

  const startOfDay = new Date(scheduledAt);
  startOfDay.setHours(0, 0, 0, 0);

  const endOfDay = new Date(scheduledAt);
  endOfDay.setHours(23, 59, 59, 999);

  const snapshot = await db
    .collection("bookings")
    .where("tutorId", "==", tutorId)
    .where("status", "==", "confirmed")
    .where(
      "scheduledAt",
      ">=",
      Timestamp.fromDate(startOfDay),
    )
    .where(
      "scheduledAt",
      "<=",
      Timestamp.fromDate(endOfDay),
    )
    .get();

  return snapshot.docs.some((doc) => {
    const booking = doc.data();
    const bookingStart = booking.scheduledAt.toDate().getTime();
    const bookingEnd = bookingStart + booking.durationMinutes * 60 * 1000;

    return (
      requestedStart < bookingEnd &&
      requestedEnd > bookingStart
    );
  });
}
// It catches not only identical slots, but overlapping durations too.
// This uses the standard interval-overlap rule:
// requestedStart < existingEnd
// AND
// requestedEnd > existingStart
