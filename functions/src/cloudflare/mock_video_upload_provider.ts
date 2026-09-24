import {
  VideoUploadProvider,
  CreateDirectUploadResult,
  StreamVideoDetails,
} from "./video_upload_provider";

export class MockVideoUploadProvider implements VideoUploadProvider
{
  readonly name = "mock";

  private videos = new Map<
    string,
    {
      tutorId: string;
      masterclassId: string;
      readyToStream: boolean;
    }
  >();

  async createDirectUpload({
    tutorId,
    masterclassId,
  }: {
    tutorId: string;
    masterclassId: string;
    maxDurationSeconds: number;
  }): Promise<CreateDirectUploadResult> {
    const streamVideoId = `mock-video-${masterclassId}`;

    this.videos.set(streamVideoId, {
      tutorId,
      masterclassId,
      readyToStream: true,
    });

    return {
      uploadUrl: `https://mock-upload.test/${streamVideoId}`,
      streamVideoId,
    };
  }

  async getVideoDetails(
    streamVideoId: string,
  ): Promise<StreamVideoDetails> {
    const video = this.videos.get(streamVideoId);

    if (!video) {
      throw new Error("Video not found.");
    }

    return {
      streamVideoId,
      readyToStream: video.readyToStream,
      creator: video.tutorId,
      meta: { masterclassId: video.masterclassId },
    };
  }

  /*
   * Test helper: simulate a video that hasn't finished
   * processing yet.
   */
  setReadyToStream(
    streamVideoId: string,
    ready: boolean,
  ): void {
    const video = this.videos.get(streamVideoId);

    if (video) {
      video.readyToStream = ready;
    }
  }
}
