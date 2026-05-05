import 'package:equatable/equatable.dart';
import 'package:math_matric/features/home/domain/entities/last_studied.dart';

class StudyHistoryState extends Equatable {
  final List<LastStudied> recentTopics;

  const StudyHistoryState({this.recentTopics = const []});

  @override
  List<Object?> get props => [recentTopics];
}
