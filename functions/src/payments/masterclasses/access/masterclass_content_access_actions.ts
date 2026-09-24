import { onCall, HttpsError } from "firebase-functions/v2/https";
import { db } from "../../../shared/firebase";
import { MasterclassContentAccessService } from "./masterclass_content_access_service";
import { MasterclassEnrollmentService } from "../enrollment/masterclass_enrollment_service";
import { VideoAccessProvider } from "../../provider/streaming/video_access_provider";

/*
 * Placeholder provider until the real Cloudflare Stream
 * integration is built. Mirrors MockPaymentProvider /
 * MockPayoutProvider's role: same interface, deterministic
 * fake tokens, safe to run against in every environment
 * until the real provider is wired in.
 */
class MockVideoAccessProvider implements VideoAccessProvider {
  readonly name = "mock";

  async createStreamingToken({
    streamVideoId,
  }: {
    streamVideoId: string;
    expiresInSeconds: number;
  }) {
    return {
      playbackUrl: `https://mock-stream.test/playback/${streamVideoId}`,
    };
  }

  async createDownloadToken({
    streamVideoId,
  }: {
    streamVideoId: string;
    expiresInSeconds: number;
  }) {
    return {
      downloadUrl: `https://mock-stream.test/download/${streamVideoId}`,
    };
  }
}

const videoAccessProvider: VideoAccessProvider =
  new MockVideoAccessProvider();

const enrollmentService =
  new MasterclassEnrollmentService(db);

const contentAccessService =
  new MasterclassContentAccessService(
    db,
    videoAccessProvider,
    enrollmentService,
  );

function requireAuthenticatedStudent(
  auth: { uid: string } | undefined,
): string {
  if (!auth) {
    throw new HttpsError(
      "unauthenticated",
      "Sign-in required.",
    );
  }

  return auth.uid;
}

export const getMasterclassStreamingAccess = onCall(
  async (request) => {
    const studentId = requireAuthenticatedStudent(
      request.auth,
    );

    const { masterclassId } = request.data ?? {};

    if (
      typeof masterclassId !== "string" ||
      !masterclassId.trim()
    ) {
      throw new HttpsError(
        "invalid-argument",
        "masterclassId is required.",
      );
    }

    try {
      return await contentAccessService.getStreamingAccess({
        masterclassId,
        studentId,
      });
    } catch (error) {
      throw new HttpsError(
        "failed-precondition",
        error instanceof Error
          ? error.message
          : "Unable to grant streaming access.",
      );
    }
  },
);

export const getMasterclassDownloadAccess = onCall(
  async (request) => {
    const studentId = requireAuthenticatedStudent(
      request.auth,
    );

    const { masterclassId } = request.data ?? {};

    if (
      typeof masterclassId !== "string" ||
      !masterclassId.trim()
    ) {
      throw new HttpsError(
        "invalid-argument",
        "masterclassId is required.",
      );
    }

    /*
     * enrollmentId is derived server-side from the
     * deterministic scheme, never trusted from the
     * client — masterclassId + the authenticated
     * studentId is the only input that matters.
     */
    const enrollmentId = `${masterclassId}_${studentId}`;

    try {
      return await contentAccessService.getDownloadAccess({
        masterclassId,
        studentId,
        enrollmentId,
      });
    } catch (error) {
      throw new HttpsError(
        "failed-precondition",
        error instanceof Error
          ? error.message
          : "Unable to grant download access.",
      );
    }
  },
);
