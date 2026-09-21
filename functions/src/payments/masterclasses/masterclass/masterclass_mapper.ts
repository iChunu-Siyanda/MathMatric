import { Timestamp } from "firebase-admin/firestore";
import { Masterclass, MasterclassStatus } from "./masterclass_entity";

export function masterclassFromFirestore(
  id: string,
  data: FirebaseFirestore.DocumentData,
): Masterclass {
  if (!(data.createdAt instanceof Timestamp)) {
    throw new Error("Masterclass createdAt is invalid.");
  }

  if (!(data.updatedAt instanceof Timestamp)) {
    throw new Error("Masterclass updatedAt is invalid.");
  }

  if (
    typeof data.priceCents !== "number" ||
    !Number.isInteger(data.priceCents) ||
    data.priceCents <= 0
  ) {
    throw new Error("Masterclass priceCents is invalid.");
  }

  if (
    !Object.values(MasterclassStatus).includes(data.status)
  ) {
    throw new Error("Masterclass status is invalid.");
  }

  if (!Array.isArray(data.topicIds)) {
    throw new Error("Masterclass topicIds is invalid.");
  }

  return {
    id,
    tutorId: data.tutorId,

    title: data.title,
    description: data.description,

    subjectId: data.subjectId,
    topicIds: data.topicIds,
    examPaperId: data.examPaperId ?? null,

    priceCents: data.priceCents,
    currency: data.currency,

    streamVideoId: data.streamVideoId ?? null,

    status: data.status,

    createdAt: data.createdAt.toDate(),
    updatedAt: data.updatedAt.toDate(),
  };
}
