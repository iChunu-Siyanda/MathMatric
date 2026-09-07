import {HttpsError, onCall} from "firebase-functions/https";
import {db} from "../../shared/firebase";

const DEFAULT_LIMIT = 20;
const MAX_LIMIT = 50;

export interface GetTutorNotificationsRequest {
  limit?: number;
  cursor?: string;
}

export function validateGetTutorNotificationsRequest(
  data: unknown,
): GetTutorNotificationsRequest {
  if (!data || typeof data !== "object") {
    throw new HttpsError(
      "invalid-argument",
      "Invalid notification request.",
    );
  }

  const request = data as Record<string, unknown>;

  if (request.limit !== undefined) {
    if (
      typeof request.limit !== "number" ||
      !Number.isInteger(request.limit) ||
      request.limit < 1 ||
      request.limit > MAX_LIMIT
    ) {
      throw new HttpsError(
        "invalid-argument",
        `limit must be an integer between 1 and ${MAX_LIMIT}.`,
      );
    }
  }

  if (request.cursor !== undefined) {
    if (
      typeof request.cursor !== "string" ||
      request.cursor.trim().length === 0
    ) {
      throw new HttpsError(
        "invalid-argument",
        "cursor must be a non-empty string.",
      );
    }
  }

  return {
    limit: request.limit as number | undefined,
    cursor: request.cursor as string | undefined,
  };
}

export async function handleGetTutorNotifications(
  request: {
    auth?: {uid: string} | null;
    data: unknown;
  },
  firestore = db,
) {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "You must be signed in to view notifications.",
    );
  }

  const data =
    validateGetTutorNotificationsRequest(request.data);

  const tutorId = request.auth.uid;
  const limit = data.limit ?? DEFAULT_LIMIT;

  let query = firestore
    .collection("tutorNotifications")
    .where("tutorId", "==", tutorId)
    .orderBy("createdAt", "desc")
    .limit(limit);

  if (data.cursor) {
    const cursorSnapshot = await firestore
      .collection("tutorNotifications")
      .doc(data.cursor)
      .get();

    if (!cursorSnapshot.exists) {
      throw new HttpsError(
        "invalid-argument",
        "Invalid notification cursor.",
      );
    }

    if (
      cursorSnapshot.data()?.tutorId !== tutorId
    ) {
      throw new HttpsError(
        "permission-denied",
        "Invalid notification cursor.",
      );
    }

    query = query.startAfter(cursorSnapshot);
  }

  const snapshot = await query.get();

  const notifications = snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));

  return {
    notifications,
    nextCursor:
      snapshot.docs.length === limit
        ? snapshot.docs[snapshot.docs.length - 1].id
        : null,
  };
}

export const getTutorNotifications = onCall(
  async (request) => {
    return handleGetTutorNotifications(request);
  },
);
