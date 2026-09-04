import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import {isWithinTutorAvailability,handleRescheduleBooking,validateRescheduleBookingRequest, hasRescheduleConflict,} from "./rescheduleBookingRequest";
import { FieldValue, Timestamp } from "firebase-admin/firestore";

// ===========================================================
// 1. Request Validation Tests:
// ===========================================================
describe("validateRescheduleBookingRequest", () => {
  it("rejects a non-object request", () => {
    expect(() => validateRescheduleBookingRequest(null),
    ).toThrow("Invalid reschedule request.");
  });

  it("rejects a missing bookingId", () => {
    expect(() => validateRescheduleBookingRequest({
        newScheduledAt: "2026-09-10T13:00:00.000Z",
      }),
    ).toThrow("bookingId is required.");
  });

  it("rejects an empty bookingId", () => {
    expect(() => validateRescheduleBookingRequest({
        bookingId: "   ",
        newScheduledAt: "2026-09-10T13:00:00.000Z",
      }),
    ).toThrow("bookingId is required.");
  });

  it("rejects a missing newScheduledAt", () => {
    expect(() => validateRescheduleBookingRequest({
        bookingId: "booking-1",
      }),
    ).toThrow("newScheduledAt is required");
  });

  it("rejects a non-string newScheduledAt", () => {
    expect(() => validateRescheduleBookingRequest({
        bookingId: "booking-1",
        newScheduledAt: 12345,
      }),
    ).toThrow("newScheduledAt is required");
  });

  it("rejects an invalid date", () => {
    expect(() => validateRescheduleBookingRequest({
        bookingId: "booking-1",
        newScheduledAt: "not-a-date",
      }),
    ).toThrow("newScheduledAt must be a valid ISO date.");
  });

  it("accepts a valid request", () => {
    const result = validateRescheduleBookingRequest({
      bookingId: " booking-1 ",
      newScheduledAt:"2026-09-10T13:00:00.000Z",
    });

    expect(result).toEqual({
      bookingId: "booking-1",
      newScheduledAt: "2026-09-10T13:00:00.000Z",
    });
  });
});

// ===========================================================
// Mock Firestore: To implement the runTransaction
// ===========================================================
function createFirestoreMock(
  bookingData: Record<string, unknown> | null,
) {
  const bookingRef = {
    id: "booking-1",
  };

  const bookingSnapshot = {
    exists: bookingData !== null,
    data: () => bookingData,
  };

  const transaction = {
    get: async () => bookingSnapshot,
    update: () => {},
  };

  return {
    collection: () => ({
      doc: () => bookingRef,
    }),
    runTransaction: async (
      callback: (transaction: {
        get: () => Promise<typeof bookingSnapshot>;
        update: () => void;
      }) => Promise<void>,
    ) => {
      await callback(transaction);
    },
  };
}

// ============================================================
// 2. Auth & booking validation:
// ============================================================
describe("handleRescheduleBooking - authentication and booking validation", () => {
  const validRequest = {
    bookingId: "booking-1",
    newScheduledAt: "2026-09-10T13:00:00.000Z",
  };

  it("rejects an unauthenticated request", async () => {
    await expect(
      handleRescheduleBooking({
        auth: null,
        data: validRequest,
      }),
    ).rejects.toMatchObject({
      code: "unauthenticated",
    });
  });

  it("rejects when the booking does not exist", async () => {
    const firestore = createFirestoreMock(null);

    await expect(
      handleRescheduleBooking(
        {
          auth: { uid: "student-1" },
          data: validRequest,
        },
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "not-found",
    });
  });

  it("rejects when the booking belongs to another student", async () => {
    const firestore = createFirestoreMock({
      studentId: "student-2",
      tutorId: "tutor-1",
      status: "confirmed",
      scheduledAt: {
        toDate: () => new Date("2026-09-10T13:00:00.000Z"),
      },
      durationMinutes: 60,
    });

    await expect(
      handleRescheduleBooking(
        {
          auth: { uid: "student-1" },
          data: validRequest,
        },
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "permission-denied",
    });
  });

  it("rejects when the booking is not confirmed", async () => {
    const firestore = createFirestoreMock({
      studentId: "student-1",
      tutorId: "tutor-1",
      status: "pending",
      scheduledAt: {
        toDate: () => new Date("2026-09-10T13:00:00.000Z"),
      },
      durationMinutes: 60,
    });

    await expect(
      handleRescheduleBooking(
        {
          auth: { uid: "student-1" },
          data: validRequest,
        },
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "failed-precondition",
    });
  });

  it("rejects booking with missing scheduledAt", async () => {
    const firestore = createFirestoreMock({
      studentId: "student-1",
      tutorId: "tutor-1",
      status: "confirmed",
      durationMinutes: 60,
    });

    await expect(
      handleRescheduleBooking(
        {
          auth: { uid: "student-1" },
          data: validRequest,
        },
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "failed-precondition",
    });
  });

  it("rejects booking with invalid durationMinutes", async () => {
    const firestore = createFirestoreMock({
      studentId: "student-1",
      tutorId: "tutor-1",
      status: "confirmed",
      scheduledAt: {
        toDate: () => new Date("2026-09-10T13:00:00.000Z"),
      },
      durationMinutes: "60",
    });

    await expect(
      handleRescheduleBooking(
        {
          auth: { uid: "student-1" },
          data: validRequest,
        },
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "failed-precondition",
    });
  });
});

// Thus the security is done:
// Request -> Authenticated? -> Booking exists? -> Owns booking? -> Booking confirmed? -> Booking data valid?
// -> 24-hour rule -> Tutor availability -> Conflict check -> Transaction update


// =============================================================
// 3. The 24-hour rule
// =============================================================
describe("handleRescheduleBooking - 24 hour reschedule rule", () => {
  const validRequest = {
    bookingId: "booking-1",
    newScheduledAt: "2026-09-12T13:00:00.000Z",
  };

  function createValidBooking(
    scheduledAt: string,
  ) {
    return {
      studentId: "student-1",
      tutorId: "tutor-1",
      status: "confirmed",
      scheduledAt: {
        toDate: () => new Date(scheduledAt),
      },
      durationMinutes: 60,
    };
  }

  beforeEach(() => {
    vi.useFakeTimers();
    vi.setSystemTime(new Date("2026-09-10T12:00:00.000Z"),);
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("rejects rescheduling when less than 24 hours remain", async () => {
    const firestore = createFirestoreMock(
      createValidBooking(
        "2026-09-11T11:00:00.000Z",
      ),
    );

    await expect(
      handleRescheduleBooking(
        {
          auth: { uid: "student-1" },
          data: validRequest,
        },
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "failed-precondition",
    });
  });
});


// =============================================================
// 4. Tutor Availability & Timezone:
// =============================================================
describe("isWithinTutorAvailability", () => {
  const availability = {
    timezone: "Africa/Johannesburg",
    weeklySchedule: {
      "4": [
        {
          start: "09:00",
          end: "17:00",
        },
      ],
    },
  };

  it("allows a booking inside the tutor's availability window", () => {
    const result = isWithinTutorAvailability(
      new Date("2026-09-10T10:00:00.000Z"),
      60,
      availability,
    );

    expect(result).toBe(true);
  });

  it("rejects a booking before the availability window", () => {
    const result = isWithinTutorAvailability(
      new Date("2026-09-10T06:00:00.000Z"),
      60,
      availability,
    );

    expect(result).toBe(false);
  });

  it("rejects a booking after the availability window", () => {
    const result = isWithinTutorAvailability(
      new Date("2026-09-10T17:00:00.000Z"),
      60,
      availability,
    );

    expect(result).toBe(false);
  });

  it("rejects a booking that extends beyond the availability window", () => {
    const result = isWithinTutorAvailability(
      new Date("2026-09-10T16:30:00.000Z"),
      60,
      availability,
    );

    expect(result).toBe(false);
  });

  it("allows a booking ending exactly at the availability boundary", () => {
    const result = isWithinTutorAvailability(
      new Date("2026-09-10T14:00:00.000Z"),
      60,
      availability,
    );

    expect(result).toBe(true);
  });

  it("rejects a booking on a day the tutor is unavailable", () => {
    const result = isWithinTutorAvailability(
      new Date("2026-09-11T10:00:00.000Z"),
      60,
      availability,
    );

    expect(result).toBe(false);
  });
});

describe("isWithinTutorAvailability - invalid data", () => {
  it("rejects an invalid timezone", () => {
    expect(() =>
      isWithinTutorAvailability(
        new Date("2026-09-10T14:00:00.000Z"),
        60,
        {
          timezone: "Not/A/Timezone",
          weeklySchedule: {
            "4": [
              {
                start: "09:00",
                end: "17:00",
              },
            ],
          },
        },
      ),
    ).toThrow();
  });

  it("rejects when the weekday has no availability", () => {
    const result = isWithinTutorAvailability(
      new Date("2026-09-11T14:00:00.000Z"),
      60,
      {
        timezone: "Africa/Johannesburg",
        weeklySchedule: {
          "4": [
            {
              start: "09:00",
              end: "17:00",
            },
          ],
        },
      },
    );

    expect(result).toBe(false);
  });

  it("rejects a malformed availability window", () => {
    const result = isWithinTutorAvailability(
      new Date("2026-09-10T14:00:00.000Z"),
      60,
      {
        timezone: "Africa/Johannesburg",
        weeklySchedule: {
          "4": [
            {
              start: "invalid",
              end: "17:00",
            },
          ],
        },
      },
    );

    expect(result).toBe(false);
  });

  it("rejects an availability window with an invalid end time", () => {
    const result = isWithinTutorAvailability(
      new Date("2026-09-10T14:00:00.000Z"),
      60,
      {
        timezone: "Africa/Johannesburg",
        weeklySchedule: {
          "4": [
            {
              start: "09:00",
              end: "invalid",
            },
          ],
        },
      },
    );

    expect(result).toBe(false);
  });
});


// =============================================================
// 5. Confirmed Booking Conflicts:
// =============================================================
describe("hasRescheduleConflict", () => {
  function createConflictFirestoreMock(
    bookings: Array<{id: string;scheduledAt: Date;durationMinutes: number;}>,
  ) {
    const bookingDocs = bookings.map((booking) => ({
      id: booking.id,
      data: () => ({
        scheduledAt: {
          toDate: () => booking.scheduledAt,
        },
        durationMinutes: booking.durationMinutes,
      }),
    }));

    const snapshot = {docs: bookingDocs,};

    const query = {
      where() {
        return this;
      },
    };

    const transaction = {
      get: async () => snapshot,
    };

    return {
      firestore: {
        collection: () => ({
          where() {
            return query;
          },
        }),
      },
      transaction,
    };
  }

  it("detects an overlapping confirmed booking", async () => {
    const { firestore, transaction } = createConflictFirestoreMock([
      {
        id: "booking-2",
        scheduledAt:
          new Date("2026-09-10T15:30:00.000Z"),
        durationMinutes: 60,
      },
    ]);

    const result = await hasRescheduleConflict(
      transaction as never,
      firestore as never,
      {
        tutorId: "tutor-1",
        bookingId: "booking-1",
        scheduledAt:
          new Date("2026-09-10T16:00:00.000Z"),
        durationMinutes: 60,
      },
    );

    expect(result).toBe(true);
  });

  it("allows a booking that starts after another booking ends", async () => {
    const { firestore, transaction } = createConflictFirestoreMock([
        {
          id: "booking-2",
          scheduledAt:
            new Date("2026-09-10T15:00:00.000Z"),
          durationMinutes: 60,
        },
      ]);

    const result = await hasRescheduleConflict(
      transaction as never,
      firestore as never,
      {
        tutorId: "tutor-1",
        bookingId: "booking-1",
        scheduledAt:
          new Date("2026-09-10T16:00:00.000Z"),
        durationMinutes: 60,
      },
    );

    expect(result).toBe(false);
  });

  it("allows a booking that ends exactly when another booking starts", async () => {
    const { firestore, transaction } = createConflictFirestoreMock([
        {
          id: "booking-2",
          scheduledAt:
            new Date("2026-09-10T17:00:00.000Z"),
          durationMinutes: 60,
        },
      ]);

    const result = await hasRescheduleConflict(
      transaction as never,
      firestore as never,
      {
        tutorId: "tutor-1",
        bookingId: "booking-1",
        scheduledAt:
          new Date("2026-09-10T16:00:00.000Z"),
        durationMinutes: 60,
      },
    );

    expect(result).toBe(false);
  });

  it("detects a booking that completely contains the requested slot", async () => {
    const { firestore, transaction } =
      createConflictFirestoreMock([
        {
          id: "booking-2",
          scheduledAt:
            new Date("2026-09-10T15:00:00.000Z"),
          durationMinutes: 180,
        },
      ]);

    const result = await hasRescheduleConflict(
      transaction as never,
      firestore as never,
      {
        tutorId: "tutor-1",
        bookingId: "booking-1",
        scheduledAt:
          new Date("2026-09-10T16:00:00.000Z"),
        durationMinutes: 60,
      },
    );

    expect(result).toBe(true);
  });

  it("detects when the requested slot contains another booking", async () => {
    const { firestore, transaction } =
      createConflictFirestoreMock([
        {
          id: "booking-2",
          scheduledAt:
            new Date("2026-09-10T16:30:00.000Z"),
          durationMinutes: 30,
        },
      ]);

    const result = await hasRescheduleConflict(
      transaction as never,
      firestore as never,
      {
        tutorId: "tutor-1",
        bookingId: "booking-1",
        scheduledAt:
          new Date("2026-09-10T16:00:00.000Z"),
        durationMinutes: 120,
      },
    );

    expect(result).toBe(true);
  });

  it("ignores the booking currently being rescheduled", async () => {
    const { firestore, transaction } = createConflictFirestoreMock([
      {
        id: "booking-1",
        scheduledAt:
          new Date("2026-09-10T16:00:00.000Z"),
        durationMinutes: 60,
      },
    ]);

    const result = await hasRescheduleConflict(
      transaction as never,
      firestore as never,
      {
        tutorId: "tutor-1",
        bookingId: "booking-1",
        scheduledAt: new Date("2026-09-10T16:00:00.000Z"),
        durationMinutes: 60,
      },
    );

    expect(result).toBe(false);
  });

  it("allows the slot when there are no confirmed bookings", async () => {
    const { firestore, transaction } = createConflictFirestoreMock([]);

    const result = await hasRescheduleConflict(
      transaction as never,
      firestore as never,
      {
        tutorId: "tutor-1",
        bookingId: "booking-1",
        scheduledAt:
          new Date("2026-09-10T16:00:00.000Z"),
        durationMinutes: 60,
      },
    );

    expect(result).toBe(false);
  });
});


// =============================================================
// 6. Successful reschedule transaction:
// =============================================================
function createSuccessfulRescheduleFirestoreMock({
  booking,
  availability,
  conflictingBookings = [],
}: {
  booking: Record<string, unknown>;
  availability: Record<string, unknown>;
  conflictingBookings?: Array<{
    id: string;
    scheduledAt: Date;
    durationMinutes: number;
  }>;
}) {
  const updates: Array<{
    ref: unknown;
    data: Record<string, unknown>;
  }> = [];

  const bookingRef = {
    id: "booking-1",
  };

  const availabilityRef = {
    id: "tutor-1",
  };

  const bookingSnapshot = {
    exists: true,
    data: () => booking,
  };

  const availabilitySnapshot = {
    exists: true,
    data: () => availability,
  };

  const conflictSnapshot = {
    docs: conflictingBookings.map((booking) => ({
      id: booking.id,
      data: () => ({
        scheduledAt: {
          toDate: () => booking.scheduledAt,
        },
        durationMinutes: booking.durationMinutes,
      }),
    })),
  };

  type MockTransaction = {
    get: (ref: unknown) => Promise<unknown>;
    update: (
      ref: unknown,
      data: Record<string, unknown>,
    ) => void;
  };

  const transaction:MockTransaction = {
    get: async (ref: unknown) => {
      if (ref === bookingRef) {
        return bookingSnapshot;
      }

      if (ref === availabilityRef) {
        return availabilitySnapshot;
      }

      return conflictSnapshot;
    },

    update: (
      ref: unknown,
      data: Record<string, unknown>,
    ) => {
      updates.push({
        ref,
        data,
      });
    },
  };

  const firestore = {
    collection: (name: string) => {
      if (name === "bookings") {
        return {
          doc: () => bookingRef,
          where() {
            return this;
          },
        };
      }

      if (name === "tutorAvailability") {
        return {
          doc: () => availabilityRef,
        };
      }

      throw new Error(`Unexpected collection: ${name}`);
    },

    runTransaction: async (
      callback: (transaction: MockTransaction) => Promise<void>,
    ) => {
      await callback(transaction);
    },
  };

  return {
    firestore,
    updates,
  };
}

describe("handleRescheduleBooking - successful reschedule", () => {
  beforeEach(() => {
    vi.useFakeTimers();

    vi.setSystemTime(
      new Date("2026-09-08T12:00:00.000Z"),
    );
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("reschedules the booking and records the audit fields", async () => {
    const originalScheduledAt = new Date("2026-09-10T13:00:00.000Z");

    const newScheduledAt = new Date("2026-09-11T13:00:00.000Z");

    const {
      firestore,
      updates,
    } = createSuccessfulRescheduleFirestoreMock({
      booking: {
        studentId: "student-1",
        tutorId: "tutor-1",
        status: "confirmed",
        scheduledAt: {
          toDate: () => originalScheduledAt,
        },
        durationMinutes: 60,
        teachingMode: "online",
        priceCents: 25000,
        currency: "ZAR",
        tutorName: "Jane Tutor",
        tutorPhotoUrl: null,
      },

      availability: {
        timezone: "Africa/Johannesburg",
        weeklySchedule: {
          "5": [
            {
              start: "09:00",
              end: "17:00",
            },
          ],
        },
      },
    });

    const result = await handleRescheduleBooking(
      {
        auth: {
          uid: "student-1",
        },
        data: {
          bookingId: "booking-1",
          newScheduledAt:
            newScheduledAt.toISOString(),
        },
      },
      firestore as never,
    );

    expect(result).toEqual({
      success: true,
      bookingId: "booking-1",
      status: "confirmed",
    });

    expect(updates).toHaveLength(1);

    const update = updates[0];

    expect(update.ref).toEqual({
      id: "booking-1",
    });

    expect(update.data.scheduledAt).toEqual(
      expect.objectContaining({
        toDate: expect.any(Function),
      }),
    );

    expect(
      update.data.previousScheduledAt,
    ).toEqual(
      expect.objectContaining({
        toDate: expect.any(Function),
      }),
    );

    expect(update.data.updatedAt).toBeInstanceOf(FieldValue);

    expect(update.data.rescheduledAt).toBeInstanceOf(FieldValue);

    expect(update.data.rescheduledBy).toBe(
      "student",
    );
  });

  it("rejects a new scheduled time in the past", async () => {
    const pastDate = new Date(
      Date.now() - 60 * 60 * 1000,
    ).toISOString();
    const request = {
      auth: {
        uid: "student-123",
      },
      data: {
        bookingId: "booking-123",
        newScheduledAt: pastDate,
      },
    };

    const updates: Record<string, unknown>[] = [];

    type MockTransaction2 = {
      get: (ref: unknown) => Promise<unknown>;
      update: (
        ref: unknown,
        data: Record<string, unknown>,
      ) => void;
    };

    const bookingRef = {
      id: "booking-123",
    };

    const transaction: MockTransaction2 = {
      get: async (ref: unknown) => {
        if (ref === bookingRef) {
          return {
            exists: true,
            data: () => ({
              studentId: "student-123",
              tutorId: "tutor-123",
              status: "confirmed",
              scheduledAt: Timestamp.fromDate(
                new Date(
                  "2026-09-10T14:00:00.000Z",
                ),
              ),
              durationMinutes: 60,
            }),
          };
        }

        throw new Error(
          "Unexpected transaction.get()",
        );
      },

      update: (
        ref: unknown,
        data: Record<string, unknown>,
      ) => {
        updates.push(data);
      },
    };

    const firestore = {
      collection: vi.fn(() => ({
        doc: vi.fn(() => bookingRef),
      })),

      runTransaction: async (
        callback: (
          transaction: MockTransaction2,
        ) => Promise<void>,
      ) => {
        await callback(transaction);
      },
    } as unknown as FirebaseFirestore.Firestore;

    await expect(
      handleRescheduleBooking(
        request,
        firestore,
      ),
    ).rejects.toMatchObject({
      code: "invalid-argument",
      message:
        "The new booking time must be in the future.",
    });

    expect(updates).toHaveLength(0);
    //expect(updates).toBeNull();
  });

  it("rejects a reschedule outside the tutor's availability", async () => {
    const originalScheduledAt = new Date(
      "2026-09-10T13:00:00.000Z",
    );

    // 18:00 Johannesburg = 16:00 UTC
    const newScheduledAt = new Date(
      "2026-09-11T16:00:00.000Z",
    );

    const {
      firestore,
      updates,
    } = createSuccessfulRescheduleFirestoreMock({
      booking: {
        studentId: "student-1",
        tutorId: "tutor-1",
        status: "confirmed",
        scheduledAt: {
          toDate: () => originalScheduledAt,
        },
        durationMinutes: 60,
        teachingMode: "online",
        priceCents: 25000,
        currency: "ZAR",
        tutorName: "Jane Tutor",
        tutorPhotoUrl: null,
      },

      availability: {
        timezone: "Africa/Johannesburg",
        weeklySchedule: {
          "5": [
            {
              start: "09:00",
              end: "17:00",
            },
          ],
        },
      },
    });

    await expect(
      handleRescheduleBooking(
        {
          auth: {
            uid: "student-1",
          },
          data: {
            bookingId: "booking-1",
            newScheduledAt:
              newScheduledAt.toISOString(),
          },
        },
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "failed-precondition",
      message:
        "The new time is outside the tutor's availability.",
    });

    expect(updates).toHaveLength(0);
  });

  it("rejects a reschedule that conflicts with another confirmed booking", async () => {
    const originalScheduledAt = new Date(
      "2026-09-10T13:00:00.000Z",
    );

    const newScheduledAt = new Date(
      "2026-09-11T13:00:00.000Z",
    );

    const conflictingBookingStart = new Date(
      "2026-09-11T13:30:00.000Z",
    );

    const {
      firestore,
      updates,
    } = createSuccessfulRescheduleFirestoreMock({
      booking: {
        studentId: "student-1",
        tutorId: "tutor-1",
        status: "confirmed",
        scheduledAt: {
          toDate: () => originalScheduledAt,
        },
        durationMinutes: 60,
        teachingMode: "online",
        priceCents: 25000,
        currency: "ZAR",
        tutorName: "Jane Tutor",
        tutorPhotoUrl: null,
      },

      availability: {
        timezone: "Africa/Johannesburg",
        weeklySchedule: {
          "5": [
            {
              start: "09:00",
              end: "17:00",
            },
          ],
        },
      },

      conflictingBookings: [
        {
          id: "booking-2",
          scheduledAt: conflictingBookingStart,
          durationMinutes: 60,
        },
      ],
    });

    await expect(
      handleRescheduleBooking(
        {
          auth: {
            uid: "student-1",
          },
          data: {
            bookingId: "booking-1",
            newScheduledAt:
              newScheduledAt.toISOString(),
          },
        },
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "already-exists",
      message: "The new time is already booked.",
    });

    expect(updates).toHaveLength(0);
  });

  it("allows rescheduling exactly 24 hours before the lesson", async () => {
    const originalScheduledAt = new Date(
      "2026-09-10T13:00:00.000Z",
    );

    const newScheduledAt = new Date(
      "2026-09-11T13:00:00.000Z",
    );

    const {
      firestore,
      updates,
    } = createSuccessfulRescheduleFirestoreMock({
      booking: {
        studentId: "student-1",
        tutorId: "tutor-1",
        status: "confirmed",
        scheduledAt: {
          toDate: () => originalScheduledAt,
        },
        durationMinutes: 60,
        teachingMode: "online",
        priceCents: 25000,
        currency: "ZAR",
        tutorName: "Jane Tutor",
        tutorPhotoUrl: null,
      },

      availability: {
        timezone: "Africa/Johannesburg",
        weeklySchedule: {
          "5": [
            {
              start: "09:00",
              end: "17:00",
            },
          ],
        },
      },
    });

    vi.setSystemTime(
      new Date(
        originalScheduledAt.getTime() -
          24 * 60 * 60 * 1000,
      ),
    );

    const result = await handleRescheduleBooking(
      {
        auth: {
          uid: "student-1",
        },
        data: {
          bookingId: "booking-1",
          newScheduledAt:
            newScheduledAt.toISOString(),
        },
      },
      firestore as never,
    );

    expect(result).toEqual({
      success: true,
      bookingId: "booking-1",
      status: "confirmed",
    });

    expect(updates).toHaveLength(1);
  });

  it("allows rescheduling more than 24 hours before the lesson", async () => {
    const originalScheduledAt = new Date(
      "2026-09-10T13:00:00.000Z",
    );

    const newScheduledAt = new Date(
      "2026-09-11T13:00:00.000Z",
    );

    const {
      firestore,
      updates,
    } = createSuccessfulRescheduleFirestoreMock({
      booking: {
        studentId: "student-1",
        tutorId: "tutor-1",
        status: "confirmed",
        scheduledAt: {
          toDate: () => originalScheduledAt,
        },
        durationMinutes: 60,
        teachingMode: "online",
        priceCents: 25000,
        currency: "ZAR",
        tutorName: "Jane Tutor",
        tutorPhotoUrl: null,
      },

      availability: {
        timezone: "Africa/Johannesburg",
        weeklySchedule: {
          "5": [
            {
              start: "09:00",
              end: "17:00",
            },
          ],
        },
      },
    });

    vi.setSystemTime(
      new Date(
        originalScheduledAt.getTime() -
          25 * 60 * 60 * 1000,
      ),
    );

    const result = await handleRescheduleBooking(
      {
        auth: {
          uid: "student-1",
        },
        data: {
          bookingId: "booking-1",
          newScheduledAt:
            newScheduledAt.toISOString(),
        },
      },
      firestore as never,
    );

    expect(result).toEqual({
      success: true,
      bookingId: "booking-1",
      status: "confirmed",
    });

    expect(updates).toHaveLength(1);
  });
});
