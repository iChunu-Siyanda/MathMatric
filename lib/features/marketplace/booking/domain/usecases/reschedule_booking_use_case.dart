import 'package:math_matric/features/marketplace/booking/domain/entities/booking_entity.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/reschedule_booking_entity.dart';
import 'package:math_matric/features/marketplace/booking/domain/repositories/booking_repository.dart';

class RescheduleBookingUseCase {
  final BookingRepository repository;

  const RescheduleBookingUseCase(this.repository);

  Future<BookingEntity> call(
    RescheduleBookingEntity request,
  ) {
    return repository.rescheduleBooking(request);
  }
}
