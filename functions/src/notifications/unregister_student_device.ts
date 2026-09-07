import { HttpsError, onCall } from "firebase-functions/https";
import { db } from "../shared/firebase";

const validStudentTypes = [
  "pure_maths_student",
  "maths_literacy_student",
] as const;

type StudentType = typeof validStudentTypes[number];

function isStudentType(value: string): value is StudentType {
  return validStudentTypes.includes(value as StudentType);
}

export interface UnregisterStudentDeviceRequest {
  studentType: StudentType,
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
    typeof request.studentType !== "string" ||
    request.studentType.trim().length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Student type is required.",
    );
  }

  const studentType = request.studentType.trim();

  if (!isStudentType(studentType)) {
    throw new HttpsError(
      "invalid-argument",
      "Invalid student type.",
    );
  }

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
    studentType,
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
    .doc(data.studentType)
    .collection("users")
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