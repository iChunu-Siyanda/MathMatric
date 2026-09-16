import {
  describe,
  expect,
  it,
  beforeEach,
} from "vitest";

import {
  PayoutStatus,
  TutorPayout,
} from "../../payout/payout_entity";

import {
  PayoutTransactionService,
} from "../../transactions/payout_transaction_service";

import {
  TransactionDirection,
  TransactionStatus,
  TransactionType,
} from "../../transactions/transaction";

import {
  TransactionReferenceIdentity,
} from "../../transactions/transaction_reference_identity";

import {
  TransactionService,
} from "../../transactions/transaction_service";

import { db } from "../../../shared/firebase";

describe(
  "PayoutTransactionService",
  () => {

    let service: PayoutTransactionService;

    const payout: TutorPayout = {
      id: "payout-booking-123",
      bookingId: "booking-123",
      paymentId: "booking-123",
      tutorId: "tutor-123",
      amountCents: 40000,
      currency: "ZAR",
      status: PayoutStatus.pending,
      provider: null,
      providerPayoutId: null,
      createdAt: new Date(),
      updatedAt: new Date(),
      completedAt: null,
      failureReason: null,
    };

    const booking = {
      id: "booking-123",
      studentId: "student-123",
    };

    async function clearCollection(
      collectionName: string,
    ): Promise<void> {
      const snapshot =
        await db.collection(collectionName).get();

      for (const document of snapshot.docs) {
        await document.ref.delete();
      }
    }

    beforeEach(
      async () => {
        await clearCollection("tutorPayouts");
        await clearCollection("transactions");
        await clearCollection("transactionReferences");

        const referenceIdentity = new TransactionReferenceIdentity(db,);

        const transactionService = new TransactionService(
          db,
          referenceIdentity,
        );

        service =
          new PayoutTransactionService(
            db,
            transactionService,
          );
      },
    );

    async function seedPayoutTransaction() {
      const transactionService =
        new TransactionService(
          db,
          new TransactionReferenceIdentity(
            db,
          ),
        );

      await transactionService
        .createTransaction({
          transactionId:
            `payout-${payout.id}`,
          bookingId:
            payout.bookingId,
          paymentId:
            payout.paymentId,
          type:
            TransactionType.payout,
          direction:
            TransactionDirection.debit,
          status:
            TransactionStatus.pending,
          amountCents:
            payout.amountCents,
          currency:
            payout.currency,
          studentId:
            booking.studentId,
          tutorId:
            payout.tutorId,
          referenceId:
            payout.id,
          description:
            `Tutor payout for booking ${payout.bookingId}`,
          completedAt: null,
        });
    }

    describe(
      "markSucceededInTransaction",
      () => {
        it(
          "marks a pending payout transaction as completed",
          async () => {
            await seedPayoutTransaction();

            const transaction =
              await db.runTransaction(
                async (firestoreTransaction) => {
                  return service
                    .markSucceededInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              );

            expect(
              transaction.status,
            ).toBe(
              TransactionStatus.completed,
            );

            expect(
              transaction.completedAt,
            ).toBeInstanceOf(Date);

            const snapshot =
              await db
                .collection("transactions")
                .doc(
                  `payout-${payout.id}`,
                )
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(
              TransactionStatus.completed,
            );

            expect(
              snapshot.data()?.completedAt,
            ).toBeDefined();
          },
        );

        it(
          "is idempotent when the transaction is already completed",
          async () => {
            await seedPayoutTransaction();

            await db
              .collection("transactions")
              .doc(
                `payout-${payout.id}`,
              )
              .update({
                status:
                  TransactionStatus.completed,
                completedAt:
                  new Date(),
              });

            const transaction =
              await db.runTransaction(
                async (firestoreTransaction) => {
                  return service
                    .markSucceededInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              );

            expect(
              transaction.status,
            ).toBe(
              TransactionStatus.completed,
            );
          },
        );

        it(
          "rejects a failed transaction",
          async () => {
            await seedPayoutTransaction();

            await db
              .collection("transactions")
              .doc(
                `payout-${payout.id}`,
              )
              .update({
                status:
                  TransactionStatus.failed,
              });

            await expect(
              db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markSucceededInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              ),
            ).rejects.toThrow(
              "Only a pending payout transaction can be completed.",
            );
          },
        );

        it(
          "rejects a transaction belonging to a different payout",
          async () => {
            await seedPayoutTransaction();

            const differentPayout = {
              ...payout,
              id: "payout-other",
            };

            await expect(
              db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markSucceededInTransaction(
                      firestoreTransaction,
                      differentPayout,
                    );
                },
              ),
            ).rejects.toThrow(
              "Payout transaction does not exist.",
            );
          },
        );

        it(
          "rejects when the payout transaction does not exist",
          async () => {
            await expect(
              db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markSucceededInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              ),
            ).rejects.toThrow(
              "Payout transaction does not exist.",
            );
          },
        );
      },
    );

    describe(
      "markFailedInTransaction",
      () => {
        it(
          "marks a pending payout transaction as failed",
          async () => {
            await seedPayoutTransaction();

            const transaction =
              await db.runTransaction(
                async (firestoreTransaction) => {
                  return service
                    .markFailedInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              );

            expect(
              transaction.status,
            ).toBe(
              TransactionStatus.failed,
            );

            const snapshot =
              await db
                .collection("transactions")
                .doc(
                  `payout-${payout.id}`,
                )
                .get();

            expect(
              snapshot.data()?.status,
            ).toBe(
              TransactionStatus.failed,
            );
          },
        );

        it(
          "is idempotent when the transaction is already failed",
          async () => {
            await seedPayoutTransaction();

            await db
              .collection("transactions")
              .doc(
                `payout-${payout.id}`,
              )
              .update({
                status:
                  TransactionStatus.failed,
              });

            const transaction =
              await db.runTransaction(
                async (firestoreTransaction) => {
                  return service
                    .markFailedInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              );

            expect(
              transaction.status,
            ).toBe(
              TransactionStatus.failed,
            );
          },
        );

        it(
          "rejects a completed transaction",
          async () => {
            await seedPayoutTransaction();

            await db
              .collection("transactions")
              .doc(
                `payout-${payout.id}`,
              )
              .update({
                status:
                  TransactionStatus.completed,
              });

            await expect(
              db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markFailedInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              ),
            ).rejects.toThrow(
              "Only a pending payout transaction can be failed.",
            );
          },
        );

        it(
          "rejects when the payout transaction does not exist",
          async () => {
            await expect(
              db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markFailedInTransaction(
                      firestoreTransaction,
                      payout,
                    );
                },
              ),
            ).rejects.toThrow(
              "Payout transaction does not exist.",
            );
          },
        );

        it(
          "rejects a transaction with a mismatched amount",
          async () => {
            await seedPayoutTransaction();

            const differentPayout = {
              ...payout,
              amountCents: 35000,
            };

            await expect(
              db.runTransaction(
                async (
                  firestoreTransaction,
                ) => {
                  return service
                    .markFailedInTransaction(
                      firestoreTransaction,
                      differentPayout,
                    );
                },
              ),
            ).rejects.toThrow(
              "Transaction amount does not match the payout.",
            );
          },
        );
      },
    );
  },
);


// Eligibility
//     ↓
// PayoutService
//     ↓
// TutorPayout
//     ↕ atomic
// PayoutTransactionService
//     ↓
// Transaction
