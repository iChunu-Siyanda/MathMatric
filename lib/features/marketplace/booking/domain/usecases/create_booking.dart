import 'package:math_matric/features/marketplace/booking/domain/entities/request_booking_entity.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CreateBooking {
  final BookingRepository repository;
  const CreateBooking(this.repository);

  Future<BookingEntity> call(
    RequestBookingEntity request,
  ) {
    return repository.createBooking(request);
  }
}
