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


// // Masterclass — Payment
// export { masterclassPaymentWebhook } from "./payments/webhooks/masterclass_payment_webhook";
// export { masterclassPaymentStuckSweep } from "./payments/webhooks/masterclass_payment_stuck_sweep";
// export {
//   resolveMasterclassPaymentAsFailed,
//   resolveMasterclassPaymentAsPaid,
//   listStuckMasterclassPaymentCandidates,
// } from "./payments/webhooks/masterclass_payment_admin_actions";

// // Masterclass — Payout
// export { masterclassPayoutWebhook } from "./payments/webhooks/masterclass_payout_webhook";
// export { masterclassPayoutStuckSweep } from "./payments/masterclasses/payout/masterclass_payout_stuck_sweep";
// export {
//   resolveMasterclassStuckPayoutAsFailed,
//   resolveMasterclassStuckPayoutAsSucceeded,
//   listStuckMasterclassPayoutCandidates,
// } from "./payments/webhooks/masterclass_payout_admin_actions";

//to deploy: firebase deploy --only functions,firestore:indexes