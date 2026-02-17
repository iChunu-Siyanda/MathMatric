abstract class UserProgressRepository {
  Future<List<String>> getCompletedLevels(String topicId);

  Future<void> markLevelCompleted({
    required String topicId,
    required String levelId,
    required int xpEarned,
  });

  Future<int> getEarnedXp(String topicId);
}
