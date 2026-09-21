import { onSchedule } from "firebase-functions/v2/scheduler";
import { db } from "../../shared/firebase";
import { PaymentService } from "../payment/payment_service";
import { MockPaymentProvider } from "../provider/mock_payment_provider";
import { PaymentProvider } from "../provider/payment_provider";

const STUCK_THRESHOLD_MS = 10 * 60 * 1000; // 30 minutes

const paymentProvider: PaymentProvider = new MockPaymentProvider();

const paymentService = new PaymentService(
  db,
  paymentProvider,
);

export const paymentStuckSweep = onSchedule(
  "every 15 minutes",
  async () => {
    const candidates =
      await paymentService
        .findStuckPaymentCandidates(
          STUCK_THRESHOLD_MS,
        );

    for (const payment of candidates) {
      try {
        await paymentService.markStuck(
          payment.id,
        );

        console.log(
          `Marked payment ${payment.id} as stuck.`,
        );
      } catch (error) {
        /*
         * One payment failing to transition (e.g.
         * it resolved itself via a late webhook
         * between the query and this call) should
         * not stop the sweep from processing the
         * rest.
         */
        console.error(
          `Failed to mark payment ${payment.id} as stuck.`,
          error,
        );
      }
    }

    console.log(
      `Payment stuck sweep complete. ${candidates.length} candidate(s) processed.`,
    );
  },
);
