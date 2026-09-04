import { HttpsError } from "firebase-functions/https";
import { FieldValue } from "firebase-admin/firestore";
import { onCall } from "firebase-functions/https";
import { db } from "../shared/firebase";


export interface RegisterStudentDeviceRequest {
  deviceId: string;
  token: string;
  platform: "android" | "ios";
}

export function validateRegisterStudentDeviceRequest(
  data: unknown,
): RegisterStudentDeviceRequest {
  if (!data || typeof data !== "object") {
    throw new HttpsError(
      "invalid-argument",
      "Invalid device registration request.",
    );
  }

  const request = data as Record<string, unknown>;
  if (
    typeof request.deviceId !== "string" || request.deviceId.trim().length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Device Id is required.",
    );
  }

  if (
    typeof request.token !== "string" || request.token.trim().length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      "FCM token is required.",
    );
  }

  if (
    request.platform !== "android" && request.platform !== "ios"
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Platform must be android or ios.",
    );
  }

  return {
    deviceId: request.deviceId.trim(),
    token: request.token.trim(),
    platform: request.platform,
  };
}

export async function handleRegisterStudentDevice(
  request:{
    auth?: {uid:string}|null;
    data: unknown;
  },
  firestore = db,
) {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "You must be signed in to register a device.",
    );
  }

  const data = validateRegisterStudentDeviceRequest(request.data);
  const studentId = request.auth.uid;

  const deviceRef = firestore
    .collection("students")
    .doc(studentId)
    .collection("devices")
    .doc(data.deviceId);

  await firestore.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(deviceRef);

    if (snapshot.exists) {
      transaction.update(deviceRef, {
        token: data.token,
        platform: data.platform,
        updatedAt: FieldValue.serverTimestamp(),
      });
    } else {
      transaction.set(deviceRef, {
        token: data.token,
        platform: data.platform,
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });
    }
  });  

  return {
    success: true,
    deviceId: deviceRef.id,
  };
}

export const registerStudentDevice = onCall(
  async (request) => {
    return handleRegisterStudentDevice(request);
  },
);
