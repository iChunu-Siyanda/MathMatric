import 'package:math_matric/features/marketplace/booking/domain/entities/booking_entity.dart';
import 'package:math_matric/features/marketplace/booking/domain/repositories/booking_repository.dart';

class GetConfirmedBookingsForDate {
  final BookingRepository repository;
  const GetConfirmedBookingsForDate(
    this.repository,
  );

  Future<List<BookingEntity>> call({
    required String tutorId,
    required DateTime date,
  }) {
    return repository.getConfirmedBookingsForDate(
      tutorId: tutorId,
      date: date,
    );
  }
}
