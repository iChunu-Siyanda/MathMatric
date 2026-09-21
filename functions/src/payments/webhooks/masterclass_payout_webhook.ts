import { onRequest } from "firebase-functions/v2/https";
import { db } from "../../shared/firebase";
import { MasterclassPayoutService } from "../masterclasses/payout/masterclass_payout_service";
import { MasterclassPayoutEligibilityService } from "../masterclasses/payout/masterclass_payout_eligibility_service";
import { TwentyPercentPlatformFeeCalculator } from "../payout/platform_fee_calculator";
import { TransactionReferenceIdentity } from "../transactions/transaction_reference_identity";
import { TransactionService } from "../transactions/transaction_service";
import { MockPayoutProvider } from "../provider/mock_payout_provider";
import { PayoutProvider } from "../provider/payout_provider";
import { PayoutProviderIdentity } from "../provider/payout_provider_identity";
import { WebhookEventService } from "./webhook_event_service";
import { MasterclassPayoutWebhookHandler } from "./masterclass_payout_webhook_handler";
import { handleMasterclassPayoutWebhookRequest } from "./masterclass_payout_webhook_request_handler";

/*
 * Shares the same PayoutProvider abstraction and, for now,
 * the same MockPayoutProvider instance type as booking
 * payout — this is intentional: the provider-facing contract
 * (createPayout, verifyWebhook) is identical regardless of
 * what generated the payout.
 */
const payoutProvider: PayoutProvider = new MockPayoutProvider();

const referenceIdentity =
  new TransactionReferenceIdentity(db);

const transactionService =
  new TransactionService(
    db,
    referenceIdentity,
  );

const feeCalculator =
  new TwentyPercentPlatformFeeCalculator();

const eligibilityService =
  new MasterclassPayoutEligibilityService(
    feeCalculator,
  );

const payoutProviderIdentity =
  new PayoutProviderIdentity(
    db,
    payoutProvider,
  );

const masterclassPayoutService =
  new MasterclassPayoutService(
    db,
    eligibilityService,
    transactionService,
    payoutProvider,
    payoutProviderIdentity,
  );

const webhookEventService =
  new WebhookEventService(
    db,
    "masterclassPayoutWebhookEvents",
  );

const masterclassPayoutWebhookHandler =
  new MasterclassPayoutWebhookHandler({
    masterclassPayoutService,
    webhookEventService,
  });

export const masterclassPayoutWebhook = onRequest(
  async (request, response) => {
    await handleMasterclassPayoutWebhookRequest(
      request,
      response,
      payoutProvider,
      masterclassPayoutWebhookHandler,
    );
  },
);
