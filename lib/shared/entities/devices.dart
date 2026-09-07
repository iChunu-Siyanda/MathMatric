// In Firstore:
// students/{studentId}/devices/{deviceId}

// {
//   token: string,
//   platform: "android" | "ios",
//   createdAt: Timestamp,
//   updatedAt: Timestamp
// }

// Student device calls registerStudentDevice

// notification
//     ↓
// studentId
//     ↓
// students/{studentId}/devices
//     ↓
// all active FCM tokens
//     ↓
// FCM
//     ↓
// student's devices