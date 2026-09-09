import {
  DocumentData,
} from "firebase-admin/firestore";

export interface FirestoreDocumentReference {
  id: string;
  path: string;

  update(
    data: DocumentData,
  ): Promise<void>;

  collection(
    collectionName: string,
  ): FirestoreCollectionReference;
}

export interface FirestoreCollectionReference {
  doc(
    documentId: string,
  ): FirestoreDocumentReference;
}

export interface FirestoreDocumentSnapshot {
  exists: boolean;
  id: string;

  data():
    | DocumentData
    | undefined;
}

export interface FirestoreTransaction {
  get(
    ref: FirestoreDocumentReference,
  ): Promise<FirestoreDocumentSnapshot>;

  create(
    ref: FirestoreDocumentReference,
    data: DocumentData,
  ): void;

  update(
    ref: FirestoreDocumentReference,
    data: DocumentData,
  ): void;
}

export interface FirestoreDatabase {
  collection(
    collectionName: string,
  ): FirestoreCollectionReference;

  runTransaction<T>(
    callback: (
      transaction: FirestoreTransaction,
    ) => Promise<T>,
  ): Promise<T>;
}
