import { Firestore } from "firebase-admin/firestore";
import { MasterclassEnrollmentStatus } from "../enrollment/masterclass_enrollment_entity";
import { MasterclassEnrollmentService } from "../enrollment/masterclass_enrollment_service";
import { Masterclass } from "../masterclass/masterclass_entity";
import { masterclassFromFirestore } from "../masterclass/masterclass_mapper";
import { VideoAccessProvider } from "../../provider/streaming/video_access_provider";

const STREAMING_TOKEN_TTL_SECONDS = 60 * 60; // 1 hour
const DOWNLOAD_TOKEN_TTL_SECONDS = 15 * 60; // 15 minutes

export class MasterclassContentAccessService {
  constructor(
    private readonly firestore: Firestore,
    private readonly videoAccessProvider: VideoAccessProvider,
    private readonly enrollmentService: MasterclassEnrollmentService,
  ) {}

  async getStreamingAccess({
    masterclassId,
    studentId,
  }: {
    masterclassId: string;
    studentId: string;
  }): Promise<{ playbackUrl: string }> {
    const masterclass = await this.requireEnrolledAccess({
      masterclassId,
      studentId,
    });

    return this.videoAccessProvider.createStreamingToken({
      streamVideoId: masterclass.streamVideoId!,
      expiresInSeconds: STREAMING_TOKEN_TTL_SECONDS,
    });
  }

  async getDownloadAccess({
    masterclassId,
    studentId,
    enrollmentId,
  }: {
    masterclassId: string;
    studentId: string;
    enrollmentId: string;
  }): Promise<{ downloadUrl: string }> {
    const masterclass = await this.requireEnrolledAccess({
      masterclassId,
      studentId,
    });

    const result =
      await this.videoAccessProvider.createDownloadToken({
        streamVideoId: masterclass.streamVideoId!,
        expiresInSeconds: DOWNLOAD_TOKEN_TTL_SECONDS,
      });

    /*
     * This is the refund-eligibility gate and the
     * masterclass payout trigger. Marked AFTER the
     * provider has already produced a valid token, so a
     * provider failure never falsely closes the refund
     * window — the student only forfeits refund
     * eligibility once a real, usable download link has
     * been issued.
     */
    await this.enrollmentService.markDownloaded(
      enrollmentId,
    );

    return result;
  }

  private async requireEnrolledAccess({
    masterclassId,
    studentId,
  }: {
    masterclassId: string;
    studentId: string;
  }): Promise<Masterclass> {
    const enrollmentId = `${masterclassId}_${studentId}`;

    const enrollmentSnapshot = await this.firestore
      .collection("masterclassEnrollments")
      .doc(enrollmentId)
      .get();

    if (!enrollmentSnapshot.exists) {
      throw new Error(
        "You are not enrolled in this masterclass.",
      );
    }

    const enrollmentData = enrollmentSnapshot.data()!;

    if (
      enrollmentData.status !==
      MasterclassEnrollmentStatus.confirmed
    ) {
      throw new Error("Enrollment is not confirmed.");
    }

    const masterclassSnapshot = await this.firestore
      .collection("masterclasses")
      .doc(masterclassId)
      .get();

    if (!masterclassSnapshot.exists) {
      throw new Error("Masterclass not found.");
    }

    const masterclass = masterclassFromFirestore(
      masterclassSnapshot.id,
      masterclassSnapshot.data()!,
    );

    if (masterclass.streamVideoId === null) {
      throw new Error(
        "Masterclass content is not available.",
      );
    }

    return masterclass;
  }
}
