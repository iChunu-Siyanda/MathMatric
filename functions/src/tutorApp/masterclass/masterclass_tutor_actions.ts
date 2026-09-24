import { onCall, HttpsError } from "firebase-functions/v2/https";
import { db } from "../../shared/firebase";
import { MasterclassService } from "../masterclass/masterclass_service";
import { VideoUploadProvider } from "../../cloudflare/video_upload_provider";
import { MockVideoUploadProvider } from "../../cloudflare/mock_video_upload_provider";
import { MasterclassStatus } from "../../payments/masterclasses/masterclass/masterclass_entity";

const masterclassService = new MasterclassService(db);

/*
 * Swap for CloudflareStreamProvider once real Cloudflare
 * credentials are configured.
 */
const videoUploadProvider: VideoUploadProvider =
  new MockVideoUploadProvider();

const MAX_UPLOAD_DURATION_SECONDS = 60 * 60; // 1 hour

function requireAuthenticatedTutor(
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

export const createMasterclass = onCall(async (request) => {
  const tutorId = requireAuthenticatedTutor(request.auth);

  const {
    title,
    description,
    subjectId,
    topicIds,
    examPaperId,
    priceCents,
  } = request.data ?? {};

  if (typeof title !== "string") {
    throw new HttpsError(
      "invalid-argument",
      "title is required.",
    );
  }

  if (typeof description !== "string") {
    throw new HttpsError(
      "invalid-argument",
      "description is required.",
    );
  }

  if (typeof subjectId !== "string" || !subjectId.trim()) {
    throw new HttpsError(
      "invalid-argument",
      "subjectId is required.",
    );
  }

  if (!Array.isArray(topicIds)) {
    throw new HttpsError(
      "invalid-argument",
      "topicIds must be an array.",
    );
  }

  if (
    typeof priceCents !== "number" ||
    !Number.isInteger(priceCents) ||
    priceCents <= 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      "priceCents must be a positive integer.",
    );
  }

  try {
    const masterclass = await masterclassService.createMasterclass({
      tutorId,
      title,
      description,
      subjectId,
      topicIds,
      examPaperId:
        typeof examPaperId === "string" ? examPaperId : null,
      priceCents,
    });

    return { masterclass };
  } catch (error) {
    throw new HttpsError(
      "invalid-argument",
      error instanceof Error
        ? error.message
        : "Unable to create masterclass.",
    );
  }
});


export const publishMasterclass = onCall(async (request) => {
  const tutorId = requireAuthenticatedTutor(request.auth);

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
    const masterclass = await masterclassService.publish({
      masterclassId,
      tutorId,
    });

    return { masterclass };
  } catch (error) {
    throw new HttpsError(
      "failed-precondition",
      error instanceof Error
        ? error.message
        : "Unable to publish masterclass.",
    );
  }
});

export const archiveMasterclass = onCall(async (request) => {
  const tutorId = requireAuthenticatedTutor(request.auth);

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
    await masterclassService.archive({
      masterclassId,
      tutorId,
    });

    return { archived: true };
  } catch (error) {
    throw new HttpsError(
      "failed-precondition",
      error instanceof Error
        ? error.message
        : "Unable to archive masterclass.",
    );
  }
});

export const requestMasterclassUploadUrl = onCall(
  async (request) => {
    const tutorId = requireAuthenticatedTutor(request.auth);

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

    const masterclassSnapshot = await db
      .collection("masterclasses")
      .doc(masterclassId)
      .get();

    if (!masterclassSnapshot.exists) {
      throw new HttpsError(
        "not-found",
        "Masterclass not found.",
      );
    }

    const masterclassData = masterclassSnapshot.data()!;

    if (masterclassData.tutorId !== tutorId) {
      throw new HttpsError(
        "permission-denied",
        "Tutor does not own this masterclass.",
      );
    }

    if (
      masterclassData.status !== MasterclassStatus.draft
    ) {
      throw new HttpsError(
        "failed-precondition",
        "Content can only be uploaded to a draft masterclass.",
      );
    }

    try {
      const result =
        await videoUploadProvider.createDirectUpload({
          tutorId,
          masterclassId,
          maxDurationSeconds:
            MAX_UPLOAD_DURATION_SECONDS,
        });

      return result;
    } catch (error) {
      throw new HttpsError(
        "internal",
        error instanceof Error
          ? error.message
          : "Unable to create upload URL.",
      );
    }
  },
);

export const attachMasterclassStreamVideo = onCall(
  async (request) => {
    const tutorId = requireAuthenticatedTutor(request.auth);

    const { masterclassId, streamVideoId } =
      request.data ?? {};

    if (
      typeof masterclassId !== "string" ||
      !masterclassId.trim()
    ) {
      throw new HttpsError(
        "invalid-argument",
        "masterclassId is required.",
      );
    }

    if (
      typeof streamVideoId !== "string" ||
      !streamVideoId.trim()
    ) {
      throw new HttpsError(
        "invalid-argument",
        "streamVideoId is required.",
      );
    }

    /*
     * Verify against Cloudflare's own record of this
     * video — never trust the client's claim alone.
     */
    let videoDetails;

    try {
      videoDetails =
        await videoUploadProvider.getVideoDetails(
          streamVideoId,
        );
    } catch (error) {
      throw new HttpsError(
        "not-found",
        "Video not found with the provider.",
      );
    }

    if (!videoDetails.readyToStream) {
      throw new HttpsError(
        "failed-precondition",
        "Video has not finished processing yet.",
      );
    }

    if (videoDetails.creator !== tutorId) {
      throw new HttpsError(
        "permission-denied",
        "This video was not uploaded by this tutor.",
      );
    }

    if (
      videoDetails.meta?.masterclassId !== masterclassId
    ) {
      throw new HttpsError(
        "permission-denied",
        "This video was not uploaded for this masterclass.",
      );
    }

    try {
      await masterclassService.attachStreamVideo({
        masterclassId,
        tutorId,
        streamVideoId,
      });

      return { attached: true };
    } catch (error) {
      throw new HttpsError(
        "failed-precondition",
        error instanceof Error
          ? error.message
          : "Unable to attach content.",
      );
    }
  },
);


// Standard secure pattern for direct-to-Cloudflare uploads (this is the general shape most providers use — Cloudflare Stream included, though I haven't verified their exact current API surface):

// Tutor app calls a new callable, requestMasterclassUploadUrl, passing masterclassId.
// Backend verifies the tutor owns that masterclass and it's still draft, then calls Cloudflare's API to create a one-time, short-lived direct-upload URL, tagging it with metadata (masterclassId, tutorId) that Cloudflare stores alongside the eventual video. Backend also stores a pending upload record itself (masterclassId → expected tutorId, createdAt) so it can later cross-check.
// Tutor app uploads the raw video file directly to Cloudflare using that URL — the file never passes through your backend at all (this is the point of direct upload; avoids your Cloud Function handling large binary payloads).
// Tutor app calls attachMasterclassStreamVideo with the resulting streamVideoId, same as before — but now the backend doesn't just trust it. It calls Cloudflare's API (GET /videos/{uid}) to fetch the video's actual metadata, confirms:
// the video exists and its processing status is genuinely ready
// the metadata tag it was created with actually matches masterclassId/tutorId
// Only if that verification passes does attachStreamVideo proceed.
