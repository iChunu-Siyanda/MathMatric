import { HttpsError } from "firebase-functions/https";
import { db } from "../shared/firebase";
import {isStudentType,StudentType,} from "./student_types";

export interface StudentAccount {
  studentId: string;
  studentType: StudentType;
}

export async function getStudentAccount(
  studentId: string,
  firestore = db,
): Promise<StudentAccount> {
  const accountRef = firestore
    .collection("studentAccounts")
    .doc(studentId);

  const snapshot = await accountRef.get();

  if (!snapshot.exists || !snapshot.data()) {
    throw new HttpsError(
      "not-found",
      "Student account not found.",
    );
  }

  const data = snapshot.data()!;

  if (
    typeof data.studentType !== "string" ||
    !isStudentType(data.studentType)
  ) {
    throw new HttpsError(
      "failed-precondition",
      "Student account has an invalid student type.",
    );
  }

  return {
    studentId,
    studentType: data.studentType,
  };
}
