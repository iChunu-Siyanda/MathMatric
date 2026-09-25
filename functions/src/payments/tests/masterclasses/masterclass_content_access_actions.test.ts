import {
  describe,
  expect,
  it,
  afterAll,
  beforeEach,
} from "vitest";

import functionsTest from "firebase-functions-test";

import type { CallableRequest } from "firebase-functions/v2/https";
import type { DecodedIdToken } from "firebase-admin/auth";

import { db } from "../../../shared/firebase";

import { MasterclassStatus } from "../../masterclasses/masterclass/masterclass_entity";
import { MasterclassEnrollmentStatus } from "../../masterclasses/enrollment/masterclass_enrollment_entity";

import * as masterclassContentAccessActions from "../../masterclasses/access/masterclass_content_access_actions";

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


describe("masterclass content access actions", () => {
  const masterclassId = "masterclass-1";
  const studentId = "student-1";
  const enrollmentId = `${masterclassId}_${studentId}`;

  afterAll(() => {
    testEnv.cleanup();
  });

  beforeEach(async () => {
    await clearCollection("masterclasses");
    await clearCollection("masterclassEnrollments");
  });


  async function seedPublishedMasterclass() {
    await db.collection("masterclasses").doc(masterclassId).set({
      tutorId: "tutor-1",
      title: "June Paper 1 Masterclass",
      description: "Functions and algebra.",
      subjectId: "mathematics",
      topicIds: [],
      examPaperId: null,
      priceCents: 15000,
      currency: "ZAR",
      streamVideoId: "stream-video-1",
      status: MasterclassStatus.published,
      createdAt: new Date(),
      updatedAt: new Date(),
    });
  }

  async function seedConfirmedEnrollment(
    overrides: Record<string, unknown> = {},
  ) {
    await db.collection("masterclassEnrollments").doc(enrollmentId).set({
      masterclassId,
      studentId,
      tutorId: "tutor-1",
      priceCents: 15000,
      currency: "ZAR",
      status: MasterclassEnrollmentStatus.confirmed,
      downloadedAt: null,
      enrolledAt: new Date(),
      updatedAt: new Date(),
      cancelledAt: null,
      refundedAt: null,
      ...overrides,
    });
  }


  describe("getMasterclassStreamingAccess", () => {

    it("returns a playback URL for an enrolled student", async () => {
      await seedPublishedMasterclass();
      await seedConfirmedEnrollment();

      const wrapped = testEnv.wrap(
        masterclassContentAccessActions.getMasterclassStreamingAccess,
      );

      const result = await wrapped(
        buildCallableRequest(
          { masterclassId },
          { uid: studentId },
        ),
      );

      expect(result.playbackUrl).toBeDefined();
    });

    it("rejects when unauthenticated", async () => {
      const wrapped = testEnv.wrap(
        masterclassContentAccessActions.getMasterclassStreamingAccess,
      );

      await expect(
        wrapped(buildCallableRequest({ masterclassId })),
      ).rejects.toMatchObject({ code: "unauthenticated" });
    });

    it("rejects a missing masterclassId", async () => {
      const wrapped = testEnv.wrap(
        masterclassContentAccessActions.getMasterclassStreamingAccess,
      );

      await expect(
        wrapped(
          buildCallableRequest({}, { uid: studentId }),
        ),
      ).rejects.toMatchObject({ code: "invalid-argument" });
    });

    it("rejects when the student is not enrolled", async () => {
      await seedPublishedMasterclass();

      const wrapped = testEnv.wrap(
        masterclassContentAccessActions.getMasterclassStreamingAccess,
      );

      await expect(
        wrapped(
          buildCallableRequest(
            { masterclassId },
            { uid: studentId },
          ),
        ),
      ).rejects.toMatchObject({ code: "failed-precondition" });
    });

    it("rejects when the enrollment is not confirmed", async () => {
      await seedPublishedMasterclass();
      await seedConfirmedEnrollment({
        status: MasterclassEnrollmentStatus.pendingPayment,
      });

      const wrapped = testEnv.wrap(
        masterclassContentAccessActions.getMasterclassStreamingAccess,
      );

      await expect(
        wrapped(
          buildCallableRequest(
            { masterclassId },
            { uid: studentId },
          ),
        ),
      ).rejects.toMatchObject({ code: "failed-precondition" });
    });

    it(
      "cannot be used by a different student to access someone else's enrollment",
      async () => {
        await seedPublishedMasterclass();
        await seedConfirmedEnrollment();

        const wrapped = testEnv.wrap(
          masterclassContentAccessActions.getMasterclassStreamingAccess,
        );

        await expect(
          wrapped(
            buildCallableRequest(
              { masterclassId },
              { uid: "different-student" },
            ),
          ),
        ).rejects.toMatchObject({ code: "failed-precondition" });
      },
    );
  });


  describe("getMasterclassDownloadAccess", () => {

    it("returns a download URL and marks the enrollment as downloaded", async () => {
      await seedPublishedMasterclass();
      await seedConfirmedEnrollment();

      const wrapped = testEnv.wrap(
        masterclassContentAccessActions.getMasterclassDownloadAccess,
      );

      const result = await wrapped(
        buildCallableRequest(
          { masterclassId },
          { uid: studentId },
        ),
      );

      expect(result.downloadUrl).toBeDefined();

      const snapshot = await db
        .collection("masterclassEnrollments")
        .doc(enrollmentId)
        .get();

      expect(snapshot.data()?.downloadedAt).toBeDefined();
      expect(snapshot.data()?.downloadedAt).not.toBeNull();
    });

    it(
      "derives the enrollmentId from masterclassId and the authenticated student, not the client",
      async () => {
        await seedPublishedMasterclass();
        await seedConfirmedEnrollment();

        const wrapped = testEnv.wrap(
          masterclassContentAccessActions.getMasterclassDownloadAccess,
        );

        /*
         * Even if a client tried to pass a different
         * enrollmentId, the callable derives it itself
         * from masterclassId + request.auth.uid — there
         * is no enrollmentId field it even reads from
         * request.data.
         */
        await wrapped(
          buildCallableRequest(
            {
              masterclassId,
              enrollmentId: "some-other-enrollment",
            },
            { uid: studentId },
          ),
        );

        const snapshot = await db
          .collection("masterclassEnrollments")
          .doc(enrollmentId)
          .get();

        expect(snapshot.data()?.downloadedAt).not.toBeNull();
      },
    );

    it("rejects when unauthenticated", async () => {
      const wrapped = testEnv.wrap(
        masterclassContentAccessActions.getMasterclassDownloadAccess,
      );

      await expect(
        wrapped(buildCallableRequest({ masterclassId })),
      ).rejects.toMatchObject({ code: "unauthenticated" });
    });

    it("rejects when the student is not enrolled", async () => {
      await seedPublishedMasterclass();

      const wrapped = testEnv.wrap(
        masterclassContentAccessActions.getMasterclassDownloadAccess,
      );

      await expect(
        wrapped(
          buildCallableRequest(
            { masterclassId },
            { uid: studentId },
          ),
        ),
      ).rejects.toMatchObject({ code: "failed-precondition" });
    });
  });
});
