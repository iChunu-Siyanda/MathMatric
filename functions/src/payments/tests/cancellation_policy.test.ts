import { describe, expect, it } from "vitest";

import { CancellationPolicy } from "../refund/cancellation_policy";
import {
  RefundDecisionType,
} from "../refund/refund_decision";

describe("CancellationPolicy", () => {
  const policy = new CancellationPolicy();

  const lessonStartsAt =
    new Date("2026-09-10T15:00:00.000Z");

  it("returns a full refund when cancelled more than 24 hours before the lesson", () => {
    const cancellationRequestedAt =
      new Date(
        "2026-09-09T14:59:59.000Z",
      );

    const result =
      policy.calculateRefund({
        lessonStartsAt,
        cancellationRequestedAt,
        amountCents: 50000,
      });

    expect(result).toEqual({
      type: RefundDecisionType.full,
      refundAmountCents: 50000,
      reason:
        "Cancellation was made more than 24 hours before the lesson.",
    });
  });

  it("returns a partial refund when cancelled between 12 and 24 hours before the lesson", () => {
    const cancellationRequestedAt =
      new Date(
        "2026-09-09T15:00:00.000Z",
      );

    const result =
      policy.calculateRefund({
        lessonStartsAt,
        cancellationRequestedAt,
        amountCents: 50000,
      });

    expect(result).toEqual({
      type: RefundDecisionType.partial,
      refundAmountCents: 25000,
      reason:
        "Cancellation was made between 12 and 24 hours before the lesson.",
    });
  });

  it("returns no refund when cancelled less than 12 hours before the lesson", () => {
    const cancellationRequestedAt =
      new Date(
        "2026-09-10T04:00:00.000Z",
      );

    const result =
      policy.calculateRefund({
        lessonStartsAt,
        cancellationRequestedAt,
        amountCents: 50000,
      });

    expect(result).toEqual({
      type: RefundDecisionType.none,
      refundAmountCents: 0,
      reason:
        "Cancellation was made less than 12 hours before the lesson.",
    });
  });

  it("returns no refund when cancellation is requested after the lesson starts", () => {
    const cancellationRequestedAt =
      new Date(
        "2026-09-10T15:01:00.000Z",
      );

    const result =
      policy.calculateRefund({
        lessonStartsAt,
        cancellationRequestedAt,
        amountCents: 50000,
      });

    expect(result).toEqual({
      type: RefundDecisionType.none,
      refundAmountCents: 0,
      reason:
        "The lesson has already started.",
    });
  });

  it("returns no refund when cancellation is requested exactly at the lesson start", () => {
    const result =
      policy.calculateRefund({
        lessonStartsAt,
        cancellationRequestedAt:
          lessonStartsAt,
        amountCents: 50000,
      });

    expect(result.type).toBe(
      RefundDecisionType.none,
    );

    expect(
      result.refundAmountCents,
    ).toBe(0);
  });

  it("returns a partial refund exactly 12 hours before the lesson", () => {
    const cancellationRequestedAt =
      new Date(
        "2026-09-10T03:00:00.000Z",
      );

    const result =
      policy.calculateRefund({
        lessonStartsAt,
        cancellationRequestedAt,
        amountCents: 50000,
      });

    expect(result.type).toBe(
      RefundDecisionType.partial,
    );

    expect(
      result.refundAmountCents,
    ).toBe(25000);
  });

  it("does not return a partial refund exactly 24 hours before the lesson", () => {
    const cancellationRequestedAt =
      new Date(
        "2026-09-09T15:00:00.000Z",
      );

    const result =
      policy.calculateRefund({
        lessonStartsAt,
        cancellationRequestedAt,
        amountCents: 50000,
      });

    expect(result.type).toBe(
      RefundDecisionType.partial,
    );

    expect(
      result.refundAmountCents,
    ).toBe(25000);
  });

  it("rejects a zero amount", () => {
    expect(() =>
      policy.calculateRefund({
        lessonStartsAt,
        cancellationRequestedAt:
          new Date(
            "2026-09-08T15:00:00.000Z",
          ),
        amountCents: 0,
      }),
    ).toThrow(
      "Refund amount must be greater than zero.",
    );
  });

  it("rejects a negative amount", () => {
    expect(() =>
      policy.calculateRefund({
        lessonStartsAt,
        cancellationRequestedAt:
          new Date(
            "2026-09-08T15:00:00.000Z",
          ),
        amountCents: -100,
      }),
    ).toThrow(
      "Refund amount must be greater than zero.",
    );
  });

  it("rounds a half refund down to whole cents", () => {
    const cancellationRequestedAt =
      new Date(
        "2026-09-10T03:00:00.000Z",
      );

    const result =
      policy.calculateRefund({
        lessonStartsAt,
        cancellationRequestedAt,
        amountCents: 501,
      });

    expect(
      result.refundAmountCents,
    ).toBe(250);
  });
});
