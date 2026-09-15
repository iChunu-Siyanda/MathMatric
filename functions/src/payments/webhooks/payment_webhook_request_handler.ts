import {
  Request,
  Response,
} from "express";

import {
  PaymentProvider,
} from "../provider/payment_provider";

import {
  PaymentWebhookHandler,
} from "./payment_webhook_handler";

export async function handlePaymentWebhookRequest(
  request: Request,
  response: Response,
  paymentProvider: PaymentProvider,
  paymentWebhookHandler: PaymentWebhookHandler,
): Promise<void> {
  try {
    if (request.method !== "POST") {
      response
        .status(405)
        .send("Method Not Allowed");
      return;
    }

    const signature =
      request.headers["x-payment-signature"];

    if (typeof signature !== "string") {
      response
        .status(401)
        .send("Missing webhook signature.");
      return;
    }

    if (!request.rawBody) {
      response
        .status(400)
        .send("Missing webhook body.");
      return;
    }

    const rawBody =
      request.rawBody.toString("utf8");

    const event =
      paymentProvider.verifyWebhook(
        rawBody,
        signature,
      );

    const result =
      await paymentWebhookHandler.handle(event);

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
}
