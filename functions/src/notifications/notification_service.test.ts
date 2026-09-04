import {Timestamp } from "firebase-admin/firestore";
import { describe, expect, it, vi } from "vitest";
import {NotificationService,} from "./notification_service";
import {NotificationType,} from "./notification_types";

describe("NotificationService", () => {
  it("creates a notification with the correct data", async () => {
    const set = vi.fn().mockResolvedValue(undefined);
    const doc = vi.fn().mockReturnValue({
      id: "notification-123",
      set,});
    const collection = vi.fn().mockReturnValue({doc,});

    const firestore = {collection,} as any;
    const service = new NotificationService(firestore);

    const notificationId = await service.create({
      studentId: "student-1",
      type: NotificationType.quizAvailable,
      title: "New quiz available",
      body: "A new quiz is available for Quadratic Functions.",
      target: {
        feature: "quiz",
        resourceId: "quiz-1",
        secondaryResourceId: "topic-1",
      },
    });

    expect(notificationId).toBeDefined();
    expect(notificationId).toBeTypeOf("string");
    expect(collection).toHaveBeenCalledWith("notifications",);
    expect(doc).toHaveBeenCalledTimes(1);
    expect(set).toHaveBeenCalledTimes(1);
    expect(set).toHaveBeenCalledWith({
      studentId: "student-1",
      type: NotificationType.quizAvailable,
      title: "New quiz available",
      body: "A new quiz is available for Quadratic Functions.",
      target: {
        feature: "quiz",
        resourceId: "quiz-1",
        secondaryResourceId: "topic-1",
      },
      createdAt: expect.anything(),
      readAt: null,
      expiresAt: null,
    });
  });

  it("creates a notification without a secondary resource", async () => {
    const set = vi.fn().mockResolvedValue(undefined);
    const doc = vi.fn().mockReturnValue({set,});
    const collection = vi.fn().mockReturnValue({doc,});

    const firestore = {collection,} as any;
    const service = new NotificationService(firestore);

    await service.create({
      studentId: "student-1",
      type: NotificationType.system,
      title: "Welcome to MathMatric",
      body: "Welcome to MathMatric.",
      target: {
        feature: "home",
        resourceId: "home",
      },
    });

    expect(set).toHaveBeenCalledWith({
      studentId: "student-1",
      type: NotificationType.system,
      title: "Welcome to MathMatric",
      body: "Welcome to MathMatric.",
      target: {
        feature: "home",
        resourceId: "home",
      },
      createdAt: expect.anything(),
      readAt: null,
      expiresAt: null,
    });
  });

  it("stores expiresAt when provided", async () => {
    const set = vi.fn().mockResolvedValue(undefined);
    const doc = vi.fn().mockReturnValue({set,});
    const collection = vi.fn().mockReturnValue({doc,});

    const firestore = {collection,} as any;
    const service = new NotificationService(firestore);
    const expiresAt = new Date("2026-09-30T23:59:59.000Z",);

    await service.create({
      studentId: "student-1",
      type: NotificationType.quizAvailable,
      title: "New quiz",
      body: "A new quiz is available.",
      target: {
        feature: "quiz",
        resourceId: "quiz-1",
      },
      expiresAt,
    });

    expect(set).toHaveBeenCalledWith({
      studentId: "student-1",
      type: NotificationType.quizAvailable,
      title: "New quiz",
      body: "A new quiz is available.",
      target: {
        feature: "quiz",
        resourceId: "quiz-1",
      },
      createdAt: expect.anything(),
      readAt: null,
      expiresAt: Timestamp.fromDate(expiresAt),
    });
  });

  it("returns the generated notification ID", async () => {
    const set = vi.fn().mockResolvedValue(undefined);
    const doc = vi.fn().mockReturnValue({
      id: "notification-123",
      set,
    });
    const collection = vi.fn().mockReturnValue({doc,});

    const firestore = {collection,} as any;
    const service = new NotificationService(firestore);

    const result = await service.create({
      studentId: "student-1",
      type: NotificationType.masterclassAvailable,
      title: "New masterclass",
      body: "A new masterclass is available.",
      target: {
        feature: "masterclass",
        resourceId: "masterclass-1",
      },
    });

    expect(result).toBe("notification-123");
  });

  it("waits for Firestore to finish writing", async () => {
    let resolveSet!: () => void;

    const setPromise = new Promise<void>((resolve) => {resolveSet = resolve;});

    const set = vi.fn().mockReturnValue(setPromise);
    const doc = vi.fn().mockReturnValue({
      id: "notification-123",
      set,
    });
    const collection = vi.fn().mockReturnValue({doc,});

    const firestore = {collection,} as any;
    const service = new NotificationService(firestore);

    const createPromise = service.create({
      studentId: "student-1",
      type: NotificationType.system,
      title: "System message",
      body: "This is a system message.",
      target: {
        feature: "home",
        resourceId: "home",
      },
    });

    let completed = false;

    createPromise.then(() => {completed = true;});

    await Promise.resolve();

    expect(completed).toBe(false);

    resolveSet();

    await createPromise;

    expect(completed).toBe(true);
  });

  it("propagates Firestore errors", async () => {
    const error = new Error("Firestore write failed",);

    const set = vi.fn().mockRejectedValue(error);
    const doc = vi.fn().mockReturnValue({
      id: "notification-123",
      set,
    });
    const collection = vi.fn().mockReturnValue({doc,});

    const firestore = {collection,} as any;
    const service = new NotificationService(firestore);

    await expect(
      service.create({
        studentId: "student-1",
        type: NotificationType.system,
        title: "System message",
        body: "This is a system message.",
        target: {
          feature: "home",
          resourceId: "home",
        },
      }),
    ).rejects.toThrow("Firestore write failed");
  });
});
