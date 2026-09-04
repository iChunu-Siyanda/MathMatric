import 'package:math_matric/features/marketplace/booking/domain/entities/request_booking_entity.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/reschedule_booking_entity.dart';

import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> getBooking(String bookingId);

  Future<List<BookingModel>> getStudentBookings({
    required String studentId,
  });

  Future<BookingModel> createBooking(RequestBookingEntity request,);

  Future<void> cancelBooking(String bookingId);

  Future<BookingModel> rescheduleBooking(
    RescheduleBookingEntity request,
  );

  Future<List<BookingModel>> getConfirmedBookingsForDate({
    required String tutorId,
    required DateTime date,
  });

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