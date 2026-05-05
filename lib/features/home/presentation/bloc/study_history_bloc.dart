import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:math_matric/features/home/domain/entities/last_studied.dart';
import 'package:math_matric/features/home/presentation/bloc/study_history_event.dart';
import 'package:math_matric/features/home/presentation/bloc/study_history_state.dart';

class StudyHistoryBloc extends HydratedBloc<StudyHistoryEvent, StudyHistoryState> {
  StudyHistoryBloc() : super(const StudyHistoryState()) {
    on<TopicAccessed>((event, emit) {
      // Logic: If topic exists, move to front. If new, add to front.
      List<LastStudied> updated = List.from(state.recentTopics);
      updated.removeWhere((t) => t.title == event.topic.title);
      updated.insert(0, event.topic);
      emit(StudyHistoryState(recentTopics: updated));
    });
  }

  // Called when app starts to restore state
  @override
  StudyHistoryState? fromJson(Map<String, dynamic> json) {
    return StudyHistoryState(
      recentTopics: (json['recentTopics'] as List)
          .map((t) => LastStudied.fromJson(t))
          .toList(),
    );
  }

  // Called every time state changes to save data
  @override
  Map<String, dynamic>? toJson(StudyHistoryState state) {
    return {
      'recentTopics': state.recentTopics.map((t) => t.toJson()).toList(),
    };
  }
}
