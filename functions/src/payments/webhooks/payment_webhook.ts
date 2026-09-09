import {onRequest,} from "firebase-functions/v2/https";

import {
  db,
} from "../../shared/firebase";

import {
  PaymentService,
} from "../payment/payment_service";

import {
  PaymentSuccessService,
} from "../payment/payent_success_service";

import {
  TransactionReferenceIdentity,
} from "../transactions/transaction_reference_identity";

import {
  TransactionService,
} from "../transactions/transaction_service";

import {
  MockPaymentProvider,
} from "../provider/mock_payment_provider";

import {
  PaymentProvider,
} from "../provider/payment_provider";

import {
  WebhookEventService,
} from "./webhook_event_service";

import {
  PaymentWebhookHandler,
} from "./payment_webhook_handler";

const paymentProvider: PaymentProvider =new MockPaymentProvider();

const paymentService = new PaymentService(db,paymentProvider,);

const referenceIdentity =
  new TransactionReferenceIdentity(db);

const transactionService =
  new TransactionService(
    db,
    referenceIdentity,
  );

const paymentSuccessService =
  new PaymentSuccessService(
    db,
    transactionService,
  );

const webhookEventService =
  new WebhookEventService(db);

const paymentWebhookHandler =
  new PaymentWebhookHandler({
    paymentService,
    paymentSuccessService,
    webhookEventService,
  });

export const paymentWebhook =
  onRequest(
    async (request, response) => {
      try {
        if (request.method !== "POST") {
          response
            .status(405)
            .send(
              "Method Not Allowed",
            );

          return;
        }

        const signature =
          request.headers[
            "x-payment-signature"
          ];

        if (
          typeof signature !==
          "string"
        ) {
          response
            .status(401)
            .send(
              "Missing webhook signature.",
            );

          return;
        }

        const rawBody =
          Buffer.isBuffer(
            request.rawBody,
          )
            ? request.rawBody.toString(
                "utf8",
              )
            : String(
                request.rawBody,
              );

        const event =
          paymentProvider.verifyWebhook(
            rawBody,
            signature,
          );

        const result =
          await paymentWebhookHandler
            .handle(event);

        response
          .status(result.statusCode)
          .send(result.message);
      } catch (error) {
        console.error(
          "Payment webhook failed.",
          error,
        );

        response
          .status(500)
          .send(
            "Webhook processing failed.",
          );
      }
    },
  );
