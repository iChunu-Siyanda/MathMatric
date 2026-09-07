import { describe, expect, it, vi } from "vitest";
import {handleAcceptBooking,} from "./acceptBooking";
import { Timestamp } from "firebase-admin/firestore";
import { NotificationType } from "../../notifications/notification_types";

type MockTransaction = {
  get: ReturnType<typeof vi.fn>;
  update: ReturnType<typeof vi.fn>;
  set: ReturnType<typeof vi.fn>;
  delete: ReturnType<typeof vi.fn>;
};

type MockCallableRequest = {
  auth: {
    uid: string;
  } | null;
  data: unknown;
};

type MockDocumentSnapshot = {
  exists: boolean;
  data: () => Record<string, unknown> | undefined;
};

type MockQuerySnapshot = {
  docs: Array<{
    data: () => Record<string, unknown>;
  }>;
};

type MockTransaction1 = {
  get: ReturnType<typeof vi.fn>;
  update: ReturnType<typeof vi.fn>;
};

describe("acceptBooking", () => {
  function createBookingData(
    overrides: Record<string, unknown> = {},
  ) {
    const scheduledAt = new Date(
      "2026-09-15T14:00:00.000Z",
    );

    return {
      tutorId: "tutor-123",
      studentId: "student-123",
      status: "pending",
      scheduledAt: {
        toDate: () => scheduledAt,
      },
      durationMinutes: 60,
      ...overrides,
    };
  }

  function createMockFirestore(
    options: {
      bookingExists?: boolean;
      bookingData?: Record<string, unknown>;
      confirmedBookings?: Record<string, unknown>[];
    } = {},
  ) {
    const {
      bookingExists = true,
      bookingData = createBookingData(),
      confirmedBookings = [],
    } = options;

    const bookingRef = {
      id: "booking-123",
    };

    const bookingSnapshot = {
      exists: bookingExists,
      data: () =>
        bookingExists
          ? bookingData
          : undefined,
    };

    const confirmedDocs = confirmedBookings.map((data, index) => ({
        id: `confirmed-${index}`,
        data: () => data,
      }));

    const tutorAvailabilitySnapshot = {
      exists: true,
      data: () => ({
        tutorId: "tutor-123",
        timezone: "Africa/Johannesburg",
        weeklySchedule: {},
      }),
    };  

    const confirmedSnapshot = {
      docs: confirmedDocs,
    };

    const transaction: MockTransaction = {
      get: vi.fn()
        .mockResolvedValueOnce(bookingSnapshot)
        .mockResolvedValueOnce(tutorAvailabilitySnapshot)
        .mockResolvedValueOnce(confirmedSnapshot),

      update: vi.fn(),

      set: vi.fn(),

      delete: vi.fn(),
    };

    const confirmedQuery = {
      where: vi.fn().mockReturnThis(),
    };

    const bookingsCollection = {
      doc: vi.fn().mockReturnValue(bookingRef),

      where: vi.fn().mockReturnValue(
        confirmedQuery,
      ),
    };

    const firestore = {
      collection: vi.fn().mockReturnValue(
        bookingsCollection,
      ),

      runTransaction: vi.fn(
        async (
          callback: (
            transaction: MockTransaction,
          ) => Promise<unknown>,
        ) => {
          return callback(transaction);
        },
      ),
    };

    return {
      firestore,
      transaction,
      bookingRef,
      bookingsCollection,
      confirmedQuery,
    };
  }

  function createMockFirestore1(
    bookingSnapshot: MockDocumentSnapshot,
    tutorAvailabilitySnapshot: MockDocumentSnapshot,
    confirmedBookingsSnapshot: MockQuerySnapshot,
  ) {
    const bookingRef = {
      get: vi.fn(),
      update: vi.fn(),
    };

    const tutorAvailabilityRef = {
      get: vi.fn(),
    };

    const bookingQuery = {
      where: vi.fn().mockReturnThis(),
    };

    const transaction: MockTransaction1 = {
      get: vi.fn()
        .mockResolvedValueOnce(bookingSnapshot)
        .mockResolvedValueOnce(tutorAvailabilitySnapshot)
        .mockResolvedValueOnce(confirmedBookingsSnapshot),

      update: vi.fn(),
    };

    const firestore = {
      collection: vi.fn((collectionName: string) => {
        if (collectionName === "bookings") {
          return {
            doc: vi.fn().mockReturnValue(bookingRef),
            where: vi.fn().mockReturnValue(bookingQuery),
          };
        }

        if (collectionName === "tutorAvailability") {
          return {
            doc: vi.fn().mockReturnValue(
              tutorAvailabilityRef,
            ),
          };
        }

        throw new Error(
          `Unexpected collection: ${collectionName}`,
        );
      }),

      runTransaction: vi.fn(
        async (
          callback: (
            transaction: MockTransaction1,
          ) => Promise<unknown>,
        ) => callback(transaction),
      ),
    };

    return {
      firestore,
      bookingRef,
      tutorAvailabilityRef,
      transaction,
    };
  }

  function createRequest(
    overrides: Partial<MockCallableRequest> = {},
  ): MockCallableRequest {
    return {
      auth: {
        uid: "tutor-123",
      },
      data: {
        bookingId: "booking-123",
      },
      ...overrides,
    };
  }

  function createMockNotifications() {
    return {
      create: vi.fn().mockResolvedValue("notification-123"),
    };
  }

  function createBookingSnapshot(
    overrides: Record<string, unknown> = {},
  ): MockDocumentSnapshot {
    return {
      exists: true,
      data: () => ({
        tutorId: "tutor-123",
        studentId: "student-123",
        status: "pending",
        scheduledAt: Timestamp.fromDate(
          new Date("2026-09-10T16:00:00.000Z"),
        ),
        durationMinutes: 60,
        ...overrides,
      }),
    };
  }

  function createTutorAvailabilitySnapshot(
    overrides: Record<string, unknown> = {},
  ): MockDocumentSnapshot {
    return {
      exists: true,
      data: () => ({
        tutorId: "tutor-123",
        timezone: "Africa/Johannesburg",
        weeklySchedule: {},
        ...overrides,
      }),
    };
  }

  function createConfirmedBookingsSnapshot(
    bookings: Record<string, unknown>[] = [],
  ): MockQuerySnapshot {
    return {
      docs: bookings.map((booking) => ({
        data: () => booking,
      })),
    };
  }

  it("rejects unauthenticated requests", async () => {
    const {
      firestore,
    } = createMockFirestore();

    const request = createRequest({
      auth: null,
    });

    await expect(
      handleAcceptBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "unauthenticated",
    });

    expect(
      firestore.runTransaction,
    ).not.toHaveBeenCalled();
  });

  it("rejects when bookingId is missing", async () => {
    const {
      firestore,
    } = createMockFirestore();

    const request = createRequest({
      data: {},
    });

    await expect(
      handleAcceptBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "invalid-argument",
    });

    expect(
      firestore.runTransaction,
    ).not.toHaveBeenCalled();
  });

  it("rejects an empty bookingId", async () => {
    const {
      firestore,
    } = createMockFirestore();

    const request = createRequest({
      data: {
        bookingId: "   ",
      },
    });

    await expect(
      handleAcceptBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "invalid-argument",
    });

    expect(
      firestore.runTransaction,
    ).not.toHaveBeenCalled();
  });

  it("trims the bookingId", async () => {
    const {
      firestore,
      bookingsCollection,
    } = createMockFirestore();

    const request = createRequest({
      data: {
        bookingId: "  booking-123  ",
      },
    });

    await handleAcceptBooking(
      request,
      firestore as never,
    );

    expect(
      bookingsCollection.doc,
    ).toHaveBeenCalledWith(
      "booking-123",
    );
  });

  it("rejects when booking does not exist", async () => {
    const {
      firestore,
    } = createMockFirestore({
      bookingExists: false,
    });

    const request = createRequest();

    await expect(
      handleAcceptBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "not-found",
    });

    expect(
      firestore.runTransaction,
    ).toHaveBeenCalledOnce();
  });

  it("rejects when tutor does not own the booking", async () => {
    const {
      firestore,
      transaction,
    } = createMockFirestore({
      bookingData: createBookingData({
        tutorId: "different-tutor",
      }),
    });

    const request = createRequest();

    await expect(
      handleAcceptBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "permission-denied",
    });

    expect(
      transaction.update,
    ).not.toHaveBeenCalled();
  });

  it("rejects when booking is not pending", async () => {
    const {
      firestore,
      transaction,
    } = createMockFirestore({
      bookingData: createBookingData({
        status: "confirmed",
      }),
    });

    const request = createRequest();

    await expect(
      handleAcceptBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "failed-precondition",
    });

    expect(
      transaction.update,
    ).not.toHaveBeenCalled();
  });

  it("rejects when booking is cancelled", async () => {
    const {
      firestore,
      transaction,
    } = createMockFirestore({
      bookingData: createBookingData({
        status: "cancelled",
      }),
    });

    const request = createRequest();

    await expect(
      handleAcceptBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "failed-precondition",
    });

    expect(
      transaction.update,
    ).not.toHaveBeenCalled();
  });

  it("rejects when an existing confirmed booking overlaps", async () => {
    const existingStart =
      new Date(
        "2026-09-15T14:30:00.000Z",
      );

    const {
      firestore,
      transaction,
    } = createMockFirestore({
      confirmedBookings: [
        {
          tutorId: "tutor-123",
          status: "confirmed",
          scheduledAt: {
            toDate: () => existingStart,
          },
          durationMinutes: 60,
        },
      ],
    });

    const request = createRequest();

    await expect(
      handleAcceptBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "already-exists",
    });

    expect(
      transaction.update,
    ).not.toHaveBeenCalled();
  });

  it("allows a booking when the existing booking ends exactly when the new one starts", async () => {
    const existingStart = new Date(
        "2026-09-15T13:00:00.000Z",
      );

    const {
      firestore,
      transaction,
    } = createMockFirestore({
      confirmedBookings: [
        {
          tutorId: "tutor-123",
          status: "confirmed",
          scheduledAt: {
            toDate: () => existingStart,
          },
          durationMinutes: 60,
        },
      ],
    });

    const request = createRequest();

    const notifications = createMockNotifications();

    const result = await handleAcceptBooking(
        request,
        firestore as never,
        notifications,
      );

    expect(result).toEqual({
      bookingId: "booking-123",
      status: "confirmed",
      studentId: "student-123",
    });

    expect(
      transaction.update,
    ).toHaveBeenCalledOnce();
  });

  it("allows a booking when there is no confirmed conflict", async () => {
    const {
      firestore,
      transaction,
    } = createMockFirestore();

    const request = createRequest();

    const notifications = createMockNotifications();

    const result = await handleAcceptBooking(
        request,
        firestore as never,
        notifications
      );

    expect(result).toEqual({
      bookingId: "booking-123",
      status: "confirmed",
      studentId: "student-123",
    });

    expect(
      firestore.runTransaction,
    ).toHaveBeenCalledOnce();

    expect(
      transaction.update,
    ).toHaveBeenCalledOnce();
  });

  it("updates the booking to confirmed", async () => {
    const {
      firestore,
      transaction,
      bookingRef,
    } = createMockFirestore();

    const request = createRequest();

    const notifications = createMockNotifications();

    await handleAcceptBooking(
      request,
      firestore as never,
      notifications,
    );

    expect(
      transaction.update,
    ).toHaveBeenCalledWith(
      bookingRef,
      expect.objectContaining({
        status: "confirmed",
      }),
    );
  });

  it("sets respondedAt when accepting the booking", async () => {
    const {
      firestore,
      transaction,
    } = createMockFirestore();

    const request = createRequest();

    await handleAcceptBooking(
      request,
      firestore as never,
    );

    expect(
      transaction.update,
    ).toHaveBeenCalledWith(
      expect.anything(),
      expect.objectContaining({
        respondedAt:
          expect.anything(),
      }),
    );
  });

  it("sets updatedAt when accepting the booking", async () => {
    const {
      firestore,
      transaction,
    } = createMockFirestore();

    const request = createRequest();

    await handleAcceptBooking(
      request,
      firestore as never,
    );

    expect(
      transaction.update,
    ).toHaveBeenCalledWith(
      expect.anything(),
      expect.objectContaining({
        updatedAt:
          expect.anything(),
      }),
    );
  });

  it("does not update the booking when there is a conflict", async () => {
    const {
      firestore,
      transaction,
    } = createMockFirestore({
      confirmedBookings: [
        {
          tutorId: "tutor-123",
          status: "confirmed",
          scheduledAt: {
            toDate: () =>
              new Date(
                "2026-09-15T14:30:00.000Z",
              ),
          },
          durationMinutes: 60,
        },
      ],
    });

    const request = createRequest();

    await expect(
      handleAcceptBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "already-exists",
    });

    expect(
      transaction.update,
    ).not.toHaveBeenCalled();
  });

  it("does not update the booking when tutor does not own it", async () => {
    const {
      firestore,
      transaction,
    } = createMockFirestore({
      bookingData: createBookingData({
        tutorId: "different-tutor",
      }),
    });

    const request = createRequest();

    await expect(
      handleAcceptBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "permission-denied",
    });

    expect(
      transaction.update,
    ).not.toHaveBeenCalled();
  });

  it("does not update the booking when it is not pending", async () => {
    const {
      firestore,
      transaction,
    } = createMockFirestore({
      bookingData: createBookingData({
        status: "declined",
      }),
    });

    const request = createRequest();

    await expect(
      handleAcceptBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "failed-precondition",
    });

    expect(
      transaction.update,
    ).not.toHaveBeenCalled();
  });

  it("returns the accepted booking result", async () => {
    const {
      firestore,
    } = createMockFirestore();

    const request = createRequest();

    const notifications = createMockNotifications();

    const result = await handleAcceptBooking(
        request,
        firestore as never,
        notifications,
      );

    expect(result).toEqual({
      bookingId: "booking-123",
      status: "confirmed",
      studentId: "student-123",
    });
  });

  it("creates a notification for the student after accepting", async () => {
    const request: MockCallableRequest = {
      auth: {uid: "tutor-123"},
      data: {
        bookingId: "booking-123",
      },
    };

    const {
      firestore,
    } = createMockFirestore1(
      createBookingSnapshot(),
      createTutorAvailabilitySnapshot(),
      createConfirmedBookingsSnapshot(),
    );

    const notifications = createMockNotifications();

    await handleAcceptBooking(
      request,
      firestore as never,
      notifications,
    );

    expect(
      notifications.create,
    ).toHaveBeenCalledWith({
      studentId: "student-123",
      type:NotificationType.tutorBookingAccepted,
      title: "Tutor booking accepted",
      body:
        "Your tutor has accepted your booking.",
      target: {
        feature: "booking",
        resourceId: "booking-123",
      },
    });
  });

  it("does not fail the booking when notification creation fails", async () => {
    const request: MockCallableRequest = {
      auth: {uid: "tutor-123"},
      data: {
        bookingId: "booking-123",
      },
    };

    const {
      firestore,
      bookingRef,
      transaction,
    } = createMockFirestore1(
      createBookingSnapshot(),
      createTutorAvailabilitySnapshot(),
      createConfirmedBookingsSnapshot(),
    );

    const notifications = createMockNotifications();

    notifications.create.mockRejectedValue(
      new Error("FCM unavailable"),
    );

    const result = await handleAcceptBooking(
        request,
        firestore as never,
        notifications,
      );

    expect(result).toEqual({
      bookingId: "booking-123",
      status: "confirmed",
      studentId: "student-123",
    });
    
    expect(transaction.update).toHaveBeenCalledWith(
      bookingRef,
      expect.objectContaining({
        status: "confirmed",
      }),
    );
  });
});
