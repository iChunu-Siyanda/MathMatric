import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/features/marketplace/tutors/data/models/tutor_model.dart';

class TutorPageModel {
  final List<TutorModel> tutors;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  const TutorPageModel({
    required this.tutors,
    required this.lastDocument,
    required this.hasMore,
  });
}
