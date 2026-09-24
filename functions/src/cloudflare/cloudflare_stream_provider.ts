import {
  VideoUploadProvider,
  CreateDirectUploadResult,
  StreamVideoDetails,
} from "./video_upload_provider";

export class CloudflareStreamProvider
  implements VideoUploadProvider
{
  readonly name = "cloudflare-stream";

  constructor(
    private readonly accountId: string,
    private readonly apiToken: string,
  ) {}

  async createDirectUpload({
    tutorId,
    masterclassId,
    maxDurationSeconds,
  }: {
    tutorId: string;
    masterclassId: string;
    maxDurationSeconds: number;
  }): Promise<CreateDirectUploadResult> {
    const response = await fetch(
      `https://api.cloudflare.com/client/v4/accounts/${this.accountId}/stream/direct_upload`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${this.apiToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          maxDurationSeconds,
          /*
           * Stored server-side by Cloudflare against this
           * video UID. This is the tag re-checked at
           * attach time — only this backend can set it,
           * since only this backend can call this endpoint.
           */
          creator: tutorId,
          meta: { masterclassId },
          requireSignedURLs: true,
        }),
      },
    );

    const data = await response.json();

    if (!response.ok || !data.success) {
      throw new Error(
        "Failed to create Cloudflare Stream upload URL.",
      );
    }

    return {
      uploadUrl: data.result.uploadURL,
      streamVideoId: data.result.uid,
    };
  }

  async getVideoDetails(
    streamVideoId: string,
  ): Promise<StreamVideoDetails> {
    const response = await fetch(
      `https://api.cloudflare.com/client/v4/accounts/${this.accountId}/stream/${streamVideoId}`,
      {
        headers: {
          Authorization: `Bearer ${this.apiToken}`,
        },
      },
    );

    const data = await response.json();

    if (!response.ok || !data.success) {
      throw new Error(
        "Failed to fetch Cloudflare Stream video details.",
      );
    }

    return {
      streamVideoId,
      readyToStream: data.result.readyToStream === true,
      creator: data.result.creator ?? null,
      meta: data.result.meta ?? {},
    };
  }
}


// accountId/apiToken should come from Firebase Functions config/secrets (functions.config() 
// or the newer defineSecret, depending on your firebase-functions version) which is not hardcoded.