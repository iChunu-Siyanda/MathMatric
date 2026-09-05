import { HttpsError, onCall } from "firebase-functions/https";
import { db } from "../shared/firebase";

export interface UnregisterStudentDeviceRequest {
  deviceId: string;
}

export function validateUnregisterStudentDeviceRequest(
  data: unknown,
): UnregisterStudentDeviceRequest {
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

export async function handleUnregisterStudentDevice(
  request: {
    auth?: { uid: string } | null;
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

  const data = validateUnregisterStudentDeviceRequest(request.data);

  const deviceRef = firestore
    .collection("students")
    .doc(request.auth.uid)
    .collection("devices")
    .doc(data.deviceId);

  await deviceRef.delete();

  return {
    success: true,
    deviceId: data.deviceId,
  };
}

export const unregisterStudentDevice = onCall(
  async (request) => {
    return handleUnregisterStudentDevice(request);
  },
);


// Tests

// For unregister_student_device.test.ts, cover:

// unauthenticated → rejected
// missing deviceId → rejected
// empty deviceId → rejected
// trims device ID
// authenticated UID used in Firestore path
// correct device document deleted
// returns success
// Firestore deletion errors propagate

// One particularly important assertion:

// expect(
//   firestore.collection,
// ).toHaveBeenCalledWith("students");

// and then verify the resulting path is:

// students/student-123/devices/device-456

// Never:

// students/suppliedStudentId/devices/...

// because there is no supplied student ID.