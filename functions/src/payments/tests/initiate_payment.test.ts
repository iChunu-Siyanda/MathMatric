import { beforeEach, describe, expect, it, vi } from "vitest";

vi.mock("../students/student_account_service", () => ({
  getStudentAccount: vi.fn(),
}));

const { createPayment } = vi.hoisted(() => ({
  createPayment: vi.fn(),
}));

vi.mock("./payment_service", () => ({
  PaymentService: class {
    createPayment = createPayment;
  },
}));

import { initiatePayment } from "../payment/initiate_payment";
import { PaymentStatus } from "../payment/payment_entity";
//import { BookingStatus } from "../bookings/booking_status";
import { getStudentAccount } from "../../students/student_account_service";

describe("initiatePayment", () => {
  const studentId = "student-123";
  const bookingId = "booking-123";

  const payment = {
    id: bookingId,
    bookingId,
    studentId,
    tutorId: "tutor-123",

    amountCents: 35000,
    currency: "ZAR",

    status: PaymentStatus.pending,

    provider: "mock",
    providerPaymentId: "mock-booking-123",

    createdAt: new Date(),
    updatedAt: new Date(),

    paidAt: null,
    failureReason: null,
  };

  const checkout = {
    payment,
    provider: "mock",
    providerPaymentId: "mock-booking-123",
    checkoutUrl: "https://mock-payment.test/checkout/booking-123",
  };


  beforeEach(() => {
    vi.clearAllMocks();

    vi.mocked(getStudentAccount).mockResolvedValue({
      studentId,
      studentType: "pure_maths_student",
    });

    createPayment.mockResolvedValue(checkout);
  });

  function createRequest({
    auth = {
      uid: studentId,
    },
    data = {
      bookingId: bookingId,
    },
  }: {
    auth?: {
      uid: string;
    } | null;
    data?: Record<string, unknown>;
  } = {}) {
    return {
      auth,
      data,
    } as any;
  }

  async function callFunction(
    request: ReturnType<typeof createRequest>,
  ) {
    const callable = initiatePayment as any;

    return callable.run(request);
  }

  // --------------------------------------------------
  // Authentication
  // --------------------------------------------------

  it("rejects unauthenticated requests", async () => {
    await expect(
      callFunction(
        createRequest({
          auth: null,
        }),
      ),
    ).rejects.toMatchObject({
      code: "unauthenticated",
      message: "Authentication is required.",
    });

    expect(
      getStudentAccount,
    ).not.toHaveBeenCalled();

    expect(
      createPayment,
    ).not.toHaveBeenCalled();
  });

  // --------------------------------------------------
  // Validation
  // --------------------------------------------------

  it("rejects a missing bookingId", async () => {
    await expect(
      callFunction(
        createRequest({
          data: {},
        }),
      ),
    ).rejects.toMatchObject({
      code: "invalid-argument",
      message: "bookingId is required.",
    });

    expect(
      getStudentAccount,
    ).not.toHaveBeenCalled();

    expect(
      createPayment,
    ).not.toHaveBeenCalled();
  });

  it("rejects an empty bookingId", async () => {
    await expect(
      callFunction(
        createRequest({
          data: {
            bookingId: "",
          },
        }),
      ),
    ).rejects.toMatchObject({
      code: "invalid-argument",
      message: "bookingId is required.",
    });

    expect(
      getStudentAccount,
    ).not.toHaveBeenCalled();

    expect(
      createPayment,
    ).not.toHaveBeenCalled();
  });

  it("rejects a whitespace-only bookingId", async () => {
    await expect(
      callFunction(
        createRequest({
          data: {
            bookingId: "   ",
          },
        }),
      ),
    ).rejects.toMatchObject({
      code: "invalid-argument",
      message: "bookingId is required.",
    });

    expect(
      getStudentAccount,
    ).not.toHaveBeenCalled();

    expect(
      createPayment,
    ).not.toHaveBeenCalled();
  });

  it("rejects a non-string bookingId", async () => {
    await expect(
      callFunction(
        createRequest({
          data: {
            bookingId: 123,
          },
        }),
      ),
    ).rejects.toMatchObject({
      code: "invalid-argument",
      message: "bookingId is required.",
    });

    expect(
      getStudentAccount,
    ).not.toHaveBeenCalled();

    expect(
      createPayment,
    ).not.toHaveBeenCalled();
  });

  // --------------------------------------------------
  // Student account
  // --------------------------------------------------

  it("verifies the authenticated student account", async () => {
    await callFunction(
      createRequest(),
    );

    console.log(
        "getStudentAccount calls:",
        vi.mocked(getStudentAccount).mock.calls,
    );

    expect(
      getStudentAccount,
    ).toHaveBeenCalledTimes(1);

    expect(
      getStudentAccount,
    ).toHaveBeenCalledWith(studentId);
  });

  it("does not create a payment when the student account lookup fails", async () => {
    vi.mocked(getStudentAccount).mockRejectedValue(
      new Error("Student account not found."),
    );

    await expect(
      callFunction(
        createRequest(),
      ),
    ).rejects.toThrow(
      "Student account not found.",
    );

    expect(
      createPayment,
    ).not.toHaveBeenCalled();
  });

  // --------------------------------------------------
  // Payment service
  // --------------------------------------------------

  it("creates a payment using the authenticated student ID", async () => {
    await callFunction(
      createRequest(),
    );

    expect(
      createPayment,
    ).toHaveBeenCalledTimes(1);

    expect(
      createPayment,
    ).toHaveBeenCalledWith({
      bookingId,
      studentId,
    });
  });

  it("does not accept studentId from the request body", async () => {
    await callFunction(
      createRequest({
        data: {
          bookingId,
          studentId: "another-student",
        },
      }),
    );

    expect(
      createPayment,
    ).toHaveBeenCalledWith({
      bookingId,
      studentId,
    });
  });

  // --------------------------------------------------
  // Successful checkout
  // --------------------------------------------------

  it("returns the payment and checkout information", async () => {
    const result =
      await callFunction(
        createRequest(),
      );

    expect(result).toEqual({
      success: true,

      payment,

      checkout: {
        provider: "mock",
        providerPaymentId:
          "mock-booking-123",
        checkoutUrl:
          "https://mock-payment.test/checkout/booking-123",
      },
    });
  });

  it("returns the provider name", async () => {
    const result =
      await callFunction(
        createRequest(),
      );

    expect(
      result.checkout.provider,
    ).toBe("mock");
  });

  it("returns the provider payment ID", async () => {
    const result =
      await callFunction(
        createRequest(),
      );

    expect(
      result.checkout.providerPaymentId,
    ).toBe("mock-booking-123");
  });

  it("returns the checkout URL", async () => {
    const result =
      await callFunction(
        createRequest(),
      );

    expect(
      result.checkout.checkoutUrl,
    ).toBe(
      "https://mock-payment.test/checkout/booking-123",
    );
  });

  // --------------------------------------------------
  // Payment service failures
  // --------------------------------------------------

  it("converts payment service errors into failed-precondition", async () => {
    createPayment.mockRejectedValue(
      new Error(
        "Booking is not awaiting payment.",
      ),
    );

    await expect(
      callFunction(
        createRequest(),
      ),
    ).rejects.toMatchObject({
      code: "failed-precondition",
      message:
        "Booking is not awaiting payment.",
    });
  });

  it("converts unknown payment service errors into failed-precondition", async () => {
    createPayment.mockRejectedValue(
      "Unexpected failure",
    );

    await expect(
      callFunction(
        createRequest(),
      ),
    ).rejects.toMatchObject({
      code: "failed-precondition",
      message:
        "Unable to initiate payment.",
    });
  });

  // --------------------------------------------------
  // Booking/payment semantics
  // --------------------------------------------------

  it("passes the booking ID unchanged to the payment service", async () => {
    const anotherBookingId =
      "booking-999";

    await callFunction(
      createRequest({
        data: {
          bookingId: anotherBookingId,
        },
      }),
    );

    expect(
      createPayment,
    ).toHaveBeenCalledWith({
      bookingId: anotherBookingId,
      studentId,
    });
  });

  // --------------------------------------------------
  // Response shape
  // --------------------------------------------------

  it("returns success true on successful initiation", async () => {
    const result =
      await callFunction(
        createRequest(),
      );

    expect(result.success).toBe(true);
  });

  it("does not expose unrelated request data in the response", async () => {
    const result =
      await callFunction(
        createRequest({
          data: {
            bookingId,
            studentId: "attacker-id",
            amountCents: 1,
            tutorId: "attacker-tutor",
          },
        }),
      );

    expect(result).toEqual({
      success: true,

      payment,

      checkout: {
        provider: "mock",
        providerPaymentId:
          "mock-booking-123",
        checkoutUrl:
          "https://mock-payment.test/checkout/booking-123",
      },
    });
  });
});
