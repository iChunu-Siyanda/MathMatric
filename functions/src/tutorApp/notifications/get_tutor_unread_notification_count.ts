import {HttpsError,onCall,} from "firebase-functions/https";
import {db} from "../../shared/firebase";

export async function handleGetTutorUnreadNotificationCount(
  request: {
    auth?: {uid: string} | null;
  },
  firestore = db,
) {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "You must be signed in to view notification count.",
    );
  }

  const snapshot = await firestore
    .collection("tutorNotifications")
    .where("tutorId", "==", request.auth.uid)
    .where("readAt", "==", null)
    .count()
    .get();

  return {
    count: snapshot.data().count,
  };
}

export const getTutorUnreadNotificationCount = onCall(
  async (request) => {
    return handleGetTutorUnreadNotificationCount(
      request,
    );
  },
);
