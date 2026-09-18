import { onSchedule } from "firebase-functions/v2/scheduler";
import { db } from "../../shared/firebase";
import { PayoutService } from "../payout/payout_service";
import { TutorPayoutEligibilityService } from "../payout/tutor_payout_eligibility_service";
import { TwentyPercentPlatformFeeCalculator } from "../payout/platform_fee_calculator";
import { TransactionReferenceIdentity } from "../transactions/transaction_reference_identity";
import { TransactionService } from "../transactions/transaction_service";
import { PayoutTransactionService } from "../transactions/payout_transaction_service";
import { MockPayoutProvider } from "../provider/mock_payout_provider";
import { PayoutProvider } from "../provider/payout_provider";
import { PayoutProviderIdentity } from "../provider/payout_provider_identity";

const STUCK_THRESHOLD_MS = 30 * 60 * 1000; // 30 minutes
const payoutProvider: PayoutProvider = new MockPayoutProvider();
const referenceIdentity = new TransactionReferenceIdentity(db);
const transactionService = new TransactionService(db, referenceIdentity);
const payoutTransactionService = new PayoutTransactionService(db, transactionService);
const feeCalculator = new TwentyPercentPlatformFeeCalculator();
const eligibilityService = new TutorPayoutEligibilityService(feeCalculator);
const payoutProviderIdentity = new PayoutProviderIdentity(db, payoutProvider);
const payoutService = new PayoutService(
  db,
  eligibilityService,
  payoutTransactionService,
  payoutProvider,
  payoutProviderIdentity,
);

export const payoutStuckSweep = onSchedule(
  "every 15 minutes",
  async () => {
    const candidates = await payoutService
        .findStuckPayoutCandidates(
          STUCK_THRESHOLD_MS,
        );

    for (const payout of candidates) {
      try {
        await payoutService.markStuck(payout.id,);

        console.log(`Marked payout ${payout.id} as stuck.`,);
      } catch (error) {
        /*
         * One payout failing to transition
         * (e.g. it resolved itself via webhook
         * between the query and this call)
         * should not stop the sweep from
         * processing the rest.
         */
        console.error(
          `Failed to mark payout ${payout.id} as stuck.`,
          error,
        );
      }
    }

    console.log(
      `Payout stuck sweep complete. ${candidates.length} candidate(s) processed.`,
    );
  },
);
