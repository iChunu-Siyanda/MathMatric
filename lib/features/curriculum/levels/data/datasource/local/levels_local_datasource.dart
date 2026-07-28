import 'package:math_matric/features/curriculum/levels/data/models/levels_model.dart';

abstract class LevelsLocalDatasource {
  Future<List<LevelsModel>> getAllLevels();

  Future<LevelsModel?> getLevel(
    String levelId,
  );

  Future<List<LevelsModel>> getLevelsByTopic(
    String topicId,
  );

  Future<void> saveLevels(
    List<LevelsModel> levels,
  );

  Future<void> clearLevels();

  Future<int> deleteLevel(
    String levelId,
  );
}
