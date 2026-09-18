import {onRequest,} from "firebase-functions/v2/https";
import {db,} from "../../shared/firebase";
import {PayoutService,} from "../payout/payout_service";
import {TutorPayoutEligibilityService,} from "../payout/tutor_payout_eligibility_service";
import {TwentyPercentPlatformFeeCalculator,} from "../payout/platform_fee_calculator";
import {TransactionReferenceIdentity,} from "../transactions/transaction_reference_identity";
import {TransactionService,} from "../transactions/transaction_service";
import {PayoutTransactionService,} from "../transactions/payout_transaction_service";
import {MockPayoutProvider,} from "../provider/mock_payout_provider";
import {PayoutProvider,} from "../provider/payout_provider";
import {PayoutProviderIdentity,} from "../provider/payout_provider_identity";
import {WebhookEventService,} from "./webhook_event_service";
import {PayoutWebhookHandler,} from "./payout_webhook_handler";
import { handlePayoutWebhookRequest } from "./payout_webhook_request_handler";

const payoutProvider: PayoutProvider = new MockPayoutProvider();

const referenceIdentity =
  new TransactionReferenceIdentity(db);

const transactionService =
  new TransactionService(
    db,
    referenceIdentity,
  );

const payoutTransactionService =
  new PayoutTransactionService(
    db,
    transactionService,
  );

const feeCalculator =
  new TwentyPercentPlatformFeeCalculator();

const eligibilityService =
  new TutorPayoutEligibilityService(
    feeCalculator,
  );

const payoutProviderIdentity =
  new PayoutProviderIdentity(
    db,
    payoutProvider,
  );

const payoutService =
  new PayoutService(
    db,
    eligibilityService,
    payoutTransactionService,
    payoutProvider,
    payoutProviderIdentity,
  );

const webhookEventService =
  new WebhookEventService(db, "payoutWebhookEvents");

const payoutWebhookHandler =
  new PayoutWebhookHandler({
    payoutService,
    webhookEventService,
  });

export const payoutWebhook = onRequest(
  async (request, response) => {
    await handlePayoutWebhookRequest(
      request,
      response,
      payoutProvider,
      payoutWebhookHandler,
    );
  },
);
