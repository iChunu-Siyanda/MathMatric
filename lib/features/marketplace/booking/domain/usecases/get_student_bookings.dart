import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetStudentBookings {
  final BookingRepository repository;
  const GetStudentBookings(this.repository);

  Future<List<BookingEntity>> call({
    required String studentId,
  }) {
    return repository.getStudentBookings(
      studentId: studentId,
    );
  }
}
