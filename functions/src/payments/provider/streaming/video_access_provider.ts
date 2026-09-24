/*
 * Abstraction over the video provider's signed-token
 * generation, so this service (and its callers) never
 * depend on Cloudflare specifically. A real implementation
 * wraps Cloudflare Stream's signed URL API; tests use a
 * mock, same pattern as PaymentProvider/PayoutProvider.
 */
export interface VideoAccessProvider {
  readonly name: string;

  createStreamingToken(params: {
    streamVideoId: string;
    expiresInSeconds: number;
  }): Promise<{ playbackUrl: string }>;

  createDownloadToken(params: {
    streamVideoId: string;
    expiresInSeconds: number;
  }): Promise<{ downloadUrl: string }>;
}
