import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> getBooking(String bookingId);

  Future<List<BookingModel>> getStudentBookings({
    required String studentId,
  });

  Future<BookingModel> createBooking(BookingModel booking);

  Future<void> cancelBooking(String bookingId);
}
