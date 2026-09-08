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

      documents.set(ref.path, {
        ...data,
      });
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
        ...data,
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
                    ...data,
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
    documents.set(path, {
      ...data,
    });
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
