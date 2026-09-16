export interface PlatformFeeCalculator {
  calculateFeeCents(amountCents: number): number;
}

export class TwentyPercentPlatformFeeCalculator implements PlatformFeeCalculator
{
  calculateFeeCents(amountCents: number): number {
    if (
      !Number.isInteger(amountCents) || amountCents < 0
    ) {
      throw new Error(
        "Amount must be a non-negative integer.",
      );
    }

    // Math.floor keeps all monetary values in integer cents.
    return Math.floor(amountCents * 0.20);
  }
}

// So:

// R500.00 → 50000 cents
// 20%     → 10000 cents
// Tutor   → 40000 cents

// And:

// R499.99
// 20% = R99.998 → R99.99