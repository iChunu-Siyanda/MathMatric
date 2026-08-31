import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/features/marketplace/booking/data/datasource/tutor_availability_remaote_data_source.dart';
import 'package:math_matric/features/marketplace/booking/data/models/tutor_availability_model.dart';

class TutorAvailabilityRemoteDataSourceImpl implements TutorAvailabilityRemoteDataSource {
  final FirebaseFirestore firestore;

  TutorAvailabilityRemoteDataSourceImpl({
    required this.firestore,
  });

  @override
  Future<TutorAvailabilityModel> getAvailability(
    String tutorId,
  ) async {
    final snapshot = await firestore
        .collection('tutorAvailability')
        .doc(tutorId)
        .get();

    if (!snapshot.exists || snapshot.data() == null) {
      throw Exception(
        'Tutor availability not found',
      );
    }

    return TutorAvailabilityModel.fromFirestore(
      snapshot.data()!,
    );
  }
}
