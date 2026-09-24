import { describe, expect, it } from "vitest";
import { TwentyPercentPlatformFeeCalculator } from "../../payout/platform_fee_calculator";
import { MasterclassEnrollment, MasterclassEnrollmentStatus } from "../../masterclasses/enrollment/masterclass_enrollment_entity";
import { MasterclassPayoutEligibilityService } from "../../masterclasses/payout/masterclass_payout_eligibility_service";
import { MasterclassPayment, MasterclassPaymentStatus } from "../../masterclasses/payment/masterclass_payment_entity";

describe("MasterclassPayoutEligibilityService", () => {
  const feeCalculator = new TwentyPercentPlatformFeeCalculator();
  const service = new MasterclassPayoutEligibilityService(feeCalculator);

  function createEnrollment(
    overrides: Partial<MasterclassEnrollment> = {},
  ): MasterclassEnrollment {
    return {
      id: "masterclass-1_student-1",
      masterclassId: "masterclass-1",
      studentId: "student-1",
      tutorId: "tutor-1",

      priceCents: 15000,
      currency: "ZAR",

      status: MasterclassEnrollmentStatus.confirmed,

      downloadedAt: null,

      enrolledAt: new Date("2026-02-01T10:00:00.000Z"),
      updatedAt: new Date("2026-02-01T10:00:00.000Z"),
      cancelledAt: null,
      refundedAt: null,

      ...overrides,
    };
  }

  function createPayment(
    overrides: Partial<MasterclassPayment> = {},
  ): MasterclassPayment {
    return {
      id: "masterclass-1_student-1",
      enrollmentId: "masterclass-1_student-1",
      masterclassId: "masterclass-1",
      studentId: "student-1",
      tutorId: "tutor-1",

      amountCents: 15000,
      currency: "ZAR",

      status: MasterclassPaymentStatus.paid,

      provider: "mock",
      providerPaymentId: "mock-masterclass-1_student-1",

      createdAt: new Date("2026-02-01T10:00:00.000Z"),
      updatedAt: new Date("2026-02-01T10:05:00.000Z"),

      paidAt: new Date("2026-02-01T10:05:00.000Z"),

      failureReason: null,

      ...overrides,
    };
  }

  it("is eligible when downloaded, even well before the 7-day window elapses", () => {
    const enrolledAt = new Date("2026-02-01T10:00:00.000Z");

    const enrollment = createEnrollment({
      enrolledAt,
      downloadedAt: new Date("2026-02-01T11:00:00.000Z"),
    });

    const payment = createPayment();

    const now = new Date("2026-02-01T12:00:00.000Z");

    const result = service.evaluate({ enrollment, payment, now });

    expect(result.eligible).toBe(true);
    expect(result.reason).toBeNull();
  });

  it("is eligible once the 7-day window elapses, even if never downloaded", () => {
    const enrolledAt = new Date("2026-02-01T10:00:00.000Z");

    const enrollment = createEnrollment({
      enrolledAt,
      downloadedAt: null,
    });

    const payment = createPayment();

    const now = new Date("2026-02-08T10:00:01.000Z");

    const result = service.evaluate({ enrollment, payment, now });

    expect(result.eligible).toBe(true);
  });

  it("is ineligible when neither downloaded nor the window has elapsed", () => {
    const enrolledAt = new Date("2026-02-01T10:00:00.000Z");

    const enrollment = createEnrollment({
      enrolledAt,
      downloadedAt: null,
    });

    const payment = createPayment();

    const now = new Date("2026-02-03T10:00:00.000Z");

    const result = service.evaluate({ enrollment, payment, now });

    expect(result.eligible).toBe(false);
    expect(result.reason).toBe(
      "Refund window has not yet closed.",
    );
  });

  it("is ineligible exactly at the boundary just before 7 days", () => {
    const enrolledAt = new Date("2026-02-01T10:00:00.000Z");

    const enrollment = createEnrollment({
      enrolledAt,
      downloadedAt: null,
    });

    const payment = createPayment();

    const now = new Date("2026-02-08T09:59:59.000Z");

    const result = service.evaluate({ enrollment, payment, now });

    expect(result.eligible).toBe(false);
  });

  it("is eligible exactly at the 7-day boundary", () => {
    const enrolledAt = new Date("2026-02-01T10:00:00.000Z");

    const enrollment = createEnrollment({
      enrolledAt,
      downloadedAt: null,
    });

    const payment = createPayment();

    const now = new Date("2026-02-08T10:00:00.000Z");

    const result = service.evaluate({ enrollment, payment, now });

    expect(result.eligible).toBe(true);
  });

  it("calculates the 20% platform fee and 80% payout correctly", () => {
    const enrollment = createEnrollment({
      downloadedAt: new Date("2026-02-01T11:00:00.000Z"),
      priceCents: 15000,
    });

    const payment = createPayment({ amountCents: 15000 });

    const result = service.evaluate({
      enrollment,
      payment,
      now: new Date("2026-02-01T12:00:00.000Z"),
    });

    expect(result.grossAmountCents).toBe(15000);
    expect(result.platformFeeCents).toBe(3000);
    expect(result.payoutAmountCents).toBe(12000);
  });

  it("is ineligible when the enrollment is not confirmed", () => {
    const enrollment = createEnrollment({
      status: MasterclassEnrollmentStatus.pendingPayment,
      downloadedAt: new Date("2026-02-01T11:00:00.000Z"),
    });

    const payment = createPayment();

    const result = service.evaluate({
      enrollment,
      payment,
      now: new Date("2026-02-01T12:00:00.000Z"),
    });

    expect(result.eligible).toBe(false);
    expect(result.reason).toBe("Enrollment is not confirmed.");
  });

  it("is ineligible when the enrollment is cancelled", () => {
    const enrollment = createEnrollment({
      status: MasterclassEnrollmentStatus.cancelled,
      downloadedAt: new Date("2026-02-01T11:00:00.000Z"),
    });

    const payment = createPayment();

    const result = service.evaluate({
      enrollment,
      payment,
      now: new Date("2026-02-01T12:00:00.000Z"),
    });

    expect(result.eligible).toBe(false);
    expect(result.reason).toBe("Enrollment is not confirmed.");
  });

  it("is ineligible when the payment is not paid", () => {
    const enrollment = createEnrollment({
      downloadedAt: new Date("2026-02-01T11:00:00.000Z"),
    });

    const payment = createPayment({
      status: MasterclassPaymentStatus.processing,
    });

    const result = service.evaluate({
      enrollment,
      payment,
      now: new Date("2026-02-01T12:00:00.000Z"),
    });

    expect(result.eligible).toBe(false);
    expect(result.reason).toBe("Payment is not paid.");
  });

  it("is ineligible when the payment does not belong to this enrollment", () => {
    const enrollment = createEnrollment({
      downloadedAt: new Date("2026-02-01T11:00:00.000Z"),
    });

    const payment = createPayment({
      enrollmentId: "masterclass-1_student-2",
    });

    const result = service.evaluate({
      enrollment,
      payment,
      now: new Date("2026-02-01T12:00:00.000Z"),
    });

    expect(result.eligible).toBe(false);
    expect(result.reason).toBe(
      "Payment does not belong to this enrollment.",
    );
  });

  it("is ineligible when the payment student does not match the enrollment", () => {
    const enrollment = createEnrollment({
      downloadedAt: new Date("2026-02-01T11:00:00.000Z"),
    });

    const payment = createPayment({
      studentId: "different-student",
    });

    const result = service.evaluate({
      enrollment,
      payment,
      now: new Date("2026-02-01T12:00:00.000Z"),
    });

    expect(result.eligible).toBe(false);
    expect(result.reason).toBe(
      "Payment student does not match the enrollment.",
    );
  });

  it("is ineligible when the payment tutor does not match the enrollment", () => {
    const enrollment = createEnrollment({
      downloadedAt: new Date("2026-02-01T11:00:00.000Z"),
    });

    const payment = createPayment({
      tutorId: "different-tutor",
    });

    const result = service.evaluate({
      enrollment,
      payment,
      now: new Date("2026-02-01T12:00:00.000Z"),
    });

    expect(result.eligible).toBe(false);
    expect(result.reason).toBe(
      "Payment tutor does not match the enrollment.",
    );
  });

  it("is ineligible when the payment amount does not match the enrollment price", () => {
    const enrollment = createEnrollment({
      downloadedAt: new Date("2026-02-01T11:00:00.000Z"),
      priceCents: 15000,
    });

    const payment = createPayment({
      amountCents: 20000,
    });

    const result = service.evaluate({
      enrollment,
      payment,
      now: new Date("2026-02-01T12:00:00.000Z"),
    });

    expect(result.eligible).toBe(false);
    expect(result.reason).toBe(
      "Payment amount does not match the enrollment price.",
    );
  });

  it("returns zeroed amounts when ineligible", () => {
    const enrollment = createEnrollment({
      status: MasterclassEnrollmentStatus.pendingPayment,
    });

    const payment = createPayment();

    const result = service.evaluate({
      enrollment,
      payment,
      now: new Date("2026-02-01T12:00:00.000Z"),
    });

    expect(result.grossAmountCents).toBe(0);
    expect(result.platformFeeCents).toBe(0);
    expect(result.payoutAmountCents).toBe(0);
  });
});
