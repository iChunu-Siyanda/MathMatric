import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/domain/usercases/load_practice_topic.dart';
import 'practice_event.dart';
import 'practice_state.dart';

class PracticeBloc extends Bloc<PracticeEvent, PracticeState> {
  final LoadPracticeTopicUseCase loadPractice;
  //final String topicId;

  PracticeBloc({
    required this.loadPractice,
   // required this.topicId,
  }) : super(const PracticeInitial()) {
    on<PracticeLoadTopic>(_onLoadTopic);
    on<CompleteLevel>(_onCompleteLevel);
  }

  Future<void> _onLoadTopic(
    PracticeLoadTopic event,
    Emitter<PracticeState> emit,
  ) async {
    emit(const PracticeLoading());
    debugPrint("_onLoadTopic triggered");

    try {
      final topicData = await loadPractice(event.topicId.toLowerCase());
      debugPrint("From PracticeBloc, topicId: ${event.topicId}");
      emit(PracticeLoaded(topicData));
    } catch (e) {
      emit(PracticeError('PracticeLoadTopic Message: ${e.toString()}'));
    }
  }

  //When user completes the quiz it completes level
  Future<void> _onCompleteLevel(
    CompleteLevel event,
    Emitter<PracticeState> emit,
  ) async {
    try {
      // Persist progress locally
      await loadPractice.progressRepository.markLevelCompleted(
        topicId: event.topicId.toLowerCase(),
        levelId: event.levelId,
        xpEarned: event.xpEarned,
      );

      final topicData = await loadPractice(event.topicId);

      emit(PracticeLoaded(topicData));
    } catch (e) {
      emit(PracticeError('Practice, CompleteLevel Message: ${e.toString()}'));
    }
  }
}
