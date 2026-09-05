import { describe, expect, it, vi } from "vitest";
import {NotificationService,} from "./notification_service";

describe("NotificationService", () => {
  function createFirestoreMock() {
    const notificationRef = {
      id: "notification-123",
      set: vi.fn().mockResolvedValue(undefined),
    };

    const notificationsCollection = {
      doc: vi.fn().mockReturnValue(notificationRef),
    };

    const firestore = {
      collection: vi.fn().mockReturnValue(notificationsCollection,),
    };

    return {
      firestore,
      notificationRef,
      notificationsCollection,
    };
  }

  function createDeliveryMock() {
    return {
      send: vi.fn().mockResolvedValue(undefined),
    };
  }

  it("creates a notification in Firestore", async () => {
    const {firestore,notificationRef,} = createFirestoreMock();

    const delivery = createDeliveryMock();

    const service = new NotificationService(
      firestore as any,
      delivery as any,
    );

    const notificationId = await service.create({
      studentId: "student-123",
      type: "quiz_available",
      title: "New quiz available",
      body: "A new mathematics quiz is ready.",
      target: {
        feature: "quiz",
        resourceId: "quiz-123",
      },
    });

    expect(notificationId).toBe(
      "notification-123",
    );

    expect(notificationRef.set).toHaveBeenCalledOnce();
  });

  it("sends the notification through the delivery service", async () => {
    const {firestore,} = createFirestoreMock();

    const delivery = createDeliveryMock();

    const service = new NotificationService(
      firestore as any,
      delivery as any,
    );

    await service.create({
      studentId: "student-123",
      type: "quiz_available",
      title: "New quiz available",
      body: "A new mathematics quiz is ready.",
      target: {
        feature: "quiz",
        resourceId: "quiz-123",
      },
    });

    expect(delivery.send).toHaveBeenCalledWith({
      studentId: "student-123",
      title: "New quiz available",
      body: "A new mathematics quiz is ready.",
      data: {
        type: "quiz_available",
        feature: "quiz",
        resourceId: "quiz-123",
      },
    });
  });

  it("includes secondaryResourceId when provided", async () => {
    const {firestore,} = createFirestoreMock();

    const delivery = createDeliveryMock();

    const service = new NotificationService(
      firestore as any,
      delivery as any,
    );

    await service.create({
      studentId: "student-123",
      type: "quiz_assigned",
      title: "Quiz assigned",
      body: "You have been assigned a quiz.",
      target: {
        feature: "quiz",
        resourceId: "quiz-123",
        secondaryResourceId: "topic-456",
      },
    });

    expect(delivery.send).toHaveBeenCalledWith({
      studentId: "student-123",
      title: "Quiz assigned",
      body: "You have been assigned a quiz.",
      data: {
        type: "quiz_assigned",
        feature: "quiz",
        resourceId: "quiz-123",
        secondaryResourceId: "topic-456",
      },
    });
  });

  it("waits for Firestore before sending the push", async () => {
    const {firestore,notificationRef,} = createFirestoreMock();

    const delivery = createDeliveryMock();

    let firestoreCompleted = false;

    notificationRef.set.mockImplementation(async () => {firestoreCompleted = true;},);

    delivery.send.mockImplementation(
      async () => {
        expect(firestoreCompleted).toBe(true);
      },
    );

    const service = new NotificationService(
      firestore as any,
      delivery as any,
    );

    await service.create({
      studentId: "student-123",
      type: "system",
      title: "System message",
      body: "Hello.",
      target: {
        feature: "home",
        resourceId: "home",
      },
    });

    expect(delivery.send).toHaveBeenCalledOnce();
  });

  it("does not send a push when Firestore creation fails", async () => {
    const {
      firestore,
      notificationRef,
    } = createFirestoreMock();

    const delivery = createDeliveryMock();

    notificationRef.set.mockRejectedValue(
      new Error("Firestore failure"),
    );

    const service = new NotificationService(
      firestore as any,
      delivery as any,
    );

    await expect(
      service.create({
        studentId: "student-123",
        type: "system",
        title: "System message",
        body: "Hello.",
        target: {
          feature: "home",
          resourceId: "home",
        },
      }),
    ).rejects.toThrow("Firestore failure");

    expect(delivery.send).not.toHaveBeenCalled();
  });

  it("propagates delivery errors after Firestore succeeds", async () => {
    const {
      firestore,
      notificationRef,
    } = createFirestoreMock();

    const delivery = createDeliveryMock();

    notificationRef.set.mockResolvedValue(
      undefined,
    );

    delivery.send.mockRejectedValue(
      new Error("FCM failure"),
    );

    const service = new NotificationService(
      firestore as any,
      delivery as any,
    );

    await expect(
      service.create({
        studentId: "student-123",
        type: "system",
        title: "System message",
        body: "Hello.",
        target: {
          feature: "home",
          resourceId: "home",
        },
      }),
    ).rejects.toThrow("FCM failure");

    expect(notificationRef.set).toHaveBeenCalledOnce();
  });
});
