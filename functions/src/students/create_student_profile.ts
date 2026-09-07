import { FieldValue } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/https";

import { db } from "../shared/firebase";
import {
  isStudentType,
  StudentType,
} from "./student_types";

export interface CreateStudentProfileRequest {
  studentType: StudentType;
  displayName: string;
  grade: number;
  photoUrl: string | null;
}

export function validateCreateStudentProfileRequest(
  data: unknown,
): CreateStudentProfileRequest {
  if (!data || typeof data !== "object") {
    throw new HttpsError(
      "invalid-argument",
      "Invalid student profile request.",
    );
  }

  const request = data as Record<string, unknown>;

  // ------------------------------------------------------------
  // Student type
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // Display name
  // ------------------------------------------------------------

  if (
    typeof request.displayName !== "string" ||
    request.displayName.trim().length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Display name is required.",
    );
  }

  const displayName = request.displayName.trim();

  // ------------------------------------------------------------
  // Grade
  // ------------------------------------------------------------

  if (
    typeof request.grade !== "number" ||
    !Number.isInteger(request.grade)
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Grade must be an integer.",
    );
  }

  if (request.grade < 10 || request.grade > 12) {
    throw new HttpsError(
      "invalid-argument",
      "Grade must be between 1 and 12.",
    );
  }

  // ------------------------------------------------------------
  // Photo URL
  // ------------------------------------------------------------

  if (
    request.photoUrl !== null &&
    request.photoUrl !== undefined &&
    typeof request.photoUrl !== "string"
  ) {
    throw new HttpsError(
      "invalid-argument",
      "photoUrl must be a string or null.",
    );
  }

  const photoUrl = typeof request.photoUrl === "string"
      ? request.photoUrl.trim()
      : null;

  return {
    studentType,
    displayName,
    grade: request.grade,
    photoUrl,
  };
}

export async function handleCreateStudentProfile(
  request: {
    auth?: {
      uid: string;
    } | null;
    data: unknown;
  },
  firestore = db,
) {
  // ------------------------------------------------------------
  // Authentication
  // ------------------------------------------------------------

  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "You must be signed in to create a student profile.",
    );
  }

  const data = validateCreateStudentProfileRequest(request.data);

  const studentId = request.auth.uid;

  // ------------------------------------------------------------
  // Authoritative student account
  // ------------------------------------------------------------

  const accountRef = firestore
    .collection("studentAccounts")
    .doc(studentId);

  // ------------------------------------------------------------
  // Student profile
  // ------------------------------------------------------------

  const studentRef = firestore
    .collection("students")
    .doc(data.studentType)
    .collection("users")
    .doc(studentId);

  // ------------------------------------------------------------
  // Transaction
  // ------------------------------------------------------------

  await firestore.runTransaction(async (transaction) => {
    const accountSnapshot = await transaction.get(accountRef);

    if (accountSnapshot.exists) {
      throw new HttpsError(
        "already-exists",
        "Student account already exists.",
      );
    }

    const profileSnapshot = await transaction.get(studentRef);

    if (profileSnapshot.exists) {
      throw new HttpsError(
        "already-exists",
        "Student profile already exists.",
      );
    }

    transaction.set(accountRef, {
      studentType: data.studentType,
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });

    transaction.set(studentRef, {
      studentType: data.studentType,
      displayName: data.displayName,
      grade: data.grade,
      photoUrl: data.photoUrl,
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });
  });

  return {
    success: true,
    studentId,
    studentType: data.studentType,
  };
}

export const createStudentProfile = onCall(
  async (request) => handleCreateStudentProfile(request),
);
