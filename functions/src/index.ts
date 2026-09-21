import {onRequest} from "firebase-functions/https";

export const helloMathMatric = onRequest(
  (request, response) => {
    response.send("MathMatric backend is alive.");
  },
);

// --------------------------------------------------
// Payment
// --------------------------------------------------

export { paymentWebhook } from "./payments/webhooks/payment_webhook";
export { paymentStuckSweep } from "./payments/payment/payment_stuck_sweep";
export {
  resolvePaymentAsFailed,
  resolvePaymentAsPaid,
  listStuckPaymentCandidates,
} from "./payments/payment/payment_admin_actions";

// --------------------------------------------------
// Payout
// --------------------------------------------------

export { payoutWebhook } from "./payments/webhooks/payout_webhook";
export { payoutStuckSweep } from "./payments/payout/payout_stuck_sweep";
export {
  resolveStuckPayoutAsFailed,
  resolveStuckPayoutAsSucceeded,
  listStuckPayoutCandidates,
} from "./payments/payout/payout_admin_actions";

//to deploy: firebase deploy --only functions,firestore:indexes