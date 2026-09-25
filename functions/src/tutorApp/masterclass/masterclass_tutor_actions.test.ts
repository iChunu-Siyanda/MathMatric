import {
  describe,
  expect,
  it,
  //beforeAll,
  afterAll,
  beforeEach,
} from "vitest";

import functionsTest from "firebase-functions-test";

import type { CallableRequest } from "firebase-functions/v2/https";
import type { DecodedIdToken } from "firebase-admin/auth";

import { db } from "../../shared/firebase";

import { MasterclassStatus } from "../../payments/masterclasses/masterclass/masterclass_entity";

import * as masterclassTutorActions from "./masterclass_tutor_actions";

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


describe("masterclass tutor actions", () => {
  afterAll(() => {
    testEnv.cleanup();
  });

  beforeEach(async () => {
    await clearCollection("masterclasses");
  });


  describe("createMasterclass", () => {

    it("creates a draft masterclass when authenticated", async () => {
      const wrapped = testEnv.wrap(
        masterclassTutorActions.createMasterclass,
      );

      const result = await wrapped(
        buildCallableRequest(
          {
            title: "June Paper 1 Masterclass",
            description: "Functions and algebra.",
            subjectId: "mathematics",
            topicIds: ["functions", "algebra"],
            examPaperId: null,
            priceCents: 15000,
          },
          { uid: "tutor-1" },
        ),
      );

      expect(result.masterclass.tutorId).toBe("tutor-1");
      expect(result.masterclass.status).toBe(
        MasterclassStatus.draft,
      );
    });

    it("rejects when unauthenticated", async () => {
      const wrapped = testEnv.wrap(
        masterclassTutorActions.createMasterclass,
      );

      await expect(
        wrapped(
          buildCallableRequest({
            title: "June Paper 1 Masterclass",
            description: "Functions and algebra.",
            subjectId: "mathematics",
            topicIds: [],
            examPaperId: null,
            priceCents: 15000,
          }),
        ),
      ).rejects.toMatchObject({ code: "unauthenticated" });
    });

    it("rejects a missing title", async () => {
      const wrapped = testEnv.wrap(
        masterclassTutorActions.createMasterclass,
      );

      await expect(
        wrapped(
          buildCallableRequest(
            {
              description: "Functions and algebra.",
              subjectId: "mathematics",
              topicIds: [],
              examPaperId: null,
              priceCents: 15000,
            },
            { uid: "tutor-1" },
          ),
        ),
      ).rejects.toMatchObject({ code: "invalid-argument" });
    });

    it("rejects an invalid priceCents", async () => {
      const wrapped = testEnv.wrap(
        masterclassTutorActions.createMasterclass,
      );

      await expect(
        wrapped(
          buildCallableRequest(
            {
              title: "June Paper 1 Masterclass",
              description: "Functions and algebra.",
              subjectId: "mathematics",
              topicIds: [],
              examPaperId: null,
              priceCents: 0,
            },
            { uid: "tutor-1" },
          ),
        ),
      ).rejects.toMatchObject({ code: "invalid-argument" });
    });
  });


  describe("requestMasterclassUploadUrl", () => {

    async function seedDraftMasterclass(
      masterclassId: string,
      tutorId: string = "tutor-1",
    ) {
      await db.collection("masterclasses").doc(masterclassId).set({
        tutorId,
        title: "June Paper 1 Masterclass",
        description: "Functions and algebra.",
        subjectId: "mathematics",
        topicIds: [],
        examPaperId: null,
        priceCents: 15000,
        currency: "ZAR",
        streamVideoId: null,
        status: MasterclassStatus.draft,
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    it("returns an upload URL for the owning tutor", async () => {
      await seedDraftMasterclass("masterclass-upload-1");

      const wrapped = testEnv.wrap(
        masterclassTutorActions.requestMasterclassUploadUrl,
      );

      const result = await wrapped(
        buildCallableRequest(
          { masterclassId: "masterclass-upload-1" },
          { uid: "tutor-1" },
        ),
      );

      expect(result.uploadUrl).toBeDefined();
      expect(result.streamVideoId).toBeDefined();
    });

    it("rejects when the masterclass does not exist", async () => {
      const wrapped = testEnv.wrap(
        masterclassTutorActions.requestMasterclassUploadUrl,
      );

      await expect(
        wrapped(
          buildCallableRequest(
            { masterclassId: "does-not-exist" },
            { uid: "tutor-1" },
          ),
        ),
      ).rejects.toMatchObject({ code: "not-found" });
    });

    it("rejects when the tutor does not own the masterclass", async () => {
      await seedDraftMasterclass("masterclass-upload-2");

      const wrapped = testEnv.wrap(
        masterclassTutorActions.requestMasterclassUploadUrl,
      );

      await expect(
        wrapped(
          buildCallableRequest(
            { masterclassId: "masterclass-upload-2" },
            { uid: "different-tutor" },
          ),
        ),
      ).rejects.toMatchObject({ code: "permission-denied" });
    });

    it("rejects when the masterclass is not a draft", async () => {
      await seedDraftMasterclass("masterclass-upload-3");

      await db
        .collection("masterclasses")
        .doc("masterclass-upload-3")
        .update({ status: MasterclassStatus.published });

      const wrapped = testEnv.wrap(
        masterclassTutorActions.requestMasterclassUploadUrl,
      );

      await expect(
        wrapped(
          buildCallableRequest(
            { masterclassId: "masterclass-upload-3" },
            { uid: "tutor-1" },
          ),
        ),
      ).rejects.toMatchObject({ code: "failed-precondition" });
    });
  });


  describe("attachMasterclassStreamVideo", () => {

    async function seedDraftMasterclass(
      masterclassId: string,
    ) {
      await db.collection("masterclasses").doc(masterclassId).set({
        tutorId: "tutor-1",
        title: "June Paper 1 Masterclass",
        description: "Functions and algebra.",
        subjectId: "mathematics",
        topicIds: [],
        examPaperId: null,
        priceCents: 15000,
        currency: "ZAR",
        streamVideoId: null,
        status: MasterclassStatus.draft,
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    it("attaches a verified video to the correct masterclass", async () => {
      await seedDraftMasterclass("masterclass-attach-1");

      const uploadWrapped = testEnv.wrap(
        masterclassTutorActions.requestMasterclassUploadUrl,
      );

      const uploadResult = await uploadWrapped(
        buildCallableRequest(
          { masterclassId: "masterclass-attach-1" },
          { uid: "tutor-1" },
        ),
      );

      const attachWrapped = testEnv.wrap(
        masterclassTutorActions.attachMasterclassStreamVideo,
      );

      const result = await attachWrapped(
        buildCallableRequest(
          {
            masterclassId: "masterclass-attach-1",
            streamVideoId: uploadResult.streamVideoId,
          },
          { uid: "tutor-1" },
        ),
      );

      expect(result.attached).toBe(true);

      const snapshot = await db
        .collection("masterclasses")
        .doc("masterclass-attach-1")
        .get();

      expect(snapshot.data()?.streamVideoId).toBe(
        uploadResult.streamVideoId,
      );
    });

    it("rejects when the video was not found with the provider", async () => {
      const wrapped = testEnv.wrap(
        masterclassTutorActions.attachMasterclassStreamVideo,
      );

      await expect(
        wrapped(
          buildCallableRequest(
            {
              masterclassId: "masterclass-attach-2",
              streamVideoId: "does-not-exist",
            },
            { uid: "tutor-1" },
          ),
        ),
      ).rejects.toMatchObject({ code: "not-found" });
    });

    it("rejects when the video belongs to a different tutor", async () => {
      await seedDraftMasterclass("masterclass-attach-3");

      const uploadWrapped = testEnv.wrap(
        masterclassTutorActions.requestMasterclassUploadUrl,
      );

      const uploadResult = await uploadWrapped(
        buildCallableRequest(
          { masterclassId: "masterclass-attach-3" },
          { uid: "tutor-1" },
        ),
      );

      const attachWrapped = testEnv.wrap(
        masterclassTutorActions.attachMasterclassStreamVideo,
      );

      await expect(
        attachWrapped(
          buildCallableRequest(
            {
              masterclassId: "masterclass-attach-3",
              streamVideoId: uploadResult.streamVideoId,
            },
            { uid: "different-tutor" },
          ),
        ),
      ).rejects.toMatchObject({ code: "permission-denied" });
    });

    it("rejects when the video's masterclassId does not match", async () => {
      await seedDraftMasterclass("masterclass-attach-4");
      await seedDraftMasterclass("masterclass-attach-5");

      const uploadWrapped = testEnv.wrap(
        masterclassTutorActions.requestMasterclassUploadUrl,
      );

      const uploadResult = await uploadWrapped(
        buildCallableRequest(
          { masterclassId: "masterclass-attach-4" },
          { uid: "tutor-1" },
        ),
      );

      const attachWrapped = testEnv.wrap(
        masterclassTutorActions.attachMasterclassStreamVideo,
      );

      await expect(
        attachWrapped(
          buildCallableRequest(
            {
              masterclassId: "masterclass-attach-5",
              streamVideoId: uploadResult.streamVideoId,
            },
            { uid: "tutor-1" },
          ),
        ),
      ).rejects.toMatchObject({ code: "permission-denied" });
    });
  });


  describe("publishMasterclass", () => {

    it("publishes a draft masterclass with content ready", async () => {
      const masterclassId = "masterclass-publish-1";

      await db.collection("masterclasses").doc(masterclassId).set({
        tutorId: "tutor-1",
        title: "June Paper 1 Masterclass",
        description: "Functions and algebra.",
        subjectId: "mathematics",
        topicIds: [],
        examPaperId: null,
        priceCents: 15000,
        currency: "ZAR",
        streamVideoId: "mock-video-masterclass-publish-1",
        status: MasterclassStatus.draft,
        createdAt: new Date(),
        updatedAt: new Date(),
      });

      const wrapped = testEnv.wrap(
        masterclassTutorActions.publishMasterclass,
      );

      const result = await wrapped(
        buildCallableRequest(
          { masterclassId },
          { uid: "tutor-1" },
        ),
      );

      expect(result.masterclass.status).toBe(
        MasterclassStatus.published,
      );
    });

    it("rejects when unauthenticated", async () => {
      const wrapped = testEnv.wrap(
        masterclassTutorActions.publishMasterclass,
      );

      await expect(
        wrapped(
          buildCallableRequest({
            masterclassId: "masterclass-publish-2",
          }),
        ),
      ).rejects.toMatchObject({ code: "unauthenticated" });
    });
  });


  describe("archiveMasterclass", () => {

    it("archives a published masterclass", async () => {
      const masterclassId = "masterclass-archive-1";

      await db.collection("masterclasses").doc(masterclassId).set({
        tutorId: "tutor-1",
        title: "June Paper 1 Masterclass",
        description: "Functions and algebra.",
        subjectId: "mathematics",
        topicIds: [],
        examPaperId: null,
        priceCents: 15000,
        currency: "ZAR",
        streamVideoId: "mock-video-masterclass-archive-1",
        status: MasterclassStatus.published,
        createdAt: new Date(),
        updatedAt: new Date(),
      });

      const wrapped = testEnv.wrap(
        masterclassTutorActions.archiveMasterclass,
      );

      const result = await wrapped(
        buildCallableRequest(
          { masterclassId },
          { uid: "tutor-1" },
        ),
      );

      expect(result.archived).toBe(true);

      const snapshot = await db
        .collection("masterclasses")
        .doc(masterclassId)
        .get();

      expect(snapshot.data()?.status).toBe(
        MasterclassStatus.archived,
      );
    });
  });
});
