import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_entity.dart';

class TutorPage {
  final List<TutorEntity> tutors;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  const TutorPage({
    required this.tutors,
    required this.lastDocument,
    required this.hasMore,
  });
}
