import {describe,expect,it,} from "vitest";
import {validateTeachingMode,} from "./bookingValidation";

describe("validateTeachingMode", () => {
  it("allows a mode offered by the tutor", () => {
    const tutor = {
      teachingModes: ["online", "inPerson"],
    };

    expect(() =>
      validateTeachingMode(
        tutor,
        "online",
      ),
    ).not.toThrow();
  });

  it("rejects a mode not offered by the tutor", () => {
    const tutor = {
      teachingModes: ["online"],
    };

    expect(() =>
      validateTeachingMode(
        tutor,
        "inPerson",
      ),
    ).toThrow(
      "Tutor does not offer the selected teaching mode.",
    );
  });
});
