export class PaymentProviderValidator {
  static validateProviderName(
    provider: string,
  ): void {
    if (
      typeof provider !== "string" ||
      provider.trim().length === 0
    ) {
      throw new Error(
        "Provider name is required.",
      );
    }
  }

  static validateProviderPaymentId(
    providerPaymentId: string,
  ): void {
    if (
      typeof providerPaymentId !== "string" ||
      providerPaymentId.trim().length === 0
    ) {
      throw new Error(
        "Provider payment ID is required.",
      );
    }
  }

  static validateProviderRefundId(
    providerRefundId: string,
  ): void {
    if (
      typeof providerRefundId !== "string" ||
      providerRefundId.trim().length === 0
    ) {
      throw new Error(
        "Provider refund ID is required.",
      );
    }
  }

  static validateAmount(
    amountCents: number,
  ): void {
    if (
      typeof amountCents !== "number" ||
      !Number.isInteger(amountCents) ||
      amountCents <= 0
    ) {
      throw new Error(
        "Amount must be a positive integer.",
      );
    }
  }

  static validateCurrency(
    currency: string,
  ): void {
    if (currency !== "ZAR") {
      throw new Error(
        "Unsupported currency.",
      );
    }
  }
}
