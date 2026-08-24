import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/progress/studysession/domain/usecases/complete_study_session_use_case.dart';
import 'package:math_matric/features/progress/studysession/domain/usecases/get_active_study_session_use_case.dart';
import 'package:math_matric/features/progress/studysession/domain/usecases/start_study_session_use_case.dart';
import 'package:math_matric/features/progress/studysession/domain/usecases/update_study_session_use_case.dart';
import 'study_session_event.dart';
import 'study_session_state.dart';

class StudySessionBloc extends Bloc<StudySessionEvent, StudySessionState> {
  final StartStudySessionUseCase startSession;
  final GetActiveStudySessionUseCase getActiveSession;
  final UpdateStudySessionProgressUseCase updateProgress;
  final CompleteStudySessionUseCase completeSession;

  StudySessionBloc({
    required this.startSession,
    required this.getActiveSession,
    required this.updateProgress,
    required this.completeSession,
  }) : super(const StudySessionInitial()) {

    on<StudySessionStarted>(_onStarted);
    on<ActiveStudySessionRequested>(_onActiveSessionRequested);
    on<StudySessionProgressUpdated>(_onProgressUpdated);
    on<StudySessionCompleted>(_onCompleted);
    on<StudySessionReset>(_onReset);
  }

  Future<void> _onStarted(
    StudySessionStarted event,
    Emitter<StudySessionState> emit,
  ) async {
    emit(const StudySessionLoading());

    try {
      // Prevent multiple active sessions.
      final activeSession = await getActiveSession();

      if (activeSession != null) {
        emit(StudySessionActive(session: activeSession,),);
        return;
      }

      final session = await startSession(
        topicId: event.topicId,
        activity: event.activity,
      );

      emit(StudySessionActive(session: session,),);
    } catch (e) {
      emit(StudySessionError('Failed to start study session: $e',),);
    }
  }

  Future<void> _onActiveSessionRequested(
    ActiveStudySessionRequested event,
    Emitter<StudySessionState> emit,
  ) async {
    emit(const StudySessionLoading());

    try {
      final session = await getActiveSession();

      if (session == null) {
        emit(const StudySessionInitial());
        return;
      }

      emit(StudySessionActive(session: session,),);
    } catch (e) {
      emit(StudySessionError('Failed to load active study session: $e',),);
    }
  }

  Future<void> _onProgressUpdated(
    StudySessionProgressUpdated event,
    Emitter<StudySessionState> emit,
  ) async {
    final currentState = state;

    if (currentState is! StudySessionActive) {
      return;
    }

    final session = currentState.session;

    try {
      await updateProgress(
        sessionId: session.id,
        questionsAnswered: event.questionsAnswered,
        correctAnswers: event.correctAnswers,
        earnedXP: event.earnedXP,
      );

      final updatedSession = StudySessionEntity(
        id: session.id,
        topicId: session.topicId,
        startedAt: session.startedAt,
        endedAt: session.endedAt,
        questionsAnswered: event.questionsAnswered,
        correctAnswers: event.correctAnswers,
        earnedXP: event.earnedXP,
        activity: session.activity,
      );

      emit(StudySessionActive(session: updatedSession,),);
    } catch (e) {
      emit(StudySessionError('Failed to update study session: $e',),);
    }
  }

  Future<void> _onCompleted(
    StudySessionCompleted event,
    Emitter<StudySessionState> emit,
  ) async {
    final currentState = state;

    if (currentState is! StudySessionActive) {
      return;
    }

    final session = currentState.session;

    try {
      await completeSession(
        sessionId: session.id,
      );

      final completedSession = StudySessionEntity(
        id: session.id,
        topicId: session.topicId,
        startedAt: session.startedAt,
        endedAt: DateTime.now(),
        questionsAnswered: session.questionsAnswered,
        correctAnswers: session.correctAnswers,
        earnedXP: session.earnedXP,
        activity: session.activity,
      );

      emit(StudySessionCompletedState(session: completedSession,),);
    } catch (e) {
      emit(StudySessionError('Failed to complete study session: $e',),);
    }
  }

  void _onReset(
    StudySessionReset event,
    Emitter<StudySessionState> emit,
  ) {
    emit(const StudySessionInitial());
  }
}
