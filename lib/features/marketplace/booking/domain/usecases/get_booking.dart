import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetBooking {
  final BookingRepository repository;

  const GetBooking(this.repository);

  Future<BookingEntity> call(String bookingId) {
    return repository.getBooking(bookingId);
  }
}
