import { Timestamp } from "firebase-admin/firestore";
import { vi } from "vitest";

type DocumentData = Record<string, any>;

interface MockDocumentReference {
  id: string;
  path: string;
  update: (
    data: DocumentData
  ) => Promise<void>;
}

interface MockDocumentSnapshot {
  exists: boolean;
  id: string;
  data: () => DocumentData | undefined;
}

export function createMockFirestore() {
  const documents = new Map<string,DocumentData>();

  const resolveValue = (
    value: unknown,
    existingValue?: unknown,
  ): unknown => {
    if (
      value &&
      typeof value === "object" &&
      "_methodName" in value
    ) {
      const methodName =
        (value as { _methodName?: string })._methodName;

      if (methodName === "serverTimestamp") {
        return Timestamp.now();
      }

      if (methodName === "increment") {
        const operand =
          (value as { operand?: number }).operand ?? 0;

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
  // Transaction GET
  // --------------------------------------------------

  const transactionGet = vi.fn(
    async (
      ref: MockDocumentReference,
    ): Promise<MockDocumentSnapshot> => {
      const document = documents.get(ref.path);

      return {
        exists: document !== undefined,
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

      documents.set(ref.path, resolveData(data));
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
      const existing = documents.get(ref.path);

      if (existing === undefined) {
        throw new Error(
          `Document does not exist: ${ref.path}`,
        );
      }

      documents.set(ref.path, {
        ...existing,
        ...resolveData(data, existing),
      });
    },
  );

  // --------------------------------------------------
  // MockTransaction
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
  // collection
  // --------------------------------------------------

  const collection = vi.fn(
    (collectionName: string) => {
      return {
        doc: vi.fn(
          (
            documentId: string,
          ): MockDocumentReference => {
            const path = `${collectionName}/${documentId}`;

            return {
              id: documentId,
              path,
              update: vi.fn(
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
                    ...resolveData(data,existing),
                  });
                },
              )
            }
          },
        ),
      };
    },
  );

  // --------------------------------------------------
  // Seed
  // --------------------------------------------------

  const seed = (
    path: string,
    data: DocumentData,
  ): void => {
    documents.set(path, normalizeSeedData(data));
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
