import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/practice/domain/usecases/load_practice_topic.dart';
import 'practice_event.dart';
import 'practice_state.dart';

class PracticeBloc extends Bloc<PracticeEvent, PracticeState> {
  final LoadPracticeTopicUseCase loadPractice;

  PracticeBloc({
    required this.loadPractice,
  }) : super(const PracticeInitial()) {
    on<PracticeLoadTopic>(_onLoadTopic);
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
    } catch (e, stackTrace) {
      debugPrint("_onLoadTopic BLOC ERROR: $e");
      debugPrint("STACK TRACE:\n$stackTrace");
      emit(PracticeError('PracticeLoadTopic Message: ${e.toString()}'));
    }
  }
}
