import {describe, expect, it} from "vitest";
import {calculateBookingPrice} from "./bookingValidation";

describe("calculateBookingPrice", () => {
  it("calculates online price correctly", () => {
    const tutor = {
      onlinePrice: 18000,
      inPersonPrice: 25000,
      teachingModes: ["online", "inPerson"],
    };

    const price = calculateBookingPrice(
      tutor,
      "online",
      60,
    );

    expect(price).toBe(18000);
  });

  it("calculates in-person price correctly", () => {
    const tutor = {
      onlinePrice: 18000,
      inPersonPrice: 25000,
      teachingModes: ["online", "inPerson"],
    };

    const price = calculateBookingPrice(
      tutor,
      "inPerson",
      60,
    );

    expect(price).toBe(25000);
  });

  it("calculates a 90-minute lesson correctly", () => {
    const tutor = {
      onlinePrice: 18000,
      inPersonPrice: 25000,
      teachingModes: ["online", "inPerson"],
    };

    const price = calculateBookingPrice(
      tutor,
      "online",
      90,
    );

    expect(price).toBe(27000);
  });
});
