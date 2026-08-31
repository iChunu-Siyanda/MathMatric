import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CreateBooking {
  final BookingRepository repository;
  const CreateBooking(this.repository);

  Future<BookingEntity> call(
    BookingEntity booking,
  ) {
    return repository.createBooking(booking);
  }
}
