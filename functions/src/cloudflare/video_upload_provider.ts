// ==== Cloudflare POST ============
// POST /accounts/{account_id}/stream/direct_upload 
// creates a one-time upload URL, accepts a creator field (free-text identifier) 
// and a meta key-value object, both are stored server-side by Cloudflare and returned later when you fetch the video.

// ==== Cloudflare GET =============
// GET /accounts/{account_id}/stream/{identifier} returns the video's actual readyToStream boolean, creator, and meta, this is the verification call.

// poll-and-verify approach instead of webhooks. Webhooks as future upgrade.

export interface CreateDirectUploadResult {
  uploadUrl: string;
  streamVideoId: string;
}

export interface StreamVideoDetails {
  streamVideoId: string;
  readyToStream: boolean;
  creator: string | null;
  meta: Record<string, unknown>;
}

export interface VideoUploadProvider {
  readonly name: string;

  createDirectUpload(params: {
    tutorId: string;
    masterclassId: string;
    maxDurationSeconds: number;
  }): Promise<CreateDirectUploadResult>;

  getVideoDetails(
    streamVideoId: string,
  ): Promise<StreamVideoDetails>;
}

// Tag the video with tutorId (as creator) and masterclassId (in meta) at upload-URL-creation time, 
// then re-fetch and cross-check both at attach time. Since only the backend can create the upload URL, 
// only the backend could have set that tagging and a client can no longer just invent a UID and have it accepted.