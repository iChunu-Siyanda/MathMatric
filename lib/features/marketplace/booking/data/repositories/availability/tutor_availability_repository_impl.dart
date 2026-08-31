import 'package:math_matric/features/marketplace/booking/data/datasource/tutor_availability_remaote_data_source.dart';
import 'package:math_matric/features/marketplace/booking/domain/entities/tutor_availability.dart';
import 'package:math_matric/features/marketplace/booking/domain/repositories/tutor_availability_repository.dart';

class TutorAvailabilityRepositoryImpl implements TutorAvailabilityRepository {
  final TutorAvailabilityRemoteDataSource dataSource;

  TutorAvailabilityRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<TutorAvailability> getAvailability(
    String tutorId,
  ) {
    return dataSource.getAvailability(
      tutorId,
    );
  }
}
