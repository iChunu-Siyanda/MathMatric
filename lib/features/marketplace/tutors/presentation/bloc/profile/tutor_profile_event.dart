import 'package:equatable/equatable.dart';

sealed class TutorProfileEvent extends Equatable {
  const TutorProfileEvent();

  @override
  List<Object?> get props => [];
}

final class TutorProfileRequested extends TutorProfileEvent {
  final String tutorId;

  const TutorProfileRequested(this.tutorId);

  @override
  List<Object?> get props => [tutorId];
}
