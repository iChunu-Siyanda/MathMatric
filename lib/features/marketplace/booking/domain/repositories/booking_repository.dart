import 'package:math_matric/features/marketplace/booking/domain/entities/request_booking_entity.dart';

import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<BookingEntity> getBooking(
    String bookingId,
  );

  Future<List<BookingEntity>> getStudentBookings({
    required String studentId,
  });

  Future<BookingEntity> createBooking(
    RequestBookingEntity request, 
  );

  Future<void> cancelBooking(
    String bookingId,
  );

  Future<List<BookingEntity>> getConfirmedBookingsForDate({
    required String tutorId,
    required DateTime date,
  });

  // Stream<BookingEntity> watchBooking(String bookingId);

  // Stream<List<BookingEntity>> watchStudentBookings();
}
