import 'package:flutter/material.dart';
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
    debugPrint("[REPO] markLevelCompleted called -> topicId: '$topicId', levelId: '$levelId', xpEarned: $xpEarned");
    final completed = List<String>.from(await getCompletedLevels(topicId)); // List<String>.from(arr) creates a modifiable list of arr
    debugPrint("[REPO] Current completed list from storage: $completed");

    if (!completed.contains(levelId)) {
      
      completed.add(levelId);
      await prefs.setStringList('completed_$topicId', completed);

      await prefs.setInt('xp_$levelId', xpEarned);
      debugPrint("[REPO] Individual Level XP saved: xp_$levelId -> $xpEarned");
 
      final currentXp = await getEarnedXp(topicId);
      await prefs.setInt('xp_$topicId', currentXp + xpEarned);
      debugPrint("[REPO] Successfully saved new XP: ${currentXp + xpEarned}");
    } else {
      debugPrint("[REPO] Level '$levelId' already marked as completed for topic '$topicId'. No changes made.");
    }
  }

  @override
  Future<int> getEarnedXp(String topicId) async {
    final xp = prefs.getInt('xp_$topicId') ?? 0;
    debugPrint("[REPO] getEarnedXp read for '$topicId' -> Returning: $xp");
    return xp;
  }
  
  @override
  Future<int> getLevelXp(String levelId) async {
    final lxp = prefs.getInt('xp_$levelId') ?? 0;
    debugPrint("[REPO] getLevelXp read for '$levelId' -> Returning: $lxp");
    return lxp;
  }
}
