import {FieldValue, Firestore,Timestamp,} from "firebase-admin/firestore";

export const WebhookEventStatus = {
  processing: "processing",
  processed: "processed",
  failed: "failed",
} as const;

export type WebhookEventStatus = typeof WebhookEventStatus[keyof typeof WebhookEventStatus];

// Five minutes gives a webhook invocation enough time
// to complete while still allowing recovery if the
// original invocation crashes or becomes stuck.
const PROCESSING_LEASE_MS = 5 * 60 * 1000;

export class WebhookEventService {
  constructor(
    private readonly firestore: Firestore,
  ) {}

  async startProcessing(
    eventId: string,
  ): Promise<boolean> {
    const eventRef = this.firestore
      .collection("paymentWebhookEvents")
      .doc(eventId);

    return this.firestore.runTransaction(
      async (transaction) => {
        const snapshot =
          await transaction.get(eventRef);

        // First delivery.
        if (!snapshot.exists) {
          transaction.create(eventRef, {
            eventId,
            status: WebhookEventStatus.processing,
            attempts: 1,
            processingStartedAt: FieldValue.serverTimestamp(),
            createdAt: FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp(),
            processedAt: null,
            lastError: null,
          });

          return true;
        }

        const data = snapshot.data();

        // Successfully processed events are permanently
        // ignored. This provides webhook idempotency.
        if (
          data?.status === WebhookEventStatus.processed
        ) {
          return false;
        }

        // Check whether another invocation currently
        // owns the processing lease.
        if (
          data?.status === WebhookEventStatus.processing &&
          data.processingStartedAt instanceof Timestamp
        ) {
          const processingStartedAt = data.processingStartedAt.toDate();

          const leaseAge = Date.now() - processingStartedAt.getTime();

          if (
            leaseAge < PROCESSING_LEASE_MS
          ) {
            return false;
          }
        }

        // Either:
        // - previous attempt failed, or
        // - the processing lease expired.
        //
        // Take ownership and retry.
        transaction.update(eventRef, {
          status: WebhookEventStatus.processing,
          attempts: (typeof data?.attempts === "number"
              ? data.attempts
              : 0) + 1,
          processingStartedAt: FieldValue.serverTimestamp(),
          updatedAt: FieldValue.serverTimestamp(),
          lastError: null,
        });

        return true;
      },
    );
  }

  async markProcessed(
    eventId: string,
  ): Promise<void> {
    const eventRef = this.firestore
      .collection("paymentWebhookEvents")
      .doc(eventId);

    await eventRef.update({
      status: WebhookEventStatus.processed,
      processedAt: FieldValue.serverTimestamp(),
      processingStartedAt: null,
      updatedAt: FieldValue.serverTimestamp(),
      lastError: null,
    });
  }

  async markFailed(
    eventId: string,
    error: string,
  ): Promise<void> {
    const eventRef = this.firestore
      .collection("paymentWebhookEvents")
      .doc(eventId);

    await eventRef.update({
      status: WebhookEventStatus.failed,
      processingStartedAt: null,
      lastError: error,
      updatedAt: FieldValue.serverTimestamp(),
    });
  }
}
