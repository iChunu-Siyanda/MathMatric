import { MasterclassEnrollmentService } from "../enrollment/masterclass_enrollment_service";
import { MasterclassPaymentService } from "../payment/masterclass_payment_service";
import { MasterclassPaymentCheckout } from "../payment/masterclass_payment_checkout";

export class MasterclassPurchaseService {
  constructor(
    private readonly enrollmentService: MasterclassEnrollmentService,
    private readonly paymentService: MasterclassPaymentService,
  ) {}

  /*
   * Single entry point for the Flutter app: creates (or
   * idempotently retrieves) the enrollment, then creates
   * (or idempotently retrieves) the checkout for it.
   * Both underlying calls are already individually
   * idempotent, so retrying this whole method after a
   * partial failure is always safe.
   */
  async purchase({
    masterclassId,
    studentId,
  }: {
    masterclassId: string;
    studentId: string;
  }): Promise<MasterclassPaymentCheckout> {
    const enrollment =
      await this.enrollmentService.createEnrollment({
        masterclassId,
        studentId,
      });

    return this.paymentService.createPayment({
      enrollmentId: enrollment.id,
      studentId,
    });
  }
}
