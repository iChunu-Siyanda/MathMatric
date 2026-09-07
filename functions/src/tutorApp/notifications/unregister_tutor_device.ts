import { HttpsError, onCall } from "firebase-functions/https";
import { db } from "../../shared/firebase";

export interface UnregisterTutorDeviceRequest {
  deviceId: string;
}

export function validateUnregisterTutorDeviceRequest(
  data: unknown,
): UnregisterTutorDeviceRequest {
  if (!data || typeof data !== "object") {
    throw new HttpsError(
      "invalid-argument",
      "Invalid device unregister request.",
    );
  }

  const request = data as Record<string, unknown>;

  if (
    typeof request.deviceId !== "string" ||
    request.deviceId.trim().length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Device Id is required.",
    );
  }

  return {
    deviceId: request.deviceId.trim(),
  };
}

export async function handleUnregisterTutorDevice(
  request: {
    auth?: {uid: string} | null;
    data: unknown;
  },
  firestore = db,
) {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "You must be signed in to unregister a device.",
    );
  }

  const data =
    validateUnregisterTutorDeviceRequest(request.data);

  const tutorId = request.auth.uid;

  const deviceRef = firestore
    .collection("tutors")
    .doc(tutorId)
    .collection("devices")
    .doc(data.deviceId);

  await deviceRef.delete();

  return {
    success: true,
    deviceId: data.deviceId,
  };
}

export const unregisterTutorDevice = onCall(
  async (request) => {
    return handleUnregisterTutorDevice(request);
  },
);
