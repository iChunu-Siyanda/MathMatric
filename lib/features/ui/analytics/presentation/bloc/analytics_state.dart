import 'package:equatable/equatable.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/practice/domain/entities/practice_topic.dart';
import 'package:math_matric/features/progress/questionattempts/domain/entities/question_attempts_entity.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/entities/user_level_progresses_entity.dart';

sealed class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

class AnalyticsLoaded extends AnalyticsState {
  final List<PracticeTopic> topics;
  final List<UserLevelProgressEntity> levels;
  final List<QuestionAttemptEntity> questionAttempts;
  final List<StudySessionEntity> sessions;
  final AnalyticsTimeframe selectedTimeframe;
  final bool isRefreshing;

  const AnalyticsLoaded({
    required this.topics,
    required this.levels,
    required this.questionAttempts,
    required this.sessions,
    this.selectedTimeframe = AnalyticsTimeframe.days7,
    this.isRefreshing = false,
  });

  AnalyticsLoaded copyWith({
    List<PracticeTopic>? topics,
    List<UserLevelProgressEntity>? levels,
    List<QuestionAttemptEntity>? questionAttempts,
    List<StudySessionEntity>? sessions,
    AnalyticsTimeframe? selectedTimeframe,
    bool? isRefreshing,
  }) {
    return AnalyticsLoaded(
      topics: topics ?? this.topics,
      levels: levels ?? this.levels,
      questionAttempts: questionAttempts ?? this.questionAttempts,
      sessions: sessions ?? this.sessions,
      selectedTimeframe: selectedTimeframe ?? this.selectedTimeframe,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
        topics,
        levels,
        questionAttempts,
        sessions,
        selectedTimeframe,
        isRefreshing,
      ];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError({required this.message});

  @override
  List<Object?> get props => [message];
}
