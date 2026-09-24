import { FieldValue, Firestore } from "firebase-admin/firestore";
import { Masterclass, MasterclassStatus } from "../../payments/masterclasses/masterclass/masterclass_entity";
import { masterclassFromFirestore } from "../../payments/masterclasses/masterclass/masterclass_mapper";

export class MasterclassService {
  constructor(
    private readonly firestore: Firestore,
  ) {}

  async createMasterclass({
    tutorId,
    title,
    description,
    subjectId,
    topicIds,
    examPaperId,
    priceCents,
  }: {
    tutorId: string;
    title: string;
    description: string;
    subjectId: string;
    topicIds: string[];
    examPaperId: string | null;
    priceCents: number;
  }): Promise<Masterclass> {
    if (!title.trim()) {
      throw new Error("Title is required.");
    }

    if (!description.trim()) {
      throw new Error("Description is required.");
    }

    if (
      !Number.isInteger(priceCents) ||
      priceCents <= 0
    ) {
      throw new Error(
        "priceCents must be a positive integer.",
      );
    }

    const masterclassRef = this.firestore
      .collection("masterclasses")
      .doc();

    const now = new Date();

    const masterclass: Masterclass = {
      id: masterclassRef.id,
      tutorId,

      title: title.trim(),
      description: description.trim(),

      subjectId,
      topicIds,
      examPaperId,

      priceCents,
      currency: "ZAR",

      streamVideoId: null,

      status: MasterclassStatus.draft,

      createdAt: now,
      updatedAt: now,
    };

    await this.firestore.runTransaction(
      async (transaction) => {
        transaction.create(masterclassRef, {
          tutorId,
          title: masterclass.title,
          description: masterclass.description,
          subjectId,
          topicIds,
          examPaperId,
          priceCents,
          currency: "ZAR",
          streamVideoId: null,
          status: MasterclassStatus.draft,
          createdAt: FieldValue.serverTimestamp(),
          updatedAt: FieldValue.serverTimestamp(),
        });
      },
    );

    return masterclass;
  }

  /*
   * Called once the tutor's video upload has finished
   * processing on Cloudflare Stream. This service does not
   * talk to Cloudflare directly — the caller (an upload
   * completion webhook or client callback, outside this
   * financial subsystem) supplies the resulting video UID.
   */
  async attachStreamVideo({
    masterclassId,
    tutorId,
    streamVideoId,
  }: {
    masterclassId: string;
    tutorId: string;
    streamVideoId: string;
  }): Promise<void> {
    if (!streamVideoId.trim()) {
      throw new Error(
        "streamVideoId cannot be empty.",
      );
    }

    const masterclassRef = this.firestore
      .collection("masterclasses")
      .doc(masterclassId);

    await this.firestore.runTransaction(
      async (transaction) => {
        const snapshot =
          await transaction.get(masterclassRef);

        if (!snapshot.exists) {
          throw new Error(
            "Masterclass not found.",
          );
        }

        const data = snapshot.data()!;

        if (data.tutorId !== tutorId) {
          throw new Error(
            "Tutor does not own this masterclass.",
          );
        }

        if (
          data.status !== MasterclassStatus.draft
        ) {
          throw new Error(
            "Content can only be attached to a draft masterclass.",
          );
        }

        transaction.update(masterclassRef, {
          streamVideoId,
          updatedAt: FieldValue.serverTimestamp(),
        });
      },
    );
  }

  async publish({
    masterclassId,
    tutorId,
  }: {
    masterclassId: string;
    tutorId: string;
  }): Promise<Masterclass> {
    const masterclassRef = this.firestore
      .collection("masterclasses")
      .doc(masterclassId);

    return this.firestore.runTransaction(
      async (transaction) => {
        const snapshot =
          await transaction.get(masterclassRef);

        if (!snapshot.exists) {
          throw new Error(
            "Masterclass not found.",
          );
        }

        const data = snapshot.data()!;

        const masterclass =
          masterclassFromFirestore(
            snapshot.id,
            data,
          );

        if (masterclass.tutorId !== tutorId) {
          throw new Error(
            "Tutor does not own this masterclass.",
          );
        }

        if (
          masterclass.status ===
          MasterclassStatus.published
        ) {
          return masterclass;
        }

        if (
          masterclass.status !==
          MasterclassStatus.draft
        ) {
          throw new Error(
            `Masterclass cannot be published from ${masterclass.status}.`,
          );
        }

        if (masterclass.streamVideoId === null) {
          throw new Error(
            "Masterclass content must be uploaded before publishing.",
          );
        }

        transaction.update(masterclassRef, {
          status: MasterclassStatus.published,
          updatedAt: FieldValue.serverTimestamp(),
        });

        return {
          ...masterclass,
          status: MasterclassStatus.published,
        };
      },
    );
  }

  async archive({
    masterclassId,
    tutorId,
  }: {
    masterclassId: string;
    tutorId: string;
  }): Promise<void> {
    const masterclassRef = this.firestore
      .collection("masterclasses")
      .doc(masterclassId);

    await this.firestore.runTransaction(
      async (transaction) => {
        const snapshot =
          await transaction.get(masterclassRef);

        if (!snapshot.exists) {
          throw new Error(
            "Masterclass not found.",
          );
        }

        const data = snapshot.data()!;

        if (data.tutorId !== tutorId) {
          throw new Error(
            "Tutor does not own this masterclass.",
          );
        }

        /*
         * Archiving hides a masterclass from new purchase
         * (existing enrollments are untouched — a student
         * who already bought it keeps access). This does
         * NOT delete content, since already-enrolled
         * students must retain playback/download access.
         */
        transaction.update(masterclassRef, {
          status: MasterclassStatus.archived,
          updatedAt: FieldValue.serverTimestamp(),
        });
      },
    );
  }
}
