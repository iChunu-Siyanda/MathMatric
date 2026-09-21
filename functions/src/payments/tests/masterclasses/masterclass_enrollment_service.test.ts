import { Timestamp } from "firebase-admin/firestore";
import { beforeEach, afterEach, describe, expect, it, vi } from "vitest";
import { MasterclassEnrollmentService } from "../../masterclasses/enrollment/masterclass_enrollment_service";
import { MasterclassEnrollmentStatus } from "../../masterclasses/enrollment/masterclass_enrollment_entity";
import { MasterclassStatus } from "../../masterclasses/masterclass/masterclass_entity";
import { createMockFirestore } from "../../tests/mock_firestore";

describe("MasterclassEnrollmentService", () => {
  let firestore: ReturnType<typeof createMockFirestore>;
  let service: MasterclassEnrollmentService;

  const masterclassId = "masterclass-1";
  const studentId = "student-1";
  const enrollmentId = `${masterclassId}_${studentId}`;

  function seedPublishedMasterclass(
    overrides: Record<string, unknown> = {},
  ) {
    firestore.seed(`masterclasses/${masterclassId}`, {
      tutorId: "tutor-1",
      title: "June Paper 1 Masterclass",
      description: "Functions and algebra.",
      subjectId: "mathematics",
      topicIds: ["functions", "algebra"],
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

  beforeEach(() => {
    firestore = createMockFirestore();
    service = new MasterclassEnrollmentService(
      firestore as any,
    );
  });

  afterEach(() => {
    firestore.clear();
    vi.clearAllMocks();
  });

  // ==================================================
  // createEnrollment
  // ==================================================

  describe("createEnrollment", () => {
    it("creates a pending-payment enrollment with the price locked from the masterclass", async () => {
      seedPublishedMasterclass();

      const enrollment = await service.createEnrollment({
        masterclassId,
        studentId,
      });

      expect(enrollment.id).toBe(enrollmentId);
      expect(enrollment.masterclassId).toBe(masterclassId);
      expect(enrollment.studentId).toBe(studentId);
      expect(enrollment.tutorId).toBe("tutor-1");
      expect(enrollment.priceCents).toBe(15000);
      expect(enrollment.currency).toBe("ZAR");
      expect(enrollment.status).toBe(
        MasterclassEnrollmentStatus.pendingPayment,
      );
      expect(enrollment.downloadedAt).toBeNull();
      expect(enrollment.cancelledAt).toBeNull();
      expect(enrollment.refundedAt).toBeNull();

      const stored = firestore.get(
        `masterclassEnrollments/${enrollmentId}`,
      );

      expect(stored).toEqual(
        expect.objectContaining({
          masterclassId,
          studentId,
          tutorId: "tutor-1",
          priceCents: 15000,
          currency: "ZAR",
          status: MasterclassEnrollmentStatus.pendingPayment,
          downloadedAt: null,
          cancelledAt: null,
          refundedAt: null,
        }),
      );
    });

    it("uses the deterministic enrollment ID scheme", async () => {
      seedPublishedMasterclass();

      const enrollment = await service.createEnrollment({
        masterclassId,
        studentId,
      });

      expect(enrollment.id).toBe(
        `${masterclassId}_${studentId}`,
      );
    });

    it("returns the existing enrollment instead of creating another one", async () => {
      seedPublishedMasterclass();

      const first = await service.createEnrollment({
        masterclassId,
        studentId,
      });

      const second = await service.createEnrollment({
        masterclassId,
        studentId,
      });

      expect(second.id).toBe(first.id);
      expect(second.status).toBe(first.status);
      expect(second.priceCents).toBe(first.priceCents);
    });

    it("locks the enrollment price even if the masterclass price changes later", async () => {
      seedPublishedMasterclass({ priceCents: 15000 });

      const first = await service.createEnrollment({
        masterclassId,
        studentId,
      });

      expect(first.priceCents).toBe(15000);

      /*
       * Simulate the tutor raising the price after this
       * student already enrolled.
       */
      const masterclassDoc = firestore.get(
        `masterclasses/${masterclassId}`,
      );

      firestore.seed(`masterclasses/${masterclassId}`, {
        ...masterclassDoc,
        priceCents: 20000,
      });

      const second = await service.createEnrollment({
        masterclassId,
        studentId,
      });

      expect(second.priceCents).toBe(15000);
    });

    it("rejects when the masterclass does not exist", async () => {
      await expect(
        service.createEnrollment({
          masterclassId,
          studentId,
        }),
      ).rejects.toThrow("Masterclass not found.");
    });

    it("rejects when the masterclass is not published", async () => {
      seedPublishedMasterclass({
        status: MasterclassStatus.draft,
      });

      await expect(
        service.createEnrollment({
          masterclassId,
          studentId,
        }),
      ).rejects.toThrow(
        "Masterclass is not published.",
      );
    });

    it("rejects when the masterclass is archived", async () => {
      seedPublishedMasterclass({
        status: MasterclassStatus.archived,
      });

      await expect(
        service.createEnrollment({
          masterclassId,
          studentId,
        }),
      ).rejects.toThrow(
        "Masterclass is not published.",
      );
    });

    it("rejects when the masterclass has no content uploaded yet", async () => {
      seedPublishedMasterclass({
        streamVideoId: null,
      });

      await expect(
        service.createEnrollment({
          masterclassId,
          studentId,
        }),
      ).rejects.toThrow(
        "Masterclass content is not ready yet.",
      );
    });

    it("allows two different students to enroll in the same masterclass independently", async () => {
      seedPublishedMasterclass();

      const studentTwoId = "student-2";

      const first = await service.createEnrollment({
        masterclassId,
        studentId,
      });

      const second = await service.createEnrollment({
        masterclassId,
        studentId: studentTwoId,
      });

      expect(first.id).toBe(
        `${masterclassId}_${studentId}`,
      );

      expect(second.id).toBe(
        `${masterclassId}_${studentTwoId}`,
      );

      expect(first.id).not.toBe(second.id);
    });
  });

  // ==================================================
  // markDownloaded
  // ==================================================

  describe("markDownloaded", () => {
    async function seedConfirmedEnrollment(
      overrides: Record<string, unknown> = {},
    ) {
      firestore.seed(
        `masterclassEnrollments/${enrollmentId}`,
        {
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
        },
      );
    }

    it("sets downloadedAt on a confirmed enrollment", async () => {
      await seedConfirmedEnrollment();

      await service.markDownloaded(enrollmentId);

      const stored = firestore.get(
        `masterclassEnrollments/${enrollmentId}`,
      );

      expect(stored?.downloadedAt).toEqual(
        expect.any(Timestamp),
      );
    });

    it("is idempotent when already downloaded", async () => {
      const firstDownloadedAt = Timestamp.now();

      await seedConfirmedEnrollment({
        downloadedAt: firstDownloadedAt,
      });

      await service.markDownloaded(enrollmentId);

      const stored = firestore.get(
        `masterclassEnrollments/${enrollmentId}`,
      );

      /*
       * downloadedAt must not move on a repeated
       * download — it is a refund-eligibility gate, not
       * a download counter.
       */
      expect(stored?.downloadedAt).toEqual(
        firstDownloadedAt,
      );
    });

    it("rejects when the enrollment does not exist", async () => {
      await expect(
        service.markDownloaded(enrollmentId),
      ).rejects.toThrow("Enrollment not found.");
    });

    it("rejects when the enrollment is not confirmed", async () => {
      await seedConfirmedEnrollment({
        status: MasterclassEnrollmentStatus.pendingPayment,
      });

      await expect(
        service.markDownloaded(enrollmentId),
      ).rejects.toThrow(
        "Only a confirmed enrollment can be marked downloaded.",
      );
    });

    it("rejects when the enrollment is cancelled", async () => {
      await seedConfirmedEnrollment({
        status: MasterclassEnrollmentStatus.cancelled,
      });

      await expect(
        service.markDownloaded(enrollmentId),
      ).rejects.toThrow(
        "Only a confirmed enrollment can be marked downloaded.",
      );
    });
  });
});
