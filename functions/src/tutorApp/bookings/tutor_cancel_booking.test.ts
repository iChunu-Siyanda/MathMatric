import {describe, expect, it, vi} from "vitest";
import {handleTutorCancelBooking,validateTutorCancelBookingRequest,} from "./tutorCancelBooking";
import { NotificationType } from "../notifications/notification_types";

type MockCallableRequest = {
  auth?: {uid: string} | null;
  data: unknown;
};

type MockDocumentSnapshot = {
  exists: boolean;
  data: () => Record<string, unknown> | undefined;
};

type MockTransaction = {
  get: ReturnType<typeof vi.fn>;
  update: ReturnType<typeof vi.fn>;
};

// type MockNotificationService = {
//   create: ReturnType<typeof vi.fn>;
// };

function createMockNotifications() {
  return {
    create: vi.fn().mockResolvedValue(
      "notification-123",
    ),
  };
}

const tutorId = "tutor-123";
const bookingId = "booking-123";

function createBookingSnapshot(
  overrides: Record<string, unknown> = {},
): MockDocumentSnapshot {
  return {
    exists: true,
    data: () => ({
      tutorId,
      studentId: "student-123",
      status: "confirmed",
      scheduledAt: new Date(
        "2026-09-10T16:00:00.000Z",
      ),
      durationMinutes: 60,
      ...overrides,
    }),
  };
}

function createMissingBookingSnapshot(): MockDocumentSnapshot {
  return {
    exists: false,
    data: () => undefined,
  };
}

function createMockFirestore(
  bookingSnapshot: MockDocumentSnapshot,
) {
  const bookingRef = {
    get: vi.fn(),
    update: vi.fn(),
  };

  const transaction: MockTransaction = {
    get: vi.fn().mockResolvedValue(
      bookingSnapshot,
    ),
    update: vi.fn(),
  };

  const firestore = {
    collection: vi.fn(
      (collectionName: string) => {
        if (collectionName !== "bookings") {
          throw new Error(
            `Unexpected collection: ${collectionName}`,
          );
        }

        return {
          doc: vi.fn().mockReturnValue(
            bookingRef,
          ),
        };
      },
    ),

    runTransaction: vi.fn(
      async (
        callback: (
          transaction: MockTransaction,
        ) => Promise<unknown>,
      ) => callback(transaction),
    ),
  };

  return {
    firestore,
    bookingRef,
    transaction,
  };
}

describe("validateTutorCancelBookingRequest", () => {
  it("rejects null data", () => {
    expect(() =>
      validateTutorCancelBookingRequest(null),
    ).toThrow();
  });

  it("rejects non-object data", () => {
    expect(() =>
      validateTutorCancelBookingRequest("invalid"),
    ).toThrow();
  });

  it("rejects missing bookingId", () => {
    expect(() =>
      validateTutorCancelBookingRequest({
        reason: "emergency",
        comment: null,
      }),
    ).toThrow();
  });

  it("rejects empty bookingId", () => {
    expect(() =>
      validateTutorCancelBookingRequest({
        bookingId: "",
        reason: "emergency",
        comment: null,
      }),
    ).toThrow();
  });

  it("rejects whitespace-only bookingId", () => {
    expect(() =>
      validateTutorCancelBookingRequest({
        bookingId: "   ",
        reason: "emergency",
        comment: null,
      }),
    ).toThrow();
  });

  it("rejects non-string bookingId", () => {
    expect(() =>
      validateTutorCancelBookingRequest({
        bookingId: 123,
        reason: "emergency",
        comment: null,
      }),
    ).toThrow();
  });

  it("trims bookingId", () => {
    const result =
      validateTutorCancelBookingRequest({
        bookingId: "  booking-123  ",
        reason: "emergency",
        comment: null,
      });

    expect(result.bookingId).toBe(
      "booking-123",
    );
  });

  it("rejects missing reason", () => {
    expect(() =>
      validateTutorCancelBookingRequest({
        bookingId,
        comment: null,
      }),
    ).toThrow();
  });

  it("rejects empty reason", () => {
    expect(() =>
      validateTutorCancelBookingRequest({
        bookingId,
        reason: "",
        comment: null,
      }),
    ).toThrow();
  });

  it("rejects whitespace-only reason", () => {
    expect(() =>
      validateTutorCancelBookingRequest({
        bookingId,
        reason: "   ",
        comment: null,
      }),
    ).toThrow();
  });

  it("rejects non-string reason", () => {
    expect(() =>
      validateTutorCancelBookingRequest({
        bookingId,
        reason: 123,
        comment: null,
      }),
    ).toThrow();
  });

  it("rejects an invalid cancellation reason", () => {
    expect(() =>
      validateTutorCancelBookingRequest({
        bookingId,
        reason: "invalidReason",
        comment: null,
      }),
    ).toThrow();
  });

  it("accepts a valid cancellation reason", () => {
    const result =
      validateTutorCancelBookingRequest({
        bookingId,
        reason: "emergency",
        comment: null,
      });

    expect(result.reason).toBe(
      "emergency",
    );
  });

  it("trims the cancellation reason", () => {
    const result =
      validateTutorCancelBookingRequest({
        bookingId,
        reason: "  emergency  ",
        comment: null,
      });

    expect(result.reason).toBe(
      "emergency",
    );
  });

  it("accepts a null comment", () => {
    const result =
      validateTutorCancelBookingRequest({
        bookingId,
        reason: "emergency",
        comment: null,
      });

    expect(result.comment).toBeNull();
  });

  it("accepts an undefined comment", () => {
    const result =
      validateTutorCancelBookingRequest({
        bookingId,
        reason: "emergency",
      });

    expect(result.comment).toBeNull();
  });

  it("accepts a string comment", () => {
    const result =
      validateTutorCancelBookingRequest({
        bookingId,
        reason: "emergency",
        comment: "Unexpected emergency.",
      });

    expect(result.comment).toBe(
      "Unexpected emergency.",
    );
  });

  it("trims the comment", () => {
    const result =
      validateTutorCancelBookingRequest({
        bookingId,
        reason: "emergency",
        comment:
          "  Unexpected emergency.  ",
      });

    expect(result.comment).toBe(
      "Unexpected emergency.",
    );
  });

  it("rejects a non-string non-null comment", () => {
    expect(() =>
      validateTutorCancelBookingRequest({
        bookingId,
        reason: "emergency",
        comment: 123,
      }),
    ).toThrow();
  });
});

describe("tutorCancelBooking", () => {
  it("rejects unauthenticated requests", async () => {
    const request: MockCallableRequest = {
      auth: null,
      data: {
        bookingId,
        reason: "emergency",
        comment: null,
      },
    };

    const {
      firestore,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    await expect(
      handleTutorCancelBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "unauthenticated",
    });
  });

  it("rejects missing booking", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "emergency",
        comment: null,
      },
    };

    const {
      firestore,
      transaction,
    } = createMockFirestore(
      createMissingBookingSnapshot(),
    );

    await expect(
      handleTutorCancelBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "not-found",
    });

    expect(
      transaction.update,
    ).not.toHaveBeenCalled();
  });

  it("rejects when booking data is missing", async () => {
    const bookingSnapshot: MockDocumentSnapshot = {
      exists: true,
      data: () => undefined,
    };

    const {
      firestore,
      transaction,
    } = createMockFirestore(
      bookingSnapshot,
    );

    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "emergency",
        comment: null,
      },
    };

    await expect(
      handleTutorCancelBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "not-found",
    });

    expect(
      transaction.update,
    ).not.toHaveBeenCalled();
  });

  it("rejects when the tutor does not own the booking", async () => {
    const {
      firestore,
      transaction,
    } = createMockFirestore(
      createBookingSnapshot({
        tutorId: "different-tutor",
      }),
    );

    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "emergency",
        comment: null,
      },
    };

    await expect(
      handleTutorCancelBooking(
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

  it("rejects pending bookings", async () => {
    const {
      firestore,
      transaction,
    } = createMockFirestore(
      createBookingSnapshot({
        status: "pending",
      }),
    );

    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "emergency",
        comment: null,
      },
    };

    await expect(
      handleTutorCancelBooking(
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

  it("rejects already cancelled bookings", async () => {
    const {
      firestore,
      transaction,
    } = createMockFirestore(
      createBookingSnapshot({
        status: "cancelled",
      }),
    );

    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "emergency",
        comment: null,
      },
    };

    await expect(
      handleTutorCancelBooking(
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

  it("rejects declined bookings", async () => {
    const {
      firestore,
      transaction,
    } = createMockFirestore(
      createBookingSnapshot({
        status: "declined",
      }),
    );

    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "emergency",
        comment: null,
      },
    };

    await expect(
      handleTutorCancelBooking(
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

  it("ignores a client-supplied tutorId", async () => {
    const {
      firestore,
      bookingRef,
      transaction,
    } = createMockFirestore(
      createBookingSnapshot({
        tutorId,
      }),
    );

    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "emergency",
        comment: null,
        tutorId: "malicious-tutor",
      },
    };

    const result =
      await handleTutorCancelBooking(
        request,
        firestore as never,
      );

    expect(result).toEqual({
      success: true,
      bookingId,
      status: "cancelled",
    });

    expect(
      transaction.update,
    ).toHaveBeenCalledWith(
      bookingRef,
      expect.objectContaining({
        status: "cancelled",
        cancelledBy: "tutor",
      }),
    );
  });

  it("trims the bookingId before using it", async () => {
    const {
      firestore,
      bookingRef,
      transaction,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId: "  booking-123  ",
        reason: "emergency",
        comment: null,
      },
    };

    const result =
      await handleTutorCancelBooking(
        request,
        firestore as never,
      );

    expect(result).toEqual({
      success: true,
      bookingId,
      status: "cancelled",
    });

    expect(
      transaction.update,
    ).toHaveBeenCalledWith(
      bookingRef,
      expect.objectContaining({
        status: "cancelled",
      }),
    );
  });

  it("writes the correct cancellation audit fields", async () => {
    const {
      firestore,
      bookingRef,
      transaction,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "emergency",
        comment: "Unexpected emergency.",
      },
    };

    await handleTutorCancelBooking(
      request,
      firestore as never,
    );

    expect(
      transaction.update,
    ).toHaveBeenCalledWith(
      bookingRef,
      expect.objectContaining({
        status: "cancelled",
        cancelledAt: expect.anything(),
        cancelledBy: "tutor",
        cancellationReason: "emergency",
        cancellationComment:
          "Unexpected emergency.",
        updatedAt: expect.anything(),
      }),
    );
  });

  it("writes a null cancellation comment when none is provided", async () => {
    const {
      firestore,
      bookingRef,
      transaction,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "emergency",
        comment: null,
      },
    };

    await handleTutorCancelBooking(
      request,
      firestore as never,
    );

    expect(
      transaction.update,
    ).toHaveBeenCalledWith(
      bookingRef,
      expect.objectContaining({
        cancellationComment: null,
      }),
    );
  });

  it("does not update the booking when validation fails", async () => {
    const {
      firestore,
      transaction,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "invalidReason",
        comment: null,
      },
    };

    await expect(
      handleTutorCancelBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "invalid-argument",
    });

    expect(
      transaction.update,
    ).not.toHaveBeenCalled();

    expect(
      firestore.runTransaction,
    ).not.toHaveBeenCalled();
  });

  it("does not update the booking when the booking cannot be cancelled", async () => {
    const {
      firestore,
      transaction,
    } = createMockFirestore(
      createBookingSnapshot({
        status: "pending",
      }),
    );

    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "emergency",
        comment: null,
      },
    };

    await expect(
      handleTutorCancelBooking(
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

  it("uses a transaction to cancel the booking", async () => {
    const {
      firestore,
      bookingRef,
      transaction,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "emergency",
        comment: null,
      },
    };

    await handleTutorCancelBooking(
      request,
      firestore as never,
    );

    expect(
      firestore.runTransaction,
    ).toHaveBeenCalledTimes(1);

    expect(
      transaction.get,
    ).toHaveBeenCalledWith(
      bookingRef,
    );

    expect(
      transaction.update,
    ).toHaveBeenCalledWith(
      bookingRef,
      expect.objectContaining({
        status: "cancelled",
        cancelledBy: "tutor",
      }),
    );
  });

  it("returns a successful cancellation response", async () => {
    const {
      firestore,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "emergency",
        comment: null,
      },
    };

    const result =
      await handleTutorCancelBooking(
        request,
        firestore as never,
      );

    expect(result).toEqual({
      success: true,
      bookingId,
      status: "cancelled",
    });
  });

  it("does not use bookingRef.update directly", async () => {
    const {
      firestore,
      bookingRef,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "emergency",
        comment: null,
      },
    };

    await handleTutorCancelBooking(
      request,
      firestore as never,
    );

    expect(
      bookingRef.update,
    ).not.toHaveBeenCalled();
  });

  it("creates a notification for the student after tutor cancellation", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "emergency",
        comment: null,
      },
    };

    const {firestore} = createMockFirestore(
      createBookingSnapshot(),
    );

    const notifications = createMockNotifications();

    await handleTutorCancelBooking(
      request,
      firestore as never,
      notifications,
    );

    expect(
      notifications.create,
    ).toHaveBeenCalledWith({
      studentId: "student-123",
      type: NotificationType.tutorBookingCancelled,
      title: "Tutor cancelled your booking",
      body: "Your tutor has cancelled your booking.",
      target: {
        feature: "booking",
        resourceId: bookingId,
      },
    });
  });

  it("does not fail the cancellation when notification creation fails", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        reason: "emergency",
        comment: null,
      },
    };

    const {
      firestore,
      bookingRef,
      transaction,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    const notifications = createMockNotifications();

    notifications.create.mockRejectedValue(
      new Error("FCM unavailable"),
    );

    const result =
      await handleTutorCancelBooking(
        request,
        firestore as never,
        notifications,
      );

    expect(result).toEqual({
      success: true,
      bookingId,
      status: "cancelled",
    });

    expect(
      transaction.update,
    ).toHaveBeenCalledWith(
      bookingRef,
      expect.objectContaining({
        status: "cancelled",
        cancelledBy: "tutor",
      }),
    );

    expect(
      notifications.create,
    ).toHaveBeenCalled();
  });
});
