import { HttpsError } from "firebase-functions/https";
import {handleRegisterStudentDevice,validateRegisterStudentDeviceRequest,} from "./register_student_device";
import { beforeEach, describe, expect, it, vi } from "vitest";

describe("validateRegisterStudentDeviceRequest", () => {
  it("rejects non-object data", () => {
    expect(() =>
      validateRegisterStudentDeviceRequest(null),
    ).toThrow(HttpsError);
  });

  it("rejects missing deviceId", () => {
    expect(() => validateRegisterStudentDeviceRequest({
        token: "fcm-token",
        platform: "android",
      }),
    ).toThrow("Device Id is required.");
  });

  it("rejects empty deviceId", () => {
    expect(() => validateRegisterStudentDeviceRequest({
        deviceId: "   ",
        token: "fcm-token",
        platform: "android",
      }),
    ).toThrow("Device Id is required.");
  });

  it("rejects missing token", () => {
    expect(() =>
      validateRegisterStudentDeviceRequest({
        deviceId: "device-123",
        platform: "android",
      }),
    ).toThrow("FCM token is required.");
  });

  it("rejects empty token", () => {
    expect(() =>
      validateRegisterStudentDeviceRequest({
        deviceId: "device-123",
        token: "   ",
        platform: "android",
      }),
    ).toThrow("FCM token is required.");
  });

  it("rejects invalid platform", () => {
    expect(() =>
      validateRegisterStudentDeviceRequest({
        deviceId: "device-123",
        token: "fcm-token",
        platform: "windows",
      }),
    ).toThrow("Platform must be android or ios.");
  });

  it("accepts a valid Android request", () => {
    expect(
      validateRegisterStudentDeviceRequest({
        deviceId: " device-123 ",
        token: " fcm-token ",
        platform: "android",
      }),
    ).toEqual({
      deviceId: "device-123",
      token: "fcm-token",
      platform: "android",
    });
  });

  it("accepts a valid iOS request", () => {
    expect(
      validateRegisterStudentDeviceRequest({
        deviceId: "device-456",
        token: "fcm-token-ios",
        platform: "ios",
      }),
    ).toEqual({
      deviceId: "device-456",
      token: "fcm-token-ios",
      platform: "ios",
    });
  });
});

describe("handleRegisterStudentDevice", () => {
  const set = vi.fn();
  const update = vi.fn();
  const transactionGet = vi.fn();

  const deviceRef = {id: "device-123",};
  const devicesCollection = {doc: vi.fn().mockReturnValue(deviceRef),};
  const studentRef = {collection: vi.fn().mockReturnValue(devicesCollection),};
  const studentsCollection = {doc: vi.fn().mockReturnValue(studentRef),};

  const transaction = {
    get: transactionGet,
    set,
    update,
  };

  const firestore = {
    collection: vi.fn().mockReturnValue(studentsCollection),
    runTransaction: vi.fn(async (callback) => {
      return callback(transaction);
    }),
  };

  beforeEach(() => {
    vi.clearAllMocks();
    deviceRef.id = "device-123";

    transactionGet.mockResolvedValue({
      exists: false,
      data: vi.fn(),
    });
  });

  it("rejects unauthenticated requests", async () => {
    await expect(
      handleRegisterStudentDevice(
        {
          auth: null,
          data: {
            deviceId: "device-123",
            token: "fcm-token",
            platform: "android",
          },
        },
        firestore as any,
      ),
    ).rejects.toMatchObject({
      code: "unauthenticated",
    });

    expect(firestore.runTransaction).not.toHaveBeenCalled();
  });

  it("uses the authenticated UID as the student ID", async () => {
    await handleRegisterStudentDevice(
      {
        auth: {
          uid: "student-123",
        },
        data: {
          deviceId: "device-456",
          token: "fcm-token",
          platform: "android",
        },
      },
      firestore as any,
    );

    expect(studentsCollection.doc).toHaveBeenCalledWith(
      "student-123",
    );
  });

  it("creates an Android device successfully", async () => {
    deviceRef.id = "device-android";

    const result = await handleRegisterStudentDevice(
      {
        auth: {
          uid: "student-123",
        },
        data: {
          deviceId: "device-android",
          token: "android-token",
          platform: "android",
        },
      },
      firestore as any,
    );

    expect(result).toEqual({
      success: true,
      deviceId: "device-android",
    });

    expect(set).toHaveBeenCalledWith(deviceRef,{
      token: "android-token",
      platform: "android",
      createdAt: expect.anything(),
      updatedAt: expect.anything(),
    });
  });

  it("creates an iOS device successfully", async () => {
    deviceRef.id = "device-ios";

    const result = await handleRegisterStudentDevice(
      {
        auth: {
          uid: "student-123",
        },
        data: {
          deviceId: "device-ios",
          token: "ios-token",
          platform: "ios",
        },
      },
      firestore as any,
    );

    expect(result).toEqual({
      success: true,
      deviceId: "device-ios",
    });

    expect(set).toHaveBeenCalledWith(
      deviceRef,
      {
        token: "ios-token",
        platform: "ios",
        createdAt: expect.anything(),
        updatedAt: expect.anything(),
      }
    );
  });

  it("stores the device under the authenticated student's devices collection", async () => {
    await handleRegisterStudentDevice(
      {
        auth: {
          uid: "student-789",
        },
        data: {
          deviceId: "device-abc",
          token: "token-abc",
          platform: "android",
        },
      },
      firestore as any,
    );

    expect(firestore.collection).toHaveBeenCalledWith(
      "students",
    );

    expect(studentsCollection.doc).toHaveBeenCalledWith(
      "student-789",
    );

    expect(studentRef.collection).toHaveBeenCalledWith(
      "devices",
    );

    expect(devicesCollection.doc).toHaveBeenCalledWith(
      "device-abc",
    );
  });

  it("updates an existing device instead of creating a duplicate", async () => {
    transactionGet.mockResolvedValue({
      exists: true,
      data: vi.fn().mockReturnValue({
        token: "old-token",
        platform: "android",
        createdAt: "original-created-at",
      }),
    });

    await handleRegisterStudentDevice(
      {
        auth: {
          uid: "student-123",
        },
        data: {
          deviceId: "device-123",
          token: "new-token",
          platform: "ios",
        },
      },
      firestore as any,
    );

    expect(update).toHaveBeenCalledWith(deviceRef,{
      token: "new-token",
      platform: "ios",
      updatedAt: expect.anything(),
    });

    expect(set).not.toHaveBeenCalled();
  });

  it("preserves createdAt when an existing device is updated", async () => {
    transactionGet.mockResolvedValue({
      exists: true,
      data: vi.fn().mockReturnValue({
        token: "old-token",
        platform: "android",
        createdAt: "original-created-at",
      }),
    });

    await handleRegisterStudentDevice(
      {
        auth: {
          uid: "student-123",
        },
        data: {
          deviceId: "device-123",
          token: "new-token",
          platform: "android",
        },
      },
      firestore as any,
    );

    const updateData = update.mock.calls[0][1];

    expect(updateData).not.toHaveProperty("createdAt");
    expect(updateData).toMatchObject({
      token: "new-token",
      platform: "android",
    });
  });
});
