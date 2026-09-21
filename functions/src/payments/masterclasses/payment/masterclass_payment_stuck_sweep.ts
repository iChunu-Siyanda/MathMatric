import { onSchedule } from "firebase-functions/v2/scheduler";
import { db } from "../../../shared/firebase";
import { MasterclassPaymentService } from "./masterclass_payment_service";
import { MockPaymentProvider } from "../../provider/mock_payment_provider";
import { PaymentProvider } from "../../provider/payment_provider";

const STUCK_THRESHOLD_MS = 10 * 60 * 1000; // 10 minutes, same rationale as booking payment

const paymentProvider: PaymentProvider = new MockPaymentProvider();

const masterclassPaymentService =
  new MasterclassPaymentService(db, paymentProvider);

export const masterclassPaymentStuckSweep = onSchedule(
  "every 15 minutes",
  async () => {
    const candidates =
      await masterclassPaymentService
        .findStuckPaymentCandidates(
          STUCK_THRESHOLD_MS,
        );

    for (const payment of candidates) {
      try {
        await masterclassPaymentService.markStuck(
          payment.id,
        );

        console.log(
          `Marked masterclass payment ${payment.id} as stuck.`,
        );
      } catch (error) {
        console.error(
          `Failed to mark masterclass payment ${payment.id} as stuck.`,
          error,
        );
      }
    }

    console.log(
      `Masterclass payment stuck sweep complete. ${candidates.length} candidate(s) processed.`,
    );
  },
);
