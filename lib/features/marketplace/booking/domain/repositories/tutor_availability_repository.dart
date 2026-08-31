import 'package:math_matric/features/marketplace/booking/domain/entities/tutor_availability.dart';

abstract class TutorAvailabilityRepository {
  Future<TutorAvailability> getAvailability(
    String tutorId,
  );
}
