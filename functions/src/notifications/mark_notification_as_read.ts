import {FieldValue,} from "firebase-admin/firestore";
import {HttpsError,onCall,} from "firebase-functions/https";
import { db } from "../shared/firebase";

export interface MarkNotificationAsReadRequest {
  notificationId: string;
}

export function validateMarkNotificationAsReadRequest(
  data: unknown,
): MarkNotificationAsReadRequest {
  if (!data || typeof data !== "object") {
    throw new HttpsError(
      "invalid-argument",
      "Invalid notification request.",
    );
  }

  const request = data as Record<string, unknown>;

  if (
    typeof request.notificationId !== "string" ||
    request.notificationId.trim().length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      "notificationId is required.",
    );
  }

  return {
    notificationId: request.notificationId.trim(),
  };
}

export async function handleMarkNotificationAsRead(
  request: {
    auth?: { uid: string } | null;
    data: unknown;
  },
  firestore = db,
) {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "You must be signed in to update notifications.",
    );
  }

  const data = validateMarkNotificationAsReadRequest(request.data);

  const notificationRef = firestore
    .collection("notifications")
    .doc(data.notificationId);

  const snapshot = await notificationRef.get();

  if (!snapshot.exists || !snapshot.data()) {
    throw new HttpsError(
      "not-found",
      "Notification not found.",
    );
  }

  const notification = snapshot.data()!;

  if (notification.studentId !== request.auth.uid) {
    throw new HttpsError(
      "permission-denied",
      "You cannot update this notification.",
    );
  }

  if (notification.readAt !== null) {
    return {
      success: true,
      notificationId: data.notificationId,
    };
  }

  await notificationRef.update({
    readAt: FieldValue.serverTimestamp(),
  });

  return {
    success: true,
    notificationId: data.notificationId,
  };
}

export const markNotificationAsRead = onCall(
  async (request) => {
    return handleMarkNotificationAsRead(request);
  },
);
