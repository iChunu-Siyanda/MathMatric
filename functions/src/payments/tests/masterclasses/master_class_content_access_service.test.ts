import { Timestamp, Firestore } from "firebase-admin/firestore";
import { beforeEach, describe, expect, it, vi } from "vitest";
import { createMockFirestore } from "../mock_firestore";
import { MasterclassEnrollmentService } from "../../masterclasses/enrollment/masterclass_enrollment_service";
import { MasterclassEnrollmentStatus } from "../../masterclasses/enrollment/masterclass_enrollment_entity";
import { MasterclassStatus } from "../../masterclasses/masterclass/masterclass_entity";
import { VideoAccessProvider } from "../../provider/streaming/video_access_provider";
import { MasterclassContentAccessService } from "../../masterclasses/access/masterclass_content_access_service";


describe("MasterclassContentAccessService", () => {
  let firestore: Firestore;
  let mockFirestore: ReturnType<typeof createMockFirestore>;
  let videoAccessProvider: VideoAccessProvider;
  let enrollmentService: MasterclassEnrollmentService;
  let service: MasterclassContentAccessService;

  const masterclassId = "masterclass-1";
  const studentId = "student-1";
  const enrollmentId = `${masterclassId}_${studentId}`;

  beforeEach(() => {
    mockFirestore = createMockFirestore();
    firestore = mockFirestore as unknown as Firestore;

    videoAccessProvider = {
      name: "mock",
      createStreamingToken: vi.fn().mockResolvedValue({
        playbackUrl: "https://stream.mock/playback-token",
      }),
      createDownloadToken: vi.fn().mockResolvedValue({
        downloadUrl: "https://stream.mock/download-token",
      }),
    };

    enrollmentService = new MasterclassEnrollmentService(firestore);

    service = new MasterclassContentAccessService(
      firestore,
      videoAccessProvider,
      enrollmentService,
    );
  });

  function seedConfirmedEnrollment(
    overrides: Record<string, unknown> = {},
  ) {
    mockFirestore.seed(`masterclassEnrollments/${enrollmentId}`, {
      masterclassId,
      studentId,
      tutorId: "tutor-1",
      priceCents: 15000,
      currency: "ZAR",
      status: MasterclassEnrollmentStatus.confirmed,
      downloadedAt: null,
      enrolledAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      cancelledAt: null,
      refundedAt: null,
      ...overrides,
    });
  }

  function seedPublishedMasterclass(
    overrides: Record<string, unknown> = {},
  ) {
    mockFirestore.seed(`masterclasses/${masterclassId}`, {
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
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      ...overrides,
    });
  }

  // ==================================================
  // getStreamingAccess
  // ==================================================

  describe("getStreamingAccess", () => {
    it("returns a playback URL for an enrolled student", async () => {
      seedConfirmedEnrollment();
      seedPublishedMasterclass();

      const result = await service.getStreamingAccess({
        masterclassId,
        studentId,
      });

      expect(result.playbackUrl).toBe(
        "https://stream.mock/playback-token",
      );

      expect(
        videoAccessProvider.createStreamingToken,
      ).toHaveBeenCalledWith({
        streamVideoId: "stream-video-1",
        expiresInSeconds: 60 * 60,
      });
    });

    it("does not mark the enrollment as downloaded", async () => {
      seedConfirmedEnrollment();
      seedPublishedMasterclass();

      await service.getStreamingAccess({
        masterclassId,
        studentId,
      });

      const stored = mockFirestore.get(
        `masterclassEnrollments/${enrollmentId}`,
      );

      expect(stored?.downloadedAt).toBeNull();
    });

    it("rejects when the student is not enrolled", async () => {
      seedPublishedMasterclass();

      await expect(
        service.getStreamingAccess({
          masterclassId,
          studentId,
        }),
      ).rejects.toThrow(
        "You are not enrolled in this masterclass.",
      );

      expect(
        videoAccessProvider.createStreamingToken,
      ).not.toHaveBeenCalled();
    });

    it("rejects when the enrollment is still pending payment", async () => {
      seedConfirmedEnrollment({
        status: MasterclassEnrollmentStatus.pendingPayment,
      });

      seedPublishedMasterclass();

      await expect(
        service.getStreamingAccess({
          masterclassId,
          studentId,
        }),
      ).rejects.toThrow("Enrollment is not confirmed.");
    });

    it("rejects when the enrollment was cancelled", async () => {
      seedConfirmedEnrollment({
        status: MasterclassEnrollmentStatus.cancelled,
      });

      seedPublishedMasterclass();

      await expect(
        service.getStreamingAccess({
          masterclassId,
          studentId,
        }),
      ).rejects.toThrow("Enrollment is not confirmed.");
    });

    it("rejects when the enrollment was refunded", async () => {
      seedConfirmedEnrollment({
        status: MasterclassEnrollmentStatus.refunded,
      });

      seedPublishedMasterclass();

      await expect(
        service.getStreamingAccess({
          masterclassId,
          studentId,
        }),
      ).rejects.toThrow("Enrollment is not confirmed.");
    });

    it("rejects when the masterclass no longer exists", async () => {
      seedConfirmedEnrollment();

      await expect(
        service.getStreamingAccess({
          masterclassId,
          studentId,
        }),
      ).rejects.toThrow("Masterclass not found.");
    });

    it("rejects when the masterclass has no content attached", async () => {
      seedConfirmedEnrollment();
      seedPublishedMasterclass({ streamVideoId: null });

      await expect(
        service.getStreamingAccess({
          masterclassId,
          studentId,
        }),
      ).rejects.toThrow("Masterclass content is not available.");
    });
  });

  // ==================================================
  // getDownloadAccess
  // ==================================================

  describe("getDownloadAccess", () => {
    it("returns a download URL for an enrolled student", async () => {
      seedConfirmedEnrollment();
      seedPublishedMasterclass();

      const result = await service.getDownloadAccess({
        masterclassId,
        studentId,
        enrollmentId,
      });

      expect(result.downloadUrl).toBe(
        "https://stream.mock/download-token",
      );

      expect(
        videoAccessProvider.createDownloadToken,
      ).toHaveBeenCalledWith({
        streamVideoId: "stream-video-1",
        expiresInSeconds: 15 * 60,
      });
    });

    it("marks the enrollment as downloaded after a successful token issue", async () => {
      seedConfirmedEnrollment();
      seedPublishedMasterclass();

      await service.getDownloadAccess({
        masterclassId,
        studentId,
        enrollmentId,
      });

      const stored = mockFirestore.get(
        `masterclassEnrollments/${enrollmentId}`,
      );

      expect(stored?.downloadedAt).toEqual(
        expect.any(Timestamp),
      );
    });

    it("does not mark the enrollment as downloaded when the provider call fails", async () => {
      seedConfirmedEnrollment();
      seedPublishedMasterclass();

      vi.mocked(
        videoAccessProvider.createDownloadToken,
      ).mockRejectedValueOnce(
        new Error("Video provider unavailable."),
      );

      await expect(
        service.getDownloadAccess({
          masterclassId,
          studentId,
          enrollmentId,
        }),
      ).rejects.toThrow("Video provider unavailable.");

      const stored = mockFirestore.get(
        `masterclassEnrollments/${enrollmentId}`,
      );

      expect(stored?.downloadedAt).toBeNull();
    });

    it("is idempotent across repeated downloads (does not move downloadedAt)", async () => {
      seedConfirmedEnrollment();
      seedPublishedMasterclass();

      await service.getDownloadAccess({
        masterclassId,
        studentId,
        enrollmentId,
      });

      const firstDownloadedAt = mockFirestore.get(
        `masterclassEnrollments/${enrollmentId}`,
      )?.downloadedAt;

      await service.getDownloadAccess({
        masterclassId,
        studentId,
        enrollmentId,
      });

      const secondDownloadedAt = mockFirestore.get(
        `masterclassEnrollments/${enrollmentId}`,
      )?.downloadedAt;

      expect(secondDownloadedAt).toEqual(firstDownloadedAt);

      expect(
        videoAccessProvider.createDownloadToken,
      ).toHaveBeenCalledTimes(2);
    });

    it("rejects when the student is not enrolled", async () => {
      seedPublishedMasterclass();

      await expect(
        service.getDownloadAccess({
          masterclassId,
          studentId,
          enrollmentId,
        }),
      ).rejects.toThrow(
        "You are not enrolled in this masterclass.",
      );

      expect(
        videoAccessProvider.createDownloadToken,
      ).not.toHaveBeenCalled();
    });

    it("rejects when the enrollment is not confirmed", async () => {
      seedConfirmedEnrollment({
        status: MasterclassEnrollmentStatus.pendingPayment,
      });

      seedPublishedMasterclass();

      await expect(
        service.getDownloadAccess({
          masterclassId,
          studentId,
          enrollmentId,
        }),
      ).rejects.toThrow("Enrollment is not confirmed.");

      expect(
        videoAccessProvider.createDownloadToken,
      ).not.toHaveBeenCalled();
    });

    it("rejects when the masterclass has no content attached", async () => {
      seedConfirmedEnrollment();
      seedPublishedMasterclass({ streamVideoId: null });

      await expect(
        service.getDownloadAccess({
          masterclassId,
          studentId,
          enrollmentId,
        }),
      ).rejects.toThrow("Masterclass content is not available.");
    });
  });
});
