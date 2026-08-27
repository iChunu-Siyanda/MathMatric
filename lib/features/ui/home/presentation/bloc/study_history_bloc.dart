import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:math_matric/features/ui/home/domain/entities/last_studied.dart';
import 'package:math_matric/features/ui/home/presentation/bloc/study_history_event.dart';
import 'package:math_matric/features/ui/home/presentation/bloc/study_history_state.dart';

class StudyHistoryBloc extends HydratedBloc<StudyHistoryEvent, StudyHistoryState> {
  StudyHistoryBloc() : super(const StudyHistoryState()) {
    on<TopicAccessed>((event, emit) {
      List<LastStudied> updated = List.from(state.recentTopics);
      updated.removeWhere((t) => t.title == event.topic.title);
      updated.insert(0, event.topic);
      emit(StudyHistoryState(recentTopics: updated));
    });
    on<RemoveTopicFromHistory>((event, emit) {
      final updated = List<LastStudied>.from(state.recentTopics)
        ..removeWhere((t) => t.title == event.title);
      emit(StudyHistoryState(recentTopics: updated));
    });
    on<ClearStudyHistory>((event, emit) async {
      emit(const StudyHistoryState(recentTopics: [])); // Clear in-memory state
      await clear(); // Wipes the HydratedBloc storage file from disk
    });
  }

  @override
  String get storagePrefix => 'StudyHistory';

  @override
  StudyHistoryState? fromJson(Map<String, dynamic> json) {
    try {
      final list = json['recentTopics'] as List?;
      if (list == null) return const StudyHistoryState();
      return StudyHistoryState(
        recentTopics: list.map((t) => LastStudied.fromJson(t)).toList(),
      );
    } catch (e) {
      // Fallback if cached JSON schema is invalid or contains old legacy data
      return const StudyHistoryState();
    }
  }

  // Called every time state changes to save data
  @override
  Map<String, dynamic>? toJson(StudyHistoryState state) {
    return {
      'recentTopics': state.recentTopics.map((t) => t.toJson()).toList(),
    };
  }
}
