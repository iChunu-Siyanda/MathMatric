import 'package:math_matric/features/marketplace/booking/domain/entities/tutor_availability.dart';
import 'package:math_matric/features/marketplace/booking/domain/repositories/tutor_availability_repository.dart';

class GetTutorAvailabilityUseCase {
  final TutorAvailabilityRepository repository;
  const GetTutorAvailabilityUseCase(this.repository);

  Future<TutorAvailability> call(
    String tutorId,
  ) {
    return repository.getAvailability(
      tutorId,
    );
  }
}

// UI:
// Alice
// Mathematics Tutor
// ⭐ 4.8

// Teaching:
// Online · In-person

// Online: R180/hr
// In-person: R250/hr

// Choose date

// September 15
// ────────────────────

// Available times

// 09:00
// 09:30
// 10:00
// 10:30

// [15:00] ← unavailable
// 15:30
// 16:00
