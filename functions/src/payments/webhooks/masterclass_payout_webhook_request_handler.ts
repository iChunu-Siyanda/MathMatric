import {
  Request,
  Response,
} from "express";

import {
  PayoutProvider,
} from "../provider/payout_provider";

import {
  MasterclassPayoutWebhookHandler,
} from "./masterclass_payout_webhook_handler";

export async function handleMasterclassPayoutWebhookRequest(
  request: Request,
  response: Response,
  payoutProvider: PayoutProvider,
  masterclassPayoutWebhookHandler: MasterclassPayoutWebhookHandler,
): Promise<void> {
  try {
    if (request.method !== "POST") {
      response
        .status(405)
        .send("Method Not Allowed");
      return;
    }

    const signature =
      request.headers["x-payout-signature"];

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
      payoutProvider.verifyWebhook(
        rawBody,
        signature,
      );

    const result =
      await masterclassPayoutWebhookHandler.handle(event);

    response
      .status(result.statusCode)
      .send(result.message);
  } catch (error) {
    console.error(
      "Masterclass payout webhook failed.",
      error,
    );

    response
      .status(500)
      .send(
        "Webhook processing failed.",
      );
  }
}
