import {onRequest,} from "firebase-functions/v2/https";
import {db,} from "../../shared/firebase";
import {PaymentService,} from "./payment_service";
import {WebhookEventService,} from "./webhook_event_service";
import {MockPaymentProvider,} from "./mock_payment_provider";
import { PaymentProvider } from "./payment_provider";

const paymentProvider:PaymentProvider = new MockPaymentProvider();
const paymentService = new PaymentService(db,paymentProvider,);
const webhookEventService = new WebhookEventService(db);

export const paymentWebhook = onRequest(
  async (request, response) => {
    let eventId:string |null=null;

    try {
      if (request.method !== "POST") {
        response.status(405).send("Method Not Allowed");

        return;
      }

      const signature = request.headers["x-payment-signature"];

      if (
        typeof signature !== "string"
      ) {
        response.status(401).send("Missing webhook signature.");

        return;
      }

      const rawBody = Buffer.isBuffer(request.rawBody)
          ? request.rawBody.toString("utf8")
          : String(request.rawBody);;

      const event =paymentProvider.verifyWebhook(
        rawBody,
        signature,
      );

      eventId = event.eventId;

      const shouldProcess = await webhookEventService.startProcessing(event.eventId,);

      if (!shouldProcess) {
        response.status(200).send("Already processed.");
        return;
      }

      switch (event.status) {
        case "processing":
          await paymentService.markProcessing({
            paymentId: event.bookingId,
          });

          break;

        case "paid":
          await paymentService.markPaidFromProvider({
            bookingId: event.bookingId,
            provider: paymentProvider.name,
            providerPaymentId: event.providerPaymentId,
          });
          break;

        case "failed":
          await paymentService.markFailed({
            bookingId: event.bookingId,
            failureReason: event.failureReason ?? "Payment failed.",
          });

          break;

        default:
          throw new Error("Unsupported payment status.",);
      }
      
      await webhookEventService.markProcessed(event.eventId,);

      response.status(200).send("Webhook processed.");
    } catch (error) {
      console.error(
        "Payment webhook failed.",
        error,
      );

      if (eventId !== null) {
        try {
          await webhookEventService.markFailed(
            eventId,
            error instanceof Error
              ? error.message
              : "Unknown webhook error.",
          );
        } catch (markFailedError) {
          console.error(
            "Failed to record webhook failure.",
            markFailedError,
          );
        }
      }

      response.status(500).send("Webhook processing failed.");
    }
  });
