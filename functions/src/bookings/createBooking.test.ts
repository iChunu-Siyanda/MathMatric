// import {
//   describe,
//   expect,
//   it,
//   vi,
// } from "vitest";

// import {
//   handleCreateBooking,
// } from "./createBooking";

// function createFakeFirestore() {
//   const mockSet = vi.fn().mockResolvedValue(undefined);

//   const mockDoc = vi.fn(() => ({
//     id: "booking-123",
//     set: mockSet,
//   }));

//   const mockCollection = vi.fn(() => ({
//     doc: mockDoc,
//   }));

//   return {
//     collection: mockCollection,
//     mockSet,
//     mockDoc,
//   };
// }

// describe("handleCreateBooking", () => {
//   it("rejects unauthenticated requests", async () => {
//     await expect(
//       handleCreateBooking({
//         auth: null,
//         data: {
//           tutorId: "tutor-1",
//           scheduledAt:
//             "2030-09-15T15:00:00.000Z",
//           durationMinutes: 60,
//           teachingMode: "online",
//         },
//       }),
//     ).rejects.toThrow(
//       "You must be signed in to create a booking.",
//     );
//   });

//   it("creates a pending booking with the authoritative price", async () => {
//     vi.mocked(getTutor).mockResolvedValue({
//       displayName: "Alice",
//       teachingModes: [
//         "online",
//         "inPerson",
//       ],
//       onlinePrice: 18000,
//       inPersonPrice: 25000,
//     });

//     vi.mocked(calculateBookingPrice)
//       .mockReturnValue(18000);

//     vi.mocked(hasConfirmedBookingConflict)
//       .mockResolvedValue(false);

//     mockSet.mockResolvedValue(undefined);

//     const result = await handleCreateBooking({
//       auth: {
//         uid: "student-1",
//       },
//       data: {
//         tutorId: "tutor-1",
//         scheduledAt:
//           "2030-09-15T15:00:00.000Z",
//         durationMinutes: 60,
//         teachingMode: "online",
//       },
//     });

//     expect(result.success).toBe(true);
//     expect(result.bookingId).toBe(
//       "booking-123",
//     );
//     expect(result.priceCents).toBe(18000);
//     expect(result.currency).toBe("ZAR");
//     expect(result.status).toBe("pending");

//     expect(
//       validateTeachingMode,
//     ).toHaveBeenCalledWith(
//       expect.anything(),
//       "online",
//     );

//     expect(
//       hasConfirmedBookingConflict,
//     ).toHaveBeenCalledWith({
//       tutorId: "tutor-1",
//       scheduledAt: expect.any(Date),
//       durationMinutes: 60,
//     });

//     expect(mockSet).toHaveBeenCalledOnce();

//     const savedBooking =
//       mockSet.mock.calls[0][0];

//     expect(savedBooking.studentId).toBe(
//       "student-1",
//     );

//     expect(savedBooking.tutorId).toBe(
//       "tutor-1",
//     );

//     expect(savedBooking.status).toBe(
//       "pending",
//     );

//     expect(savedBooking.priceCents).toBe(
//       18000,
//     );
//   });

//   it("rejects a slot that already has a confirmed booking", async () => {
//     vi.mocked(getTutor).mockResolvedValue({
//       displayName: "Alice",
//       teachingModes: ["online"],
//       onlinePrice: 18000,
//     });

//     vi.mocked(calculateBookingPrice)
//       .mockReturnValue(18000);

//     vi.mocked(hasConfirmedBookingConflict)
//       .mockResolvedValue(true);

//     await expect(
//       handleCreateBooking({
//         auth: {
//           uid: "student-2",
//         },
//         data: {
//           tutorId: "tutor-1",
//           scheduledAt:
//             "2030-09-15T15:00:00.000Z",
//           durationMinutes: 60,
//           teachingMode: "online",
//         },
//       }),
//     ).rejects.toThrow(
//       "This time slot is already booked.",
//     );

//     expect(mockSet).not.toHaveBeenCalled();
//   });

//   it("uses the authenticated user's uid as studentId", async () => {
//     vi.clearAllMocks();

//     vi.mocked(getTutor).mockResolvedValue({
//       displayName: "Alice",
//       teachingModes: ["online"],
//       onlinePrice: 18000,
//     });

//     vi.mocked(calculateBookingPrice)
//       .mockReturnValue(18000);

//     vi.mocked(hasConfirmedBookingConflict)
//       .mockResolvedValue(false);

//     mockSet.mockResolvedValue(undefined);

//     await handleCreateBooking({
//       auth: {
//         uid: "real-student-123",
//       },
//       data: {
//         tutorId: "tutor-1",
//         scheduledAt:
//           "2030-09-15T15:00:00.000Z",
//         durationMinutes: 60,
//         teachingMode: "online",
//       },
//     });

//     expect(mockSet).toHaveBeenCalledOnce();

//     const savedBooking =
//       mockSet.mock.calls[0][0];

//     expect(savedBooking.studentId).toBe(
//       "real-student-123",
//     );
//   });
// });
