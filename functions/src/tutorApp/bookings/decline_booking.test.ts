import {describe, expect, it, vi} from "vitest";

import {
  handleDeclineBooking,
  validateDeclineBookingRequest,
} from "./declineBooking";
import { NotificationType } from "../notifications/notification_types";

type MockCallableRequest = {
  auth: {
    uid: string;
  } | null;
  data: unknown;
};

type MockBookingSnapshot = {
  exists: boolean;
  data: () => Record<string, unknown> | undefined;
};

type MockBookingRef = {
  get: ReturnType<typeof vi.fn>;
  update: ReturnType<typeof vi.fn>;
};

type MockFirestore = {
  collection: ReturnType<typeof vi.fn>;
};

// type MockNotificationService = {
//   create: ReturnType<typeof vi.fn>;
// };

function createMockFirestore(
  bookingSnapshot: MockBookingSnapshot,
) {
  const bookingRef: MockBookingRef = {
    get: vi.fn().mockResolvedValue(
      bookingSnapshot,
    ),
    update: vi.fn().mockResolvedValue(undefined),
  };

  const collection = vi.fn().mockReturnValue({
    doc: vi.fn().mockReturnValue(bookingRef),
  });

  const firestore: MockFirestore = {
    collection,
  };

  return {
    firestore,
    bookingRef,
  };
}

const tutorId = "tutor-123";
const bookingId = "booking-123";

function createBookingSnapshot(
  overrides: Record<string, unknown> = {},
): MockBookingSnapshot {
  return {
    exists: true,
    data: () => ({
      tutorId,
      studentId: "student-123",
      status: "pending",
      ...overrides,
    }),
  };
}

function createMockNotifications() {
  return {
    create: vi.fn().mockResolvedValue("notification-123"),
  };
}

describe("validateDeclineBookingRequest", () => {
  it("rejects null", () => {
    expect(() =>
      validateDeclineBookingRequest(null),
    ).toThrow();
  });

  it("rejects non-object data", () => {
    expect(() =>
      validateDeclineBookingRequest("invalid"),
    ).toThrow();
  });

  it("rejects missing bookingId", () => {
    expect(() =>
      validateDeclineBookingRequest({}),
    ).toThrow();
  });

  it("rejects empty bookingId", () => {
    expect(() =>
      validateDeclineBookingRequest({
        bookingId: "",
      }),
    ).toThrow();
  });

  it("rejects whitespace bookingId", () => {
    expect(() =>
      validateDeclineBookingRequest({
        bookingId: "   ",
      }),
    ).toThrow();
  });

  it("rejects non-string bookingId", () => {
    expect(() =>
      validateDeclineBookingRequest({
        bookingId: 123,
      }),
    ).toThrow();
  });

  it("trims the bookingId", () => {
    expect(
      validateDeclineBookingRequest({
        bookingId: "  booking-123  ",
      }),
    ).toEqual({
      bookingId: "booking-123",
    });
  });
});

describe("handleDeclineBooking", () => {
  it("rejects unauthenticated requests", async () => {
    const request: MockCallableRequest = {
      auth: null,
      data: {
        bookingId,
      },
    };

    const {firestore} =
      createMockFirestore(
        createBookingSnapshot(),
      );

    await expect(
      handleDeclineBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "unauthenticated",
    });
  });

  it("rejects missing bookingId", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {},
    };

    const {firestore} =
      createMockFirestore(
        createBookingSnapshot(),
      );

    await expect(
      handleDeclineBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "invalid-argument",
    });
  });

  it("rejects when booking does not exist", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
      },
    };

    const {firestore} =
      createMockFirestore({
        exists: false,
        data: () => undefined,
      });

    await expect(
      handleDeclineBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "not-found",
    });
  });

  it("rejects when the tutor does not own the booking", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
      },
    };

    const {firestore} =
      createMockFirestore(
        createBookingSnapshot({
          tutorId: "different-tutor",
        }),
      );

    await expect(
      handleDeclineBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "permission-denied",
    });
  });

  it("rejects a confirmed booking", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
      },
    };

    const {firestore} =
      createMockFirestore(
        createBookingSnapshot({
          status: "confirmed",
        }),
      );

    await expect(
      handleDeclineBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "failed-precondition",
    });
  });

  it("rejects a cancelled booking", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
      },
    };

    const {firestore} =
      createMockFirestore(
        createBookingSnapshot({
          status: "cancelled",
        }),
      );

    await expect(
      handleDeclineBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "failed-precondition",
    });
  });

  it("rejects an already declined booking", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
      },
    };

    const {firestore} =
      createMockFirestore(
        createBookingSnapshot({
          status: "declined",
        }),
      );

    await expect(
      handleDeclineBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "failed-precondition",
    });
  });

  it("trims the bookingId before reading the booking", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId: "  booking-123  ",
      },
    };

    const {
      firestore,
      bookingRef,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    await handleDeclineBooking(
      request,
      firestore as never,
    );

    expect(
      firestore.collection,
    ).toHaveBeenCalledWith("bookings");

    expect(
      bookingRef.get,
    ).toHaveBeenCalledTimes(1);
  });

  it("declines a pending booking", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
      },
    };

    const {
      firestore,
      bookingRef,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    const result =
      await handleDeclineBooking(
        request,
        firestore as never,
      );

    expect(
      bookingRef.update,
    ).toHaveBeenCalledTimes(1);

    expect(result).toEqual({
      success: true,
      bookingId,
      status: "declined",
    });
  });

  it("sets the status to declined", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
      },
    };

    const {
      firestore,
      bookingRef,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    await handleDeclineBooking(
      request,
      firestore as never,
    );

    expect(
      bookingRef.update,
    ).toHaveBeenCalledWith(
      expect.objectContaining({
        status: "declined",
      }),
    );
  });

  it("sets respondedAt", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
      },
    };

    const {
      firestore,
      bookingRef,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    await handleDeclineBooking(
      request,
      firestore as never,
    );

    expect(
      bookingRef.update,
    ).toHaveBeenCalledWith(
      expect.objectContaining({
        respondedAt:
          expect.anything(),
      }),
    );
  });

  it("sets updatedAt", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
      },
    };

    const {
      firestore,
      bookingRef,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    await handleDeclineBooking(
      request,
      firestore as never,
    );

    expect(
      bookingRef.update,
    ).toHaveBeenCalledWith(
      expect.objectContaining({
        updatedAt:
          expect.anything(),
      }),
    );
  });

  it("does not update the booking when ownership fails", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
      },
    };

    const {
      firestore,
      bookingRef,
    } = createMockFirestore(
      createBookingSnapshot({
        tutorId: "other-tutor",
      }),
    );

    await expect(
      handleDeclineBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "permission-denied",
    });

    expect(
      bookingRef.update,
    ).not.toHaveBeenCalled();
  });

  it("does not update a non-pending booking", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
      },
    };

    const {
      firestore,
      bookingRef,
    } = createMockFirestore(
      createBookingSnapshot({
        status: "confirmed",
      }),
    );

    await expect(
      handleDeclineBooking(
        request,
        firestore as never,
      ),
    ).rejects.toMatchObject({
      code: "failed-precondition",
    });

    expect(
      bookingRef.update,
    ).not.toHaveBeenCalled();
  });

  it("uses the authenticated tutor ID rather than a client tutor ID", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
        tutorId: "attacker-tutor",
      },
    };

    const {
      firestore,
      bookingRef,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    await handleDeclineBooking(
      request,
      firestore as never,
    );

    expect(
      bookingRef.update,
    ).toHaveBeenCalledTimes(1);
  });

  it("creates a notification for the student after declining", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
      },
    };

    const {
      firestore,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    const notifications = createMockNotifications();

    await handleDeclineBooking(
      request,
      firestore as never,
      notifications,
    );

    expect(
      notifications.create,
    ).toHaveBeenCalledWith({
      studentId: "student-123",
      type: NotificationType.tutorBookingDeclined,
      title: "Tutor booking declined",
      body:
        "Your tutor is unable to accept your booking.",
      target: {
        feature: "booking",
        resourceId: bookingId,
      },
    });
  });

  it("does not fail the decline when notification creation fails", async () => {
    const request: MockCallableRequest = {
      auth: {uid: tutorId},
      data: {
        bookingId,
      },
    };

    const {
      firestore,
      bookingRef,
    } = createMockFirestore(
      createBookingSnapshot(),
    );

    const notifications = createMockNotifications();

    notifications.create.mockRejectedValue(
      new Error("FCM unavailable"),
    );

    const result =
      await handleDeclineBooking(
        request,
        firestore as never,
        notifications,
      );

    expect(result).toEqual({
      success: true,
      bookingId,
      status: "declined",
    });

    expect(
      bookingRef.update,
    ).toHaveBeenCalled();
  });
});
