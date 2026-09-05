import { HttpsError, onCall } from "firebase-functions/https";
import { db } from "../shared/firebase";

const DEFAULT_LIMIT = 20;
const MAX_LIMIT = 50;

export interface GetStudentNotificationsRequest {
  limit?: number;
  cursor?: string;
}

export function validateGetStudentNotificationsRequest(
  data: unknown,
): GetStudentNotificationsRequest {
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

export async function handleGetStudentNotifications(
  request: {
    auth?: { uid: string } | null;
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

  const data = validateGetStudentNotificationsRequest(
    request.data,
  );

  const studentId = request.auth.uid;
  const limit = data.limit ?? DEFAULT_LIMIT;

  let query = firestore
    .collection("notifications")
    .where("studentId", "==", studentId)
    .orderBy("createdAt", "desc")
    .limit(limit);

  if (data.cursor) {
    const cursorSnapshot = await firestore
      .collection("notifications")
      .doc(data.cursor)
      .get();

    if (!cursorSnapshot.exists) {
      throw new HttpsError(
        "invalid-argument",
        "Invalid notification cursor.",
      );
    }

    if (
      cursorSnapshot.data()?.studentId !== studentId
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
    nextCursor: snapshot.docs.length === limit
        ? snapshot.docs[snapshot.docs.length - 1].id
        : null,
  };
}

export const getStudentNotifications = onCall(
  async (request) => {
    return handleGetStudentNotifications(request);
  },
);
