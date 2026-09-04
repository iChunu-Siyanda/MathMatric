import { describe, expect, it, beforeEach, vi } from "vitest";
import {NotificationDeliveryService,} from "./notification_delivery_service";

describe("NotificationDeliveryService", () => {
  const get = vi.fn();
  const collection = vi.fn();

  const sendEachForMulticast = vi.fn();

  const deleteMock = vi.fn();
  const commit = vi.fn();
  const batch = {
    delete: deleteMock,
    commit,
  };

  const firestore = {
    collection,
    batch: vi.fn().mockReturnValue(batch),
  };

  const messaging = {sendEachForMulticast,};

  const delivery = new NotificationDeliveryService(
    firestore as any,
    messaging as any,
  );

  beforeEach(() => {
    vi.clearAllMocks();

    collection.mockReturnValue({
      doc: vi.fn().mockReturnValue({
        collection: vi.fn().mockReturnValue({
          get,
        }),
      }),
    });

    get.mockResolvedValue({
      empty: false,
      docs: [],
    });

    sendEachForMulticast.mockResolvedValue({
      responses: [],
    });
  });

  it("does nothing when the student has no devices", async () => {
    get.mockResolvedValue({
      empty: true,
      docs: [],
    });

    await delivery.send({
      studentId: "student-123",
      title: "New Quiz",
      body: "A new quiz is available.",
      data: {
        type: "quiz_available",
        feature: "quiz",
        resourceId: "quiz-123",
      },
    });

    expect(sendEachForMulticast).not.toHaveBeenCalled();
  });

  it("does nothing when devices have no valid tokens", async () => {
    get.mockResolvedValue({
      empty: false,
      docs: [
        {
          data: () => ({
            token: "",
          }),
        },
        {
          data: () => ({
            token: null,
          }),
        },
      ],
    });

    await delivery.send({
      studentId: "student-123",
      title: "New Quiz",
      body: "A new quiz is available.",
      data: {
        type: "quiz_available",
        feature: "quiz",
        resourceId: "quiz-123",
      },
    });

    expect(sendEachForMulticast).not.toHaveBeenCalled();
  });

  it("sends the notification to all registered devices", async () => {
    get.mockResolvedValue({
      empty: false,
      docs: [
        {
          data: () => ({
            token: "token-1",
          }),
        },
        {
          data: () => ({
            token: "token-2",
          }),
        },
      ],
    });

    await delivery.send({
      studentId: "student-123",
      title: "New Quiz",
      body: "A new quiz is available.",
      data: {
        type: "quiz_available",
        feature: "quiz",
        resourceId: "quiz-123",
      },
    });

    expect(sendEachForMulticast).toHaveBeenCalledWith({
      tokens: ["token-1", "token-2"],
      notification: {
        title: "New Quiz",
        body: "A new quiz is available.",
      },
      data: {
        type: "quiz_available",
        feature: "quiz",
        resourceId: "quiz-123",
      },
    });
  });

  it("ignores devices with invalid token data", async () => {
    get.mockResolvedValue({
      empty: false,
      docs: [
        {
          data: () => ({
            token: "valid-token",
          }),
        },
        {
          data: () => ({
            token: null,
          }),
        },
        {
          data: () => ({
            token: 123,
          }),
        },
      ],
    });

    await delivery.send({
      studentId: "student-123",
      title: "Test",
      body: "Test notification.",
      data: {
        type: "system",
        feature: "system",
        resourceId: "system",
      },
    });

    expect(sendEachForMulticast).toHaveBeenCalledWith(
      expect.objectContaining({
        tokens: ["valid-token"],
      }),
    );
  });

  it("deletes invalid FCM tokens", async () => {
    const invalidDeviceRef = {
      id: "device-invalid",
    };

    get.mockResolvedValue({
      empty: false,
      docs: [
        {
          ref: invalidDeviceRef,
          data: () => ({
            token: "invalid-token",
          }),
        },
        {
          ref: {
            id: "device-valid",
          },
          data: () => ({
            token: "valid-token",
          }),
        },
      ],
    });

    sendEachForMulticast.mockResolvedValue({
      responses: [
        {
          success: false,
          error: {
            code:
              "messaging/registration-token-not-registered",
          },
        },
        {
          success: true,
        },
      ],
    });

    await delivery.send({
      studentId: "student-123",
      title: "Test",
      body: "Test notification.",
      data: {
        type: "system",
        feature: "system",
        resourceId: "system",
      },
    });

    expect(deleteMock).toHaveBeenCalledWith(
      invalidDeviceRef,
    );

    expect(commit).toHaveBeenCalled();
  });

  it("does not delete valid devices", async () => {
    const validDeviceRef = {
      id: "device-valid",
    };

    get.mockResolvedValue({
      empty: false,
      docs: [
        {
          ref: validDeviceRef,
          data: () => ({
            token: "valid-token",
          }),
        },
      ],
    });

    sendEachForMulticast.mockResolvedValue({
      responses: [
        {
          success: true,
        },
      ],
    });

    await delivery.send({
      studentId: "student-123",
      title: "Test",
      body: "Test notification.",
      data: {
        type: "system",
        feature: "system",
        resourceId: "system",
      },
    });

    expect(deleteMock).not.toHaveBeenCalled();
    expect(commit).not.toHaveBeenCalled();
  });

  it("does not throw when there are no devices", async () => {
    get.mockResolvedValue({
      empty: true,
      docs: [],
    });

    await expect(
      delivery.send({
        studentId: "student-123",
        title: "Test",
        body: "Test notification.",
        data: {
          type: "system",
          feature: "system",
          resourceId: "system",
        },
      }),
    ).resolves.toBeUndefined();
  });
});
