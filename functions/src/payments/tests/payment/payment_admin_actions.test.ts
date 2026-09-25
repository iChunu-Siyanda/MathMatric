import {
  describe,
  expect,
  it,
  beforeAll,
  afterAll,
  beforeEach,
} from "vitest";

import functionsTest from "firebase-functions-test";

import type { CallableRequest } from "firebase-functions/v2/https";
import type { DecodedIdToken } from "firebase-admin/auth";

import { db } from "../../../shared/firebase";

import { PaymentStatus } from "../../payment/payment_entity";
import { PaymentService } from "../../payment/payment_service";
import { BookingStatus } from "../../../bookings/booking_status";
import { PaymentProvider } from "../../provider/payment_provider";

import * as paymentAdminActions from "../../payment/payment_admin_actions";

const testEnv = functionsTest();


function buildCallableRequest(
  data: Record<string, unknown>,
  auth?: {
    uid: string;
    token?: Partial<DecodedIdToken>;
  },
): CallableRequest<any> {
  return {
    data,
    auth: auth
      ? { uid: auth.uid, token: auth.token as DecodedIdToken }
      : undefined,
  } as unknown as CallableRequest<any>;
}


async function clearCollection(
  collectionName: string,
): Promise<void> {
  const snapshot = await db.collection(collectionName).get();

  if (snapshot.empty) return;

  const batch = db.batch();

  for (const document of snapshot.docs) {
    batch.delete(document.ref);
  }

  await batch.commit();
}


describe("payment admin actions", () => {
  let paymentService: PaymentService;

  beforeAll(() => {
    const paymentProvider: PaymentProvider = {
      name: "mock",
      createPayment: async () => {
        throw new Error("Not used in these tests.");
      },
      refundPayment: async () => {
        throw new Error("Not used in these tests.");
      },
      verifyWebhook: () => {
        throw new Error("Not used in these tests.");
      },
    };

    paymentService = new PaymentService(db, paymentProvider);
  });

  afterAll(() => {
    testEnv.cleanup();
  });

  beforeEach(async () => {
    await clearCollection("payments");
    await clearCollection("bookings");
    await clearCollection("transactions");
    await clearCollection("transactionReferences");
  });


  async function seedStuckPayment(bookingId: string) {
    await db.collection("payments").doc(bookingId).set({
      bookingId,
      studentId: "student-1",
      tutorId: "tutor-1",
      amountCents: 45000,
      refundedAmountCents: 0,
      refundReservedAmountCents: 0,
      currency: "ZAR",
      status: PaymentStatus.processing,
      provider: "mock",
      providerPaymentId: `mock-${bookingId}`,
      createdAt: new Date(),
      updatedAt: new Date(),
      paidAt: null,
      failureReason: null,
    });

    await paymentService.markStuck(bookingId);
  }


  describe("requireAdmin gate", () => {

    it(
      "rejects resolvePaymentAsFailed when unauthenticated",
      async () => {
        const wrapped = testEnv.wrap(
          paymentAdminActions.resolvePaymentAsFailed,
        );

        await expect(
          wrapped(
            buildCallableRequest({
              bookingId: "booking-x",
              resolutionNote: "note",
            }),
          ),
        ).rejects.toMatchObject({ code: "unauthenticated" });
      },
    );

    it(
      "rejects resolvePaymentAsPaid when authenticated without the admin claim",
      async () => {
        const wrapped = testEnv.wrap(
          paymentAdminActions.resolvePaymentAsPaid,
        );

        await expect(
          wrapped(
            buildCallableRequest(
              {
                bookingId: "booking-x",
                providerPaymentId: "mock-x",
              },
              { uid: "user-1", token: {} },
            ),
          ),
        ).rejects.toMatchObject({ code: "permission-denied" });
      },
    );

    it(
      "rejects listStuckPaymentCandidates when unauthenticated",
      async () => {
        const wrapped = testEnv.wrap(
          paymentAdminActions.listStuckPaymentCandidates,
        );

        await expect(
          wrapped(buildCallableRequest({})),
        ).rejects.toMatchObject({ code: "unauthenticated" });
      },
    );
  });


  describe("resolvePaymentAsFailed (as admin)", () => {

    it("resolves a stuck payment", async () => {
      await seedStuckPayment("booking-1");

      const wrapped = testEnv.wrap(
        paymentAdminActions.resolvePaymentAsFailed,
      );

      const result = await wrapped(
        buildCallableRequest(
          {
            bookingId: "booking-1",
            resolutionNote: "Confirmed never charged.",
          },
          { uid: "admin-1", token: { admin: true } },
        ),
      );

      expect(result.resolved).toBe(true);

      const snapshot = await db
        .collection("payments")
        .doc("booking-1")
        .get();

      expect(snapshot.data()?.status).toBe(
        PaymentStatus.failed,
      );
    });

    it("rejects a missing bookingId", async () => {
      const wrapped = testEnv.wrap(
        paymentAdminActions.resolvePaymentAsFailed,
      );

      await expect(
        wrapped(
          buildCallableRequest(
            { resolutionNote: "note" },
            { uid: "admin-1", token: { admin: true } },
          ),
        ),
      ).rejects.toMatchObject({ code: "invalid-argument" });
    });

    it(
      "surfaces a domain error as failed-precondition when the payment is not stuck",
      async () => {
        await db.collection("payments").doc("booking-2").set({
          bookingId: "booking-2",
          studentId: "student-1",
          tutorId: "tutor-1",
          amountCents: 45000,
          refundedAmountCents: 0,
          refundReservedAmountCents: 0,
          currency: "ZAR",
          status: PaymentStatus.pending,
          provider: null,
          providerPaymentId: null,
          createdAt: new Date(),
          updatedAt: new Date(),
          paidAt: null,
          failureReason: null,
        });

        const wrapped = testEnv.wrap(
          paymentAdminActions.resolvePaymentAsFailed,
        );

        await expect(
          wrapped(
            buildCallableRequest(
              {
                bookingId: "booking-2",
                resolutionNote: "note",
              },
              { uid: "admin-1", token: { admin: true } },
            ),
          ),
        ).rejects.toMatchObject({
          code: "failed-precondition",
          message:
            "Only a stuck payment can be resolved as failed.",
        });
      },
    );
  });


  describe("resolvePaymentAsPaid (as admin)", () => {

    it("resolves a stuck payment via markPaymentPaid", async () => {
      const bookingId = "booking-3";

      await db.collection("bookings").doc(bookingId).set({
        studentId: "student-1",
        tutorId: "tutor-1",
        priceCents: 45000,
        status: BookingStatus.paymentRequired,
      });

      await seedStuckPayment(bookingId);

      const wrapped = testEnv.wrap(
        paymentAdminActions.resolvePaymentAsPaid,
      );

      const result = await wrapped(
        buildCallableRequest(
          {
            bookingId,
            providerPaymentId: `mock-${bookingId}`,
          },
          { uid: "admin-1", token: { admin: true } },
        ),
      );

      expect(result.payment.status).toBe(PaymentStatus.paid);

      const bookingSnapshot = await db
        .collection("bookings")
        .doc(bookingId)
        .get();

      expect(bookingSnapshot.data()?.status).toBe(
        BookingStatus.confirmed,
      );
    });

    it("rejects a missing providerPaymentId", async () => {
      const wrapped = testEnv.wrap(
        paymentAdminActions.resolvePaymentAsPaid,
      );

      await expect(
        wrapped(
          buildCallableRequest(
            { bookingId: "booking-4" },
            { uid: "admin-1", token: { admin: true } },
          ),
        ),
      ).rejects.toMatchObject({ code: "invalid-argument" });
    });
  });


  describe("listStuckPaymentCandidates (as admin)", () => {

    it(
      "returns stuck-eligible candidates without mutating them",
      async () => {
        await db.collection("payments").doc("booking-5").set({
          bookingId: "booking-5",
          studentId: "student-1",
          tutorId: "tutor-1",
          amountCents: 45000,
          refundedAmountCents: 0,
          refundReservedAmountCents: 0,
          currency: "ZAR",
          status: PaymentStatus.processing,
          provider: "mock",
          providerPaymentId: "mock-booking-5",
          createdAt: new Date(),
          updatedAt: new Date(Date.now() - 60 * 60 * 1000),
          paidAt: null,
          failureReason: null,
        });

        const wrapped = testEnv.wrap(
          paymentAdminActions.listStuckPaymentCandidates,
        );

        const result = await wrapped(
          buildCallableRequest(
            {},
            { uid: "admin-1", token: { admin: true } },
          ),
        );

        expect(
          result.candidates.map((c: { id: string }) => c.id),
        ).toContain("booking-5");

        const snapshot = await db
          .collection("payments")
          .doc("booking-5")
          .get();

        expect(snapshot.data()?.status).toBe(
          PaymentStatus.processing,
        );
      },
    );
  });
});
