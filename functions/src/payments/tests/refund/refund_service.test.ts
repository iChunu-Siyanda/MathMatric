import {
  beforeEach,
  describe,
  expect,
  it,
  vi,
} from "vitest";

import {
  Timestamp,
} from "firebase-admin/firestore";

import {
  CancellationPolicy,
} from "../refund/cancellation_policy";

import {
  RefundService,
} from "../refund/refund_service";

import {
  PaymentStatus,
} from "../payment/payment_entity";

import {
  RefundStatus,
} from "../refund/refund";

import {
  PaymentProvider,
} from "../provider/payment_provider";


import {
  createMockFirestore,
} from "./mock_firestore";
import { PaymentProviderRefundIdentity } from "../provider/provider_refund_identity_service";


// ============================================================
// REFUND CREATION
// ============================================================

describe("RefundService - creation", () => {
  const firestore = createMockFirestore();

  const cancellationPolicy =
    new CancellationPolicy();

  const paymentProvider: PaymentProvider = {
    name: "mock",

    createPayment: vi.fn(),

    refundPayment: vi.fn(),

    verifyWebhook: vi.fn(),
  };

  const providerRefundIdentity =
    new PaymentProviderRefundIdentity(
      firestore as any,
    );

  const service = new RefundService(
    firestore as any,
    cancellationPolicy,
    paymentProvider,
    providerRefundIdentity,
  );

  const lessonStartsAt =
    new Date(
      "2026-09-10T15:00:00.000Z",
    );

  const basePayment = {
    bookingId: "booking-1",
    studentId: "student-1",
    tutorId: "tutor-1",

    amountCents: 50000,
    refundedAmountCents: 0,
    refundReservedAmountCents: 0,

    currency: "ZAR",

    status: PaymentStatus.paid,

    provider: "mock",
    providerPaymentId: "mock-payment-1",

    createdAt: Timestamp.fromDate(
      new Date(
        "2026-09-01T10:00:00.000Z",
      ),
    ),

    updatedAt: Timestamp.fromDate(
      new Date(
        "2026-09-01T10:00:00.000Z",
      ),
    ),

    paidAt: Timestamp.fromDate(
      new Date(
        "2026-09-01T10:05:00.000Z",
      ),
    ),

    failureReason: null,
  };

  const baseBooking = {
    studentId: "student-1",
    tutorId: "tutor-1",

    priceCents: 50000,

    status: "confirmed",

    lessonStartsAt:
      Timestamp.fromDate(
        lessonStartsAt,
      ),
  };

  beforeEach(() => {
    firestore.clear();

    vi.restoreAllMocks();
  });


  it("creates a pending full refund", async () => {
    firestore.seed(
      "payments/booking-1",
      basePayment,
    );

    firestore.seed(
      "bookings/booking-1",
      baseBooking,
    );

    const result =
      await service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      });

    expect(result.created).toBe(true);

    expect(result.refund).toMatchObject({
      id: "refund-1",

      paymentId: "booking-1",

      bookingId: "booking-1",

      studentId: "student-1",

      tutorId: "tutor-1",

      amountCents: 50000,

      currency: "ZAR",

      status: RefundStatus.pending,

      provider: "mock",

      providerRefundId: null,

      completedAt: null,

      failureReason: null,
    });

    expect(
      firestore.get(
        "payments/booking-1",
      )?.refundedAmountCents,
    ).toBe(0);

    expect(
      firestore.get(
        "payments/booking-1",
      )?.refundReservedAmountCents,
    ).toBe(50000);

    expect(
      firestore.get(
        "payments/booking-1/refunds/refund-1",
      )?.amountCents,
    ).toBe(50000);
  });


  it("creates a pending partial refund", async () => {
    firestore.seed(
      "payments/booking-1",
      basePayment,
    );

    firestore.seed(
      "bookings/booking-1",
      baseBooking,
    );

    const result =
      await service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-10T03:00:00.000Z",
          ),
      });

    expect(result.created).toBe(true);

    expect(
      result.refund.amountCents,
    ).toBe(25000);

    expect(
      firestore.get(
        "payments/booking-1",
      )?.refundedAmountCents,
    ).toBe(0);

    expect(
      firestore.get(
        "payments/booking-1",
      )?.refundReservedAmountCents,
    ).toBe(25000);
  });


  it("rejects a missing payment", async () => {
    firestore.seed(
      "bookings/booking-1",
      baseBooking,
    );

    await expect(
      service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      }),
    ).rejects.toThrow(
      "Payment not found.",
    );
  });


  it("rejects a missing booking", async () => {
    firestore.seed(
      "payments/booking-1",
      basePayment,
    );

    await expect(
      service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      }),
    ).rejects.toThrow(
      "Booking not found.",
    );
  });


  it("rejects a student who does not own the payment", async () => {
    firestore.seed(
      "payments/booking-1",
      basePayment,
    );

    firestore.seed(
      "bookings/booking-1",
      baseBooking,
    );

    await expect(
      service.createRefund({
        bookingId: "booking-1",
        studentId: "student-2",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      }),
    ).rejects.toThrow(
      "Payment does not belong to the student.",
    );
  });


  it("rejects an unpaid payment", async () => {
    firestore.seed(
      "payments/booking-1",
      {
        ...basePayment,
        status: PaymentStatus.processing,
      },
    );

    firestore.seed(
      "bookings/booking-1",
      baseBooking,
    );

    await expect(
      service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      }),
    ).rejects.toThrow(
      "Payment is not refundable.",
    );
  });


  it("rejects a fully refunded payment", async () => {
    firestore.seed(
      "payments/booking-1",
      {
        ...basePayment,
        refundedAmountCents: 50000,
      },
    );

    firestore.seed(
      "bookings/booking-1",
      baseBooking,
    );

    await expect(
      service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      }),
    ).rejects.toThrow(
      "Refund amount exceeds the available refundable amount.",
    );
  });


  it("rejects a booking that is not confirmed", async () => {
    firestore.seed(
      "payments/booking-1",
      basePayment,
    );

    firestore.seed(
      "bookings/booking-1",
      {
        ...baseBooking,
        status: "pending",
      },
    );

    await expect(
      service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      }),
    ).rejects.toThrow(
      "Booking is not eligible for cancellation.",
    );
  });


  it("rejects a mismatched tutor", async () => {
    firestore.seed(
      "payments/booking-1",
      basePayment,
    );

    firestore.seed(
      "bookings/booking-1",
      {
        ...baseBooking,
        tutorId: "tutor-2",
      },
    );

    await expect(
      service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      }),
    ).rejects.toThrow(
      "Payment tutor does not match booking.",
    );
  });


  it("rejects a mismatched payment amount", async () => {
    firestore.seed(
      "payments/booking-1",
      basePayment,
    );

    firestore.seed(
      "bookings/booking-1",
      {
        ...baseBooking,
        priceCents: 60000,
      },
    );

    await expect(
      service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      }),
    ).rejects.toThrow(
      "Payment amount does not match booking price.",
    );
  });


  it("rejects an invalid lesson start timestamp", async () => {
    firestore.seed(
      "payments/booking-1",
      basePayment,
    );

    firestore.seed(
      "bookings/booking-1",
      {
        ...baseBooking,
        lessonStartsAt:
          "not-a-timestamp",
      },
    );

    await expect(
      service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      }),
    ).rejects.toThrow(
      "Booking lessonStartsAt is invalid.",
    );
  });


  it("rejects when the cancellation policy gives no refund", async () => {
    firestore.seed(
      "payments/booking-1",
      basePayment,
    );

    firestore.seed(
      "bookings/booking-1",
      baseBooking,
    );

    await expect(
      service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-10T04:00:00.000Z",
          ),
      }),
    ).rejects.toThrow(
      "Cancellation was made less than 12 hours before the lesson.",
    );
  });


  it("returns the existing refund for the same idempotency key", async () => {
    firestore.seed(
      "payments/booking-1",
      basePayment,
    );

    firestore.seed(
      "bookings/booking-1",
      baseBooking,
    );

    const first =
      await service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      });

    const second =
      await service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:30:00.000Z",
          ),
      });

    expect(first.created).toBe(true);

    expect(second.created).toBe(false);

    expect(second.refund.id).toBe(
      first.refund.id,
    );

    expect(
      second.refund.amountCents,
    ).toBe(
      first.refund.amountCents,
    );

    expect(
      firestore.get(
        "payments/booking-1",
      )?.refundedAmountCents,
    ).toBe(0);

    expect(
      firestore.get(
        "payments/booking-1",
      )?.refundReservedAmountCents,
    ).toBe(50000);
  });


  it("rejects a second refund request when the cancellation policy allows no refund", async () => {
    firestore.seed(
      "payments/booking-1",
      basePayment,
    );

    firestore.seed(
      "bookings/booking-1",
      baseBooking,
    );

    const first =
      await service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-10T03:00:00.000Z",
          ),
      });

    expect(
      first.refund.amountCents,
    ).toBe(25000);

    await expect(
      service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-2",
        cancellationRequestedAt:
          new Date(
            "2026-09-10T04:00:00.000Z",
          ),
      }),
    ).rejects.toThrow(
      "Cancellation was made less than 12 hours before the lesson.",
    );

    expect(
      firestore.get(
        "payments/booking-1",
      )?.refundedAmountCents,
    ).toBe(0);

    expect(
      firestore.get(
        "payments/booking-1",
      )?.refundReservedAmountCents,
    ).toBe(25000);
  });


  it("rejects an empty idempotency key", async () => {
    await expect(
      service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "   ",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      }),
    ).rejects.toThrow(
      "idempotencyKey is required.",
    );
  });


  it("rejects an excessively long idempotency key", async () => {
    await expect(
      service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey:
          "a".repeat(129),
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      }),
    ).rejects.toThrow(
      "idempotencyKey is too long.",
    );
  });


  it("rejects an invalid cancellation date", async () => {
    await expect(
      service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date("invalid"),
      }),
    ).rejects.toThrow(
      "cancellationRequestedAt is invalid.",
    );
  });


  it("preserves the provider from the payment", async () => {
    firestore.seed(
      "payments/booking-1",
      basePayment,
    );

    firestore.seed(
      "bookings/booking-1",
      baseBooking,
    );

    const result =
      await service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      });

    expect(
      result.refund.provider,
    ).toBe("mock");

    expect(
      result.refund.providerRefundId,
    ).toBeNull();
  });
});


// ============================================================
// REFUND AMOUNT RESERVATION
// ============================================================

describe("RefundService - refund amount reservation", () => {
  const firestore = createMockFirestore();

  const cancellationPolicy =
    new CancellationPolicy();

  const paymentProvider: PaymentProvider = {
    name: "mock",

    createPayment: vi.fn(),

    refundPayment: vi.fn(),

    verifyWebhook: vi.fn(),
  };

  const providerRefundIdentity =
    new PaymentProviderRefundIdentity(
      firestore as any,
    );

  const service = new RefundService(
    firestore as any,
    cancellationPolicy,
    paymentProvider,
    providerRefundIdentity,
  );

  const lessonStartsAt =
    new Date(
      "2026-09-10T15:00:00.000Z",
    );

  const basePayment = {
    bookingId: "booking-1",
    studentId: "student-1",
    tutorId: "tutor-1",

    amountCents: 50000,
    refundedAmountCents: 0,
    refundReservedAmountCents: 0,

    currency: "ZAR",

    status: PaymentStatus.paid,

    provider: "mock",
    providerPaymentId: "mock-payment-1",

    createdAt: Timestamp.fromDate(
      new Date(
        "2026-09-01T10:00:00.000Z",
      ),
    ),

    updatedAt: Timestamp.fromDate(
      new Date(
        "2026-09-01T10:00:00.000Z",
      ),
    ),

    paidAt: Timestamp.fromDate(
      new Date(
        "2026-09-01T10:05:00.000Z",
      ),
    ),

    failureReason: null,
  };

  const baseBooking = {
    studentId: "student-1",
    tutorId: "tutor-1",

    priceCents: 50000,

    status: "confirmed",

    lessonStartsAt:
      Timestamp.fromDate(
        lessonStartsAt,
      ),
  };

  beforeEach(() => {
    firestore.clear();

    vi.restoreAllMocks();
  });


  it("reserves the refund amount without increasing refundedAmountCents", async () => {
    firestore.seed(
      "payments/booking-1",
      basePayment,
    );

    firestore.seed(
      "bookings/booking-1",
      baseBooking,
    );

    const result =
      await service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-1",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      });

    expect(result.created).toBe(true);

    expect(
      result.refund.amountCents,
    ).toBe(50000);

    expect(
      result.refund.status,
    ).toBe(RefundStatus.pending);

    const payment =
      firestore.get(
        "payments/booking-1",
      );

    expect(
      payment?.refundedAmountCents,
    ).toBe(0);

    expect(
      payment?.refundReservedAmountCents,
    ).toBe(50000);
  });


  it("does not allow a second refund to consume an already reserved amount", async () => {
    firestore.seed(
      "payments/booking-1",
      basePayment,
    );

    firestore.seed(
      "bookings/booking-1",
      baseBooking,
    );

    await service.createRefund({
      bookingId: "booking-1",
      studentId: "student-1",
      idempotencyKey: "refund-1",
      cancellationRequestedAt:
        new Date(
          "2026-09-08T14:00:00.000Z",
        ),
    });

    await expect(
      service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-2",
        cancellationRequestedAt:
          new Date(
            "2026-09-08T14:00:00.000Z",
          ),
      }),
    ).rejects.toThrow(
      "Refund amount exceeds the available refundable amount.",
    );

    const payment =
      firestore.get(
        "payments/booking-1",
      );

    expect(
      payment?.refundedAmountCents,
    ).toBe(0);

    expect(
      payment?.refundReservedAmountCents,
    ).toBe(50000);
  });


  it("calculates remaining refundable amount after an actual refund and a pending reservation", async () => {
    firestore.seed(
      "payments/booking-1",
      {
        ...basePayment,
        amountCents: 50000,
        refundedAmountCents: 10000,
        refundReservedAmountCents: 15000,
      },
    );

    firestore.seed(
      "bookings/booking-1",
      baseBooking,
    );

    const result =
      await service.createRefund({
        bookingId: "booking-1",
        studentId: "student-1",
        idempotencyKey: "refund-2",
        cancellationRequestedAt:
          new Date(
            "2026-09-10T03:00:00.000Z",
          ),
      });

    expect(result.created).toBe(true);

    expect(
      result.refund.amountCents,
    ).toBe(12500);

    const payment =
      firestore.get(
        "payments/booking-1",
      );

    expect(
      payment?.refundedAmountCents,
    ).toBe(10000);

    expect(
      payment?.refundReservedAmountCents,
    ).toBe(27500);
  });
});


// ============================================================
// REFUND LIFECYCLE
// ============================================================

describe("RefundService - refund lifecycle", () => {
  const firestore = createMockFirestore();

  const cancellationPolicy =
    new CancellationPolicy();

  const paymentProvider: PaymentProvider = {
    name: "mock",

    createPayment: vi.fn(),

    refundPayment: vi.fn(),

    verifyWebhook: vi.fn(),
  };

  const providerRefundIdentity =
    new PaymentProviderRefundIdentity(
      firestore as any,
    );

  const service = new RefundService(
    firestore as any,
    cancellationPolicy,
    paymentProvider,
    providerRefundIdentity,
  );

  const basePayment = {
    bookingId: "booking-1",
    studentId: "student-1",
    tutorId: "tutor-1",

    amountCents: 50000,
    refundedAmountCents: 0,
    refundReservedAmountCents: 0,

    currency: "ZAR",

    status: PaymentStatus.paid,

    provider: "mock",
    providerPaymentId: "mock-payment-1",

    createdAt: Timestamp.fromDate(
      new Date(
        "2026-09-01T10:00:00.000Z",
      ),
    ),

    updatedAt: Timestamp.fromDate(
      new Date(
        "2026-09-01T10:00:00.000Z",
      ),
    ),

    paidAt: Timestamp.fromDate(
      new Date(
        "2026-09-01T10:05:00.000Z",
      ),
    ),

    failureReason: null,
  };


  beforeEach(() => {
    firestore.clear();

    vi.restoreAllMocks();
  });


  // ----------------------------------------------------------
  // PROCESSING
  // ----------------------------------------------------------

  it("moves a pending refund to processing", async () => {
    firestore.seed(
      "payments/booking-1",
      {
        ...basePayment,
        refundReservedAmountCents: 50000,
      },
    );

    firestore.seed(
      "payments/booking-1/refunds/refund-1",
      {
        paymentId: "booking-1",
        bookingId: "booking-1",
        studentId: "student-1",
        tutorId: "tutor-1",

        amountCents: 50000,
        currency: "ZAR",

        status: RefundStatus.pending,

        provider: "mock",
        providerRefundId: null,

        reason: "Customer cancellation",

        createdAt: new Date(),
        updatedAt: new Date(),

        completedAt: null,
        failureReason: null,
      },
    );

    await service.markRefundProcessing({
      bookingId: "booking-1",
      refundId: "refund-1",
    });

    const refund =
      firestore.get(
        "payments/booking-1/refunds/refund-1",
      );

    expect(
      refund?.status,
    ).toBe(
      RefundStatus.processing,
    );
  });


  it("rejects moving a succeeded refund back to processing", async () => {
    firestore.seed(
      "payments/booking-1",
      {
        ...basePayment,
        refundedAmountCents: 50000,
        refundReservedAmountCents: 0,
        status: PaymentStatus.refunded,
      },
    );

    firestore.seed(
      "payments/booking-1/refunds/refund-1",
      {
        paymentId: "booking-1",
        bookingId: "booking-1",
        studentId: "student-1",
        tutorId: "tutor-1",

        amountCents: 50000,
        currency: "ZAR",

        status: RefundStatus.succeeded,

        provider: "mock",
        providerRefundId:
          "mock-refund-1",

        reason: "Customer cancellation",

        createdAt: new Date(),
        updatedAt: new Date(),
        completedAt: new Date(),

        failureReason: null,
      },
    );

    await expect(
      service.markRefundProcessing({
        bookingId: "booking-1",
        refundId: "refund-1",
      }),
    ).rejects.toThrow(
      "Refund cannot be moved to processing.",
    );
  });


  it("rejects moving a failed refund back to processing", async () => {
    firestore.seed(
      "payments/booking-1",
      {
        ...basePayment,
        refundReservedAmountCents: 0,
      },
    );

    firestore.seed(
      "payments/booking-1/refunds/refund-1",
      {
        paymentId: "booking-1",
        bookingId: "booking-1",
        studentId: "student-1",
        tutorId: "tutor-1",

        amountCents: 50000,
        currency: "ZAR",

        status: RefundStatus.failed,

        provider: "mock",
        providerRefundId: null,

        reason: "Customer cancellation",

        createdAt: new Date(),
        updatedAt: new Date(),

        completedAt: null,

        failureReason:
          "Provider rejected refund.",
      },
    );

    await expect(
      service.markRefundProcessing({
        bookingId: "booking-1",
        refundId: "refund-1",
      }),
    ).rejects.toThrow(
      "Refund cannot be moved to processing.",
    );
  });


  // ----------------------------------------------------------
  // SUCCESS
  // ----------------------------------------------------------

  it("completes a refund and converts the reservation into an actual refund", async () => {
    firestore.seed(
      "payments/booking-1",
      {
        ...basePayment,
        refundReservedAmountCents: 50000,
      },
    );

    firestore.seed(
      "payments/booking-1/refunds/refund-1",
      {
        paymentId: "booking-1",
        bookingId: "booking-1",
        studentId: "student-1",
        tutorId: "tutor-1",

        amountCents: 50000,
        currency: "ZAR",

        status: RefundStatus.processing,

        provider: "mock",
        providerRefundId: null,

        reason: "Customer cancellation",

        createdAt: new Date(),
        updatedAt: new Date(),

        completedAt: null,
        failureReason: null,
      },
    );

    await service.markRefundSucceeded({
      bookingId: "booking-1",
      refundId: "refund-1",
      providerRefundId:
        "mock-refund-1",
    });

    const payment =
      firestore.get(
        "payments/booking-1",
      );

    const refund =
      firestore.get(
        "payments/booking-1/refunds/refund-1",
      );

    expect(
      payment?.refundedAmountCents,
    ).toBe(50000);

    expect(
      payment?.refundReservedAmountCents,
    ).toBe(0);

    expect(
      payment?.status,
    ).toBe(
      PaymentStatus.refunded,
    );

    expect(
      refund?.status,
    ).toBe(
      RefundStatus.succeeded,
    );

    expect(
      refund?.providerRefundId,
    ).toBe(
      "mock-refund-1",
    );

    expect(
      refund?.completedAt,
    ).toBeInstanceOf(
      Timestamp,
    );
  });


  it("rejects succeeding a pending refund", async () => {
    firestore.seed(
      "payments/booking-1",
      {
        ...basePayment,
        refundReservedAmountCents: 50000,
      },
    );

    firestore.seed(
      "payments/booking-1/refunds/refund-1",
      {
        paymentId: "booking-1",
        bookingId: "booking-1",
        studentId: "student-1",
        tutorId: "tutor-1",

        amountCents: 50000,
        currency: "ZAR",

        status: RefundStatus.pending,

        provider: "mock",
        providerRefundId: null,

        reason: "Customer cancellation",

        createdAt: new Date(),
        updatedAt: new Date(),

        completedAt: null,
        failureReason: null,
      },
    );

    await expect(
      service.markRefundSucceeded({
        bookingId: "booking-1",
        refundId: "refund-1",
        providerRefundId:
          "mock-refund-1",
      }),
    ).rejects.toThrow(
      "Refund cannot be marked as succeeded.",
    );
  });


  it("does not apply a successful refund twice when the provider refund ID is the same", async () => {
    firestore.seed(
      "payments/booking-1",
      {
        ...basePayment,
        refundedAmountCents: 0,
        refundReservedAmountCents: 50000,
      },
    );

    firestore.seed(
      "payments/booking-1/refunds/refund-1",
      {
        paymentId: "booking-1",
        bookingId: "booking-1",
        studentId: "student-1",
        tutorId: "tutor-1",

        amountCents: 50000,
        currency: "ZAR",

        status: RefundStatus.processing,

        provider: "mock",
        providerRefundId: null,

        reason: "Customer cancellation",

        createdAt: new Date(),
        updatedAt: new Date(),

        completedAt: null,
        failureReason: null,
      },
    );

    await service.markRefundSucceeded({
      bookingId: "booking-1",
      refundId: "refund-1",
      providerRefundId:
        "mock-refund-1",
    });

    await service.markRefundSucceeded({
      bookingId: "booking-1",
      refundId: "refund-1",
      providerRefundId:
        "mock-refund-1",
    });

    const payment =
      firestore.get(
        "payments/booking-1",
      );

    expect(
      payment?.refundedAmountCents,
    ).toBe(50000);

    expect(
      payment?.refundReservedAmountCents,
    ).toBe(0);
  });


  it("rejects a succeeded refund with a different provider refund ID", async () => {
    firestore.seed(
      "payments/booking-1",
      {
        ...basePayment,
        refundedAmountCents: 50000,
        refundReservedAmountCents: 0,
        status: PaymentStatus.refunded,
      },
    );

    firestore.seed(
      "payments/booking-1/refunds/refund-1",
      {
        paymentId: "booking-1",
        bookingId: "booking-1",
        studentId: "student-1",
        tutorId: "tutor-1",

        amountCents: 50000,
        currency: "ZAR",

        status: RefundStatus.succeeded,

        provider: "mock",
        providerRefundId:
          "provider-refund-1",

        reason: "Customer cancellation",

        createdAt: new Date(),
        updatedAt: new Date(),

        completedAt: new Date(),

        failureReason: null,
      },
    );

    await expect(
      service.markRefundSucceeded({
        bookingId: "booking-1",
        refundId: "refund-1",
        providerRefundId:
          "provider-refund-2",
      }),
    ).rejects.toThrow(
      "Provider refund ID does not match the existing refund.",
    );

    const refund =
      firestore.get(
        "payments/booking-1/refunds/refund-1",
      );

    expect(
      refund?.providerRefundId,
    ).toBe(
      "provider-refund-1",
    );

    expect(
      refund?.status,
    ).toBe(
      RefundStatus.succeeded,
    );

    const payment =
      firestore.get(
        "payments/booking-1",
      );

    expect(
      payment?.refundedAmountCents,
    ).toBe(50000);

    expect(
      payment?.refundReservedAmountCents,
    ).toBe(0);
  });


  it("rejects a refund when the reserved amount is insufficient", async () => {
    firestore.seed(
      "payments/booking-1",
      {
        ...basePayment,
        refundedAmountCents: 0,
        refundReservedAmountCents: 10000,
      },
    );

    firestore.seed(
      "payments/booking-1/refunds/refund-1",
      {
        paymentId: "booking-1",
        bookingId: "booking-1",
        studentId: "student-1",
        tutorId: "tutor-1",

        amountCents: 25000,
        currency: "ZAR",

        status: RefundStatus.processing,

        provider: "mock",
        providerRefundId: null,

        reason: "Customer cancellation",

        createdAt: new Date(),
        updatedAt: new Date(),

        completedAt: null,
        failureReason: null,
      },
    );

    await expect(
      service.markRefundSucceeded({
        bookingId: "booking-1",
        refundId: "refund-1",
        providerRefundId:
          "mock-refund-1",
      }),
    ).rejects.toThrow(
      "Refund amount exceeds the reserved amount.",
    );

    const payment =
      firestore.get(
        "payments/booking-1",
      );

    expect(
      payment?.refundedAmountCents,
    ).toBe(0);

    expect(
      payment?.refundReservedAmountCents,
    ).toBe(10000);
  });


  // ----------------------------------------------------------
  // FAILURE
  // ----------------------------------------------------------

  it("releases the reservation when a refund fails", async () => {
    firestore.seed(
      "payments/booking-1",
      {
        ...basePayment,
        refundReservedAmountCents: 50000,
      },
    );

    firestore.seed(
      "payments/booking-1/refunds/refund-1",
      {
        paymentId: "booking-1",
        bookingId: "booking-1",
        studentId: "student-1",
        tutorId: "tutor-1",

        amountCents: 50000,
        currency: "ZAR",

        status: RefundStatus.processing,

        provider: "mock",
        providerRefundId: null,

        reason: "Customer cancellation",

        createdAt: new Date(),
        updatedAt: new Date(),

        completedAt: null,
        failureReason: null,
      },
    );

    await service.markRefundFailed({
      bookingId: "booking-1",
      refundId: "refund-1",
      failureReason:
        "Provider rejected refund.",
    });

    const payment =
      firestore.get(
        "payments/booking-1",
      );

    const refund =
      firestore.get(
        "payments/booking-1/refunds/refund-1",
      );

    expect(
      payment?.refundedAmountCents,
    ).toBe(0);

    expect(
      payment?.refundReservedAmountCents,
    ).toBe(0);

    expect(
      payment?.status,
    ).toBe(
      PaymentStatus.paid,
    );

    expect(
      refund?.status,
    ).toBe(
      RefundStatus.failed,
    );

    expect(
      refund?.failureReason,
    ).toBe(
      "Provider rejected refund.",
    );
  });


  it("rejects failing a pending refund", async () => {
    firestore.seed(
      "payments/booking-1",
      {
        ...basePayment,
        refundReservedAmountCents: 50000,
      },
    );

    firestore.seed(
      "payments/booking-1/refunds/refund-1",
      {
        paymentId: "booking-1",
        bookingId: "booking-1",
        studentId: "student-1",
        tutorId: "tutor-1",

        amountCents: 50000,
        currency: "ZAR",

        status: RefundStatus.pending,

        provider: "mock",
        providerRefundId: null,

        reason: "Customer cancellation",

        createdAt: new Date(),
        updatedAt: new Date(),

        completedAt: null,
        failureReason: null,
      },
    );

    await expect(
      service.markRefundFailed({
        bookingId: "booking-1",
        refundId: "refund-1",
        failureReason:
          "Provider rejected refund.",
      }),
    ).rejects.toThrow(
      "Refund cannot be marked as failed.",
    );
  });


  it("does not overwrite an already failed refund", async () => {
    firestore.seed(
      "payments/booking-1",
      {
        ...basePayment,
        refundReservedAmountCents: 0,
      },
    );

    firestore.seed(
      "payments/booking-1/refunds/refund-1",
      {
        paymentId: "booking-1",
        bookingId: "booking-1",
        studentId: "student-1",
        tutorId: "tutor-1",

        amountCents: 50000,
        currency: "ZAR",

        status: RefundStatus.failed,

        provider: "mock",
        providerRefundId: null,

        reason: "Customer cancellation",

        createdAt: new Date(),
        updatedAt: new Date(),

        completedAt: null,

        failureReason:
          "Original provider failure.",
      },
    );

    await service.markRefundFailed({
      bookingId: "booking-1",
      refundId: "refund-1",
      failureReason:
        "New provider failure.",
    });

    const refund =
      firestore.get(
        "payments/booking-1/refunds/refund-1",
      );

    expect(
      refund?.status,
    ).toBe(
      RefundStatus.failed,
    );

    expect(
      refund?.failureReason,
    ).toBe(
      "Original provider failure.",
    );
  });
});
