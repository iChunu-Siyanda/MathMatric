export const MasterclassStatus = {
  draft: "draft",
  published: "published",
  archived: "archived",
} as const;

export type MasterclassStatus =
  typeof MasterclassStatus[keyof typeof MasterclassStatus];

export interface Masterclass {
  id: string;
  tutorId: string;

  title: string;
  description: string;

  subjectId: string;
  topicIds: string[];
  examPaperId: string | null;

  priceCents: number;
  currency: "ZAR";

  /*
   * Cloudflare Stream video UID for streaming playback.
   * Null until the tutor has finished uploading/processing.
   */
  streamVideoId: string | null;

  status: MasterclassStatus;

  createdAt: Date;
  updatedAt: Date;
}

// Storage: masterclasses/{masterclassId}
