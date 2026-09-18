import {
  PaymentService,
} from "../payment/payment_service";

import {
  PaymentSuccessService,
} from "../payment/payment_success_service";

import {
  PaymentWebhookEvent,
} from "../provider/payment_provider";

import {
  WebhookEventService,
} from "./webhook_event_service";

export interface PaymentWebhookHandlerDependencies {
  paymentService: PaymentService;
  paymentSuccessService: PaymentSuccessService;
  webhookEventService: WebhookEventService;
}

export interface PaymentWebhookHandlerResult {
  statusCode: number;
  message: string;
}

export class PaymentWebhookHandler {
  constructor(
    private readonly dependencies: PaymentWebhookHandlerDependencies,
  ) {}

  async handle(
    event: PaymentWebhookEvent,
  ): Promise<PaymentWebhookHandlerResult> {
    const {
      paymentService,
      paymentSuccessService,
      webhookEventService,
    } = this.dependencies;
    
    console.log("A. starting webhook processing");
    const shouldProcess =
      await webhookEventService
        .startProcessing(event.eventId);
    
    console.log(
      "B. startProcessing returned:",
      shouldProcess,
    );
    if (!shouldProcess) {
      return {
        statusCode: 200,
        message: "Already processed.",
      };
    }

    try {
      console.log("C. entering event switch");
      switch (event.status) {
        case "processing":
          console.log("D. processing event");
          await paymentService
            .markProcessing({
              paymentId: event.bookingId,
            });

          break;

        case "paid":
          console.log("D. paid event");
          console.log("E. calling markPaymentPaid");
          await paymentSuccessService
            .markPaymentPaid({
              bookingId: event.bookingId,
              providerPaymentId: event.providerPaymentId,
              paidAt: event.occurredAt,
            });
            console.log("F. markPaymentPaid returned");
          break;

        case "failed":
          console.log("D. failed event");
          await paymentService
            .markFailed({
              bookingId: event.bookingId,
              failureReason: event.failureReason ?? "Payment failed.",
            });

          break;

        default:
          throw new Error("Unsupported payment status.",);
      }
      
      console.log("G. marking webhook processed");
      await webhookEventService
        .markProcessed(
          event.eventId,
        );
      
        console.log("H. webhook marked processed");
      return {
        statusCode: 200,
        message: "Webhook processed.",
      };
    } catch (error) {
      console.log("I. webhook handler caught error", error);
      try {
        await webhookEventService
          .markFailed(
            event.eventId,
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

      throw error;
    }
  }
}
