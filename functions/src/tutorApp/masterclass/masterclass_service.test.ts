import { Timestamp, Firestore } from "firebase-admin/firestore";
import { beforeEach, describe, expect, it } from "vitest";
import { MasterclassService } from "./masterclass_service";
import { createMockFirestore } from "../../payments/tests/mock_firestore";
import { MasterclassStatus } from "../../payments/masterclasses/masterclass/masterclass_entity";


describe("MasterclassService", () => {
  let firestore: Firestore;
  let mockFirestore: ReturnType<typeof createMockFirestore>;
  let service: MasterclassService;

  const tutorId = "tutor-1";

  beforeEach(() => {
    mockFirestore = createMockFirestore();
    firestore = mockFirestore as unknown as Firestore;
    service = new MasterclassService(firestore);
  });

  // ==================================================
  // createMasterclass
  // ==================================================

  describe("createMasterclass", () => {
    it("creates a draft masterclass with no content yet", async () => {
      const masterclass = await service.createMasterclass({
        tutorId,
        title: "June Paper 1 Masterclass",
        description: "Functions and algebra.",
        subjectId: "mathematics",
        topicIds: ["functions", "algebra"],
        examPaperId: null,
        priceCents: 15000,
      });

      expect(masterclass.tutorId).toBe(tutorId);
      expect(masterclass.title).toBe(
        "June Paper 1 Masterclass",
      );
      expect(masterclass.description).toBe(
        "Functions and algebra.",
      );
      expect(masterclass.subjectId).toBe("mathematics");
      expect(masterclass.topicIds).toEqual([
        "functions",
        "algebra",
      ]);
      expect(masterclass.examPaperId).toBeNull();
      expect(masterclass.priceCents).toBe(15000);
      expect(masterclass.currency).toBe("ZAR");
      expect(masterclass.streamVideoId).toBeNull();
      expect(masterclass.status).toBe(MasterclassStatus.draft);

      const stored = mockFirestore.get(
        `masterclasses/${masterclass.id}`,
      );

      expect(stored).toEqual(
        expect.objectContaining({
          tutorId,
          title: "June Paper 1 Masterclass",
          status: MasterclassStatus.draft,
          streamVideoId: null,
        }),
      );
    });

    it("trims title and description", async () => {
      const masterclass = await service.createMasterclass({
        tutorId,
        title: "  June Paper 1 Masterclass  ",
        description: "  Functions and algebra.  ",
        subjectId: "mathematics",
        topicIds: [],
        examPaperId: null,
        priceCents: 15000,
      });

      expect(masterclass.title).toBe(
        "June Paper 1 Masterclass",
      );
      expect(masterclass.description).toBe(
        "Functions and algebra.",
      );
    });

    it("rejects an empty title", async () => {
      await expect(
        service.createMasterclass({
          tutorId,
          title: "   ",
          description: "Functions and algebra.",
          subjectId: "mathematics",
          topicIds: [],
          examPaperId: null,
          priceCents: 15000,
        }),
      ).rejects.toThrow("Title is required.");
    });

    it("rejects an empty description", async () => {
      await expect(
        service.createMasterclass({
          tutorId,
          title: "June Paper 1 Masterclass",
          description: "   ",
          subjectId: "mathematics",
          topicIds: [],
          examPaperId: null,
          priceCents: 15000,
        }),
      ).rejects.toThrow("Description is required.");
    });

    it("rejects a zero price", async () => {
      await expect(
        service.createMasterclass({
          tutorId,
          title: "June Paper 1 Masterclass",
          description: "Functions and algebra.",
          subjectId: "mathematics",
          topicIds: [],
          examPaperId: null,
          priceCents: 0,
        }),
      ).rejects.toThrow(
        "priceCents must be a positive integer.",
      );
    });

    it("rejects a negative price", async () => {
      await expect(
        service.createMasterclass({
          tutorId,
          title: "June Paper 1 Masterclass",
          description: "Functions and algebra.",
          subjectId: "mathematics",
          topicIds: [],
          examPaperId: null,
          priceCents: -100,
        }),
      ).rejects.toThrow(
        "priceCents must be a positive integer.",
      );
    });

    it("rejects a non-integer price", async () => {
      await expect(
        service.createMasterclass({
          tutorId,
          title: "June Paper 1 Masterclass",
          description: "Functions and algebra.",
          subjectId: "mathematics",
          topicIds: [],
          examPaperId: null,
          priceCents: 150.5,
        }),
      ).rejects.toThrow(
        "priceCents must be a positive integer.",
      );
    });
  });

  // ==================================================
  // attachStreamVideo
  // ==================================================

  describe("attachStreamVideo", () => {
    function seedDraftMasterclass(
      overrides: Record<string, unknown> = {},
    ) {
      mockFirestore.seed("masterclasses/masterclass-1", {
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
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        ...overrides,
      });
    }

    it("attaches the stream video ID to a draft masterclass", async () => {
      seedDraftMasterclass();

      await service.attachStreamVideo({
        masterclassId: "masterclass-1",
        tutorId,
        streamVideoId: "stream-video-1",
      });

      const stored = mockFirestore.get(
        "masterclasses/masterclass-1",
      );

      expect(stored?.streamVideoId).toBe("stream-video-1");
    });

    it("rejects when the masterclass does not exist", async () => {
      await expect(
        service.attachStreamVideo({
          masterclassId: "masterclass-1",
          tutorId,
          streamVideoId: "stream-video-1",
        }),
      ).rejects.toThrow("Masterclass not found.");
    });

    it("rejects when the tutor does not own the masterclass", async () => {
      seedDraftMasterclass();

      await expect(
        service.attachStreamVideo({
          masterclassId: "masterclass-1",
          tutorId: "different-tutor",
          streamVideoId: "stream-video-1",
        }),
      ).rejects.toThrow(
        "Tutor does not own this masterclass.",
      );
    });

    it("rejects an empty streamVideoId", async () => {
      seedDraftMasterclass();

      await expect(
        service.attachStreamVideo({
          masterclassId: "masterclass-1",
          tutorId,
          streamVideoId: "   ",
        }),
      ).rejects.toThrow(
        "streamVideoId cannot be empty.",
      );
    });

    it("rejects attaching content to a published masterclass", async () => {
      seedDraftMasterclass({
        status: MasterclassStatus.published,
        streamVideoId: "existing-video",
      });

      await expect(
        service.attachStreamVideo({
          masterclassId: "masterclass-1",
          tutorId,
          streamVideoId: "stream-video-2",
        }),
      ).rejects.toThrow(
        "Content can only be attached to a draft masterclass.",
      );
    });

    it("rejects attaching content to an archived masterclass", async () => {
      seedDraftMasterclass({
        status: MasterclassStatus.archived,
        streamVideoId: "existing-video",
      });

      await expect(
        service.attachStreamVideo({
          masterclassId: "masterclass-1",
          tutorId,
          streamVideoId: "stream-video-2",
        }),
      ).rejects.toThrow(
        "Content can only be attached to a draft masterclass.",
      );
    });
  });

  // ==================================================
  // publish
  // ==================================================

  describe("publish", () => {
    function seedMasterclass(
      overrides: Record<string, unknown> = {},
    ) {
      mockFirestore.seed("masterclasses/masterclass-1", {
        tutorId,
        title: "June Paper 1 Masterclass",
        description: "Functions and algebra.",
        subjectId: "mathematics",
        topicIds: [],
        examPaperId: null,
        priceCents: 15000,
        currency: "ZAR",
        streamVideoId: "stream-video-1",
        status: MasterclassStatus.draft,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        ...overrides,
      });
    }

    it("publishes a draft masterclass with content ready", async () => {
      seedMasterclass();

      const result = await service.publish({
        masterclassId: "masterclass-1",
        tutorId,
      });

      expect(result.status).toBe(MasterclassStatus.published);

      const stored = mockFirestore.get(
        "masterclasses/masterclass-1",
      );

      expect(stored?.status).toBe(MasterclassStatus.published);
    });

    it("is idempotent when already published", async () => {
      seedMasterclass({
        status: MasterclassStatus.published,
      });

      const result = await service.publish({
        masterclassId: "masterclass-1",
        tutorId,
      });

      expect(result.status).toBe(MasterclassStatus.published);
    });

    it("rejects when the masterclass does not exist", async () => {
      await expect(
        service.publish({
          masterclassId: "masterclass-1",
          tutorId,
        }),
      ).rejects.toThrow("Masterclass not found.");
    });

    it("rejects when the tutor does not own the masterclass", async () => {
      seedMasterclass();

      await expect(
        service.publish({
          masterclassId: "masterclass-1",
          tutorId: "different-tutor",
        }),
      ).rejects.toThrow(
        "Tutor does not own this masterclass.",
      );
    });

    it("rejects publishing without content uploaded", async () => {
      seedMasterclass({ streamVideoId: null });

      await expect(
        service.publish({
          masterclassId: "masterclass-1",
          tutorId,
        }),
      ).rejects.toThrow(
        "Masterclass content must be uploaded before publishing.",
      );
    });

    it("rejects publishing an archived masterclass", async () => {
      seedMasterclass({
        status: MasterclassStatus.archived,
      });

      await expect(
        service.publish({
          masterclassId: "masterclass-1",
          tutorId,
        }),
      ).rejects.toThrow(
        "Masterclass cannot be published from archived.",
      );
    });
  });

  // ==================================================
  // archive
  // ==================================================

  describe("archive", () => {
    function seedPublishedMasterclass(
      overrides: Record<string, unknown> = {},
    ) {
      mockFirestore.seed("masterclasses/masterclass-1", {
        tutorId,
        title: "June Paper 1 Masterclass",
        description: "Functions and algebra.",
        subjectId: "mathematics",
        topicIds: [],
        examPaperId: null,
        priceCents: 15000,
        currency: "ZAR",
        streamVideoId: "stream-video-1",
        status: MasterclassStatus.published,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        ...overrides,
      });
    }

    it("archives a published masterclass", async () => {
      seedPublishedMasterclass();

      await service.archive({
        masterclassId: "masterclass-1",
        tutorId,
      });

      const stored = mockFirestore.get(
        "masterclasses/masterclass-1",
      );

      expect(stored?.status).toBe(MasterclassStatus.archived);
    });

    it("rejects when the masterclass does not exist", async () => {
      await expect(
        service.archive({
          masterclassId: "masterclass-1",
          tutorId,
        }),
      ).rejects.toThrow("Masterclass not found.");
    });

    it("rejects when the tutor does not own the masterclass", async () => {
      seedPublishedMasterclass();

      await expect(
        service.archive({
          masterclassId: "masterclass-1",
          tutorId: "different-tutor",
        }),
      ).rejects.toThrow(
        "Tutor does not own this masterclass.",
      );
    });
  });
});
