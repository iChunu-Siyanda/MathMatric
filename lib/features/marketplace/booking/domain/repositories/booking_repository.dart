import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<BookingEntity> getBooking(
    String bookingId,
  );

  Future<List<BookingEntity>> getStudentBookings({
    required String studentId,
  });

  Future<BookingEntity> createBooking(
    BookingEntity booking,
  );

  Future<void> cancelBooking(
    String bookingId,
  );
}
