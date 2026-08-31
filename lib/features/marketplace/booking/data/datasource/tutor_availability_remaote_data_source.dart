import 'package:math_matric/features/marketplace/booking/data/models/tutor_availability_model.dart';

abstract class TutorAvailabilityRemoteDataSource {
  Future<TutorAvailabilityModel> getAvailability(
    String tutorId,
  );
}
