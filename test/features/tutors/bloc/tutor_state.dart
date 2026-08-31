import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_entity.dart';

abstract class TutorState {
  const TutorState();
}

class TutorInitial extends TutorState {
  const TutorInitial();
}

class TutorLoading extends TutorState {
  const TutorLoading();
}

class TutorLoaded extends TutorState {
  final List<TutorEntity> tutors;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;
  final bool isLoadingMore;

  const TutorLoaded({
    required this.tutors,
    required this.lastDocument,
    required this.hasMore,
    this.isLoadingMore = false,
  });
}

class TutorError extends TutorState {
  final String message;

  const TutorError(this.message);
}
