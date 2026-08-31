import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> getBooking(String bookingId);

  Future<List<BookingModel>> getStudentBookings({
    required String studentId,
  });

  Future<BookingModel> createBooking(BookingModel booking);

  Future<void> cancelBooking(String bookingId);

  // In Tutor's App:
  // Future<void> acceptBooking(
  //   String bookingId,
  // );

  // Future<void> declineBooking(
  //   String bookingId,
  // );
}

// STUDENT APP
// │
// ├── Tutor discovery
// ├── Tutor search/filtering
// ├── Tutor profile
// ├── Tutor availability
// ├── Booking request
// ├── Booking price calculation
// ├── My bookings
// ├── Booking status
// └── Cancel booking

// The Tutor App later will handle:
// TUTOR APP
// │
// ├── Tutor profile management
// ├── Availability management
// ├── Incoming booking requests
// ├── Accept / decline
// ├── Schedule
// ├── Earnings
// ├── Student information
// └── Lesson management