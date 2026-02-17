import 'package:math_matric/features/papers/domain/respositories/user_progress_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUserProgressRepository implements UserProgressRepository {
  final SharedPreferences prefs;

  LocalUserProgressRepository(this.prefs);

  @override
  Future<List<String>> getCompletedLevels(String topicId) async {
    return prefs.getStringList('completed_$topicId') ?? [];
  }

  @override
  Future<void> markLevelCompleted({
    required String topicId,
    required String levelId,
    required int xpEarned,
  }) async {
    final completed = await getCompletedLevels(topicId);

    if (!completed.contains(levelId)) {
      completed.add(levelId);
      await prefs.setStringList('completed_$topicId', completed);

      final currentXp = await getEarnedXp(topicId);
      await prefs.setInt('xp_$topicId', currentXp + xpEarned);
    }
  }

  @override
  Future<int> getEarnedXp(String topicId) async {
    return prefs.getInt('xp_$topicId') ?? 0;
  }
}
