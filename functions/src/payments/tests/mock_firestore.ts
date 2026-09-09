import { Timestamp } from "firebase-admin/firestore";
import { vi } from "vitest";

type DocumentData = Record<string, any>;

interface MockDocumentReference {
  id: string;
  path: string;

  update(
    data: DocumentData,
  ): Promise<void>;

  collection(
    collectionName: string,
  ): MockCollectionReference;
}

interface MockCollectionReference {
  doc(
    documentId: string,
  ): MockDocumentReference;
}

interface MockDocumentSnapshot {
  exists: boolean;
  id: string;
  data: () => DocumentData | undefined;
}

export function createMockFirestore() {
  const documents = new Map<
    string,
    DocumentData
  >();

  // --------------------------------------------------
  // Value resolution
  // --------------------------------------------------
  const resolveValue = (
    value: unknown,
    existingValue?: unknown,
  ): unknown => {
    if (
      value &&
      typeof value === "object" &&
      "methodName" in value
    ) {
      const methodName = (
        value as {
          methodName?: unknown;
        }
      ).methodName;

      if (
        methodName === "FieldValue.serverTimestamp"
      ) {
        return Timestamp.now();
      }

      if (
        methodName === "FieldValue.increment"
      ) {
        const operand =
          (value as {
            operand?: number;
          }).operand ?? 0;

        return (
          (typeof existingValue === "number"
            ? existingValue
            : 0) + operand
        );
      }
    }

    return value;
  };

  const resolveData = (
    data: DocumentData,
    existing?: DocumentData,
  ): DocumentData => {
    return Object.fromEntries(
      Object.entries(data).map(
        ([key, value]) => [
          key,
          resolveValue(
            value,
            existing?.[key],
          ),
        ],
      ),
    );
  };

  // --------------------------------------------------
  // Seed normalization
  // --------------------------------------------------

  const normalizeSeedValue = (
    value: unknown,
  ): unknown => {
    if (value instanceof Date) {
      return Timestamp.fromDate(value);
    }

    return value;
  };

  const normalizeSeedData = (
    data: DocumentData,
  ): DocumentData => {
    return Object.fromEntries(
      Object.entries(data).map(
        ([key, value]) => [
          key,
          normalizeSeedValue(value),
        ],
      ),
    );
  };

  // --------------------------------------------------
  // Document reference factory
  // --------------------------------------------------

  const createDocumentReference = (
    path: string,
    documentId: string,
  ): MockDocumentReference => {
    const update = vi.fn(
      async (
        data: DocumentData,
      ): Promise<void> => {
        const existing =
          documents.get(path);

        if (existing === undefined) {
          throw new Error(
            `Document does not exist: ${path}`,
          );
        }

        documents.set(path, {
          ...existing,
          ...resolveData(
            data,
            existing,
          ),
        });
      },
    );

    const collection = vi.fn(
      (
        collectionName: string,
      ): MockCollectionReference => {
        return createCollectionReference(
          `${path}/${collectionName}`,
        );
      },
    );

    return {
      id: documentId,
      path,
      update,
      collection,
    };
  };

  // --------------------------------------------------
  // Collection reference factory
  // --------------------------------------------------

  const createCollectionReference = (
    collectionPath: string,
  ): MockCollectionReference => {
    const doc = vi.fn(
      (
        documentId: string,
      ): MockDocumentReference => {
        const path =
          `${collectionPath}/${documentId}`;

        return createDocumentReference(
          path,
          documentId,
        );
      },
    );

    return {
      doc,
    };
  };

  // --------------------------------------------------
  // Transaction GET
  // --------------------------------------------------

  const transactionGet = vi.fn(
    async (
      ref: MockDocumentReference,
    ): Promise<MockDocumentSnapshot> => {
      const document =
        documents.get(ref.path);

      return {
        exists:
          document !== undefined,
        id: ref.id,
        data: () =>
          document === undefined
            ? undefined
            : { ...document },
      };
    },
  );

  // --------------------------------------------------
  // Transaction CREATE
  // --------------------------------------------------

  const transactionCreate = vi.fn(
    (
      ref: MockDocumentReference,
      data: DocumentData,
    ): void => {

      if (documents.has(ref.path)) {
        throw new Error(
          `Document already exists: ${ref.path}`,
        );
      }

      documents.set(
        ref.path,
        resolveData(data),
      );
    },
  );

  // --------------------------------------------------
  // Transaction UPDATE
  // --------------------------------------------------

  const transactionUpdate = vi.fn(
    (
      ref: MockDocumentReference,
      data: DocumentData,
    ): void => {
      const existing =
        documents.get(ref.path);

      if (existing === undefined) {
        throw new Error(
          `Document does not exist: ${ref.path}`,
        );
      }

      documents.set(ref.path, {
        ...existing,
        ...resolveData(
          data,
          existing,
        ),
      });
    },
  );

  // --------------------------------------------------
  // Mock Transaction
  // --------------------------------------------------

  type MockTransaction = {
    get: typeof transactionGet;
    create: typeof transactionCreate;
    update: typeof transactionUpdate;
  };

  const transaction: MockTransaction = {
    get: transactionGet,
    create: transactionCreate,
    update: transactionUpdate,
  };

  // --------------------------------------------------
  // runTransaction
  // --------------------------------------------------

  const runTransaction = vi.fn(
    async <T>(
      callback: (
        transaction: MockTransaction,
      ) => Promise<T>,
    ): Promise<T> => {
      return callback(transaction);
    },
  );

  // --------------------------------------------------
  // Root collection
  // --------------------------------------------------

  const collection = vi.fn(
    (
      collectionName: string,
    ): MockCollectionReference => {
      return createCollectionReference(
        collectionName,
      );
    },
  );

  // --------------------------------------------------
  // Seed
  // --------------------------------------------------

  const seed = (
    path: string,
    data: DocumentData,
  ): void => {
    documents.set(
      path,
      normalizeSeedData(data),
    );
  };

  // --------------------------------------------------
  // Get
  // --------------------------------------------------

  const get = (
    path: string,
  ): DocumentData | undefined => {
    const document = documents.get(path);

    if (document === undefined) {
      return undefined;
    }

    return {
      ...document,
    };
  };

  // --------------------------------------------------
  // Clear
  // --------------------------------------------------

  const clear = (): void => {
    documents.clear();

    collection.mockClear();
    runTransaction.mockClear();

    transactionGet.mockClear();
    transactionCreate.mockClear();
    transactionUpdate.mockClear();
  };

  // --------------------------------------------------
  // Return
  // --------------------------------------------------

  return {
    collection,
    runTransaction,

    transactionGet,
    transactionCreate,
    transactionUpdate,

    seed,
    get,
    clear,
  };
}
