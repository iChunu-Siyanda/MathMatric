import {
  describe,
  expect,
  it,
} from "vitest";

import {
  TwentyPercentPlatformFeeCalculator,
} from "../../payout/platform_fee_calculator";

describe(
  "TwentyPercentPlatformFeeCalculator",
  () => {
    const calculator =
      new TwentyPercentPlatformFeeCalculator();

    it("calculates 20 percent", () => {
      expect(
        calculator.calculateFeeCents(50000),
      ).toBe(10000);
    });

    it("calculates zero correctly", () => {
      expect(
        calculator.calculateFeeCents(0),
      ).toBe(0);
    });

    it("floors fractional cents", () => {
      expect(
        calculator.calculateFeeCents(49999),
      ).toBe(9999);
    });

    it("rejects negative amounts", () => {
      expect(() =>
        calculator.calculateFeeCents(-1),
      ).toThrow(
        "Amount must be a non-negative integer.",
      );
    });

    it("rejects fractional cents", () => {
      expect(() =>
        calculator.calculateFeeCents(100.5),
      ).toThrow(
        "Amount must be a non-negative integer.",
      );
    });
  },
);
