import 'package:equatable/equatable.dart';
import 'package:math_matric/features/marketplace/tutors/domain/entities/tutor_entity.dart';

sealed class TutorProfileState extends Equatable {
  const TutorProfileState();

  @override
  List<Object?> get props => [];
}

final class TutorProfileInitial extends TutorProfileState {
  const TutorProfileInitial();
}

final class TutorProfileLoading extends TutorProfileState {
  const TutorProfileLoading();
}

final class TutorProfileLoaded extends TutorProfileState {
  final TutorEntity tutor;

  const TutorProfileLoaded(this.tutor);

  @override
  List<Object?> get props => [tutor];
}

final class TutorProfileError extends TutorProfileState {
  final String message;

  const TutorProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
