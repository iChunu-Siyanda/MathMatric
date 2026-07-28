import 'package:math_matric/features/curriculum/levels/data/models/levels_model.dart';

abstract class LevelsRemoteDataSource {
  Future<List<LevelsModel>> getAllLevels();

  Future<LevelsModel?> getLevel(
    String levelId,
  );

  Future<List<LevelsModel>> getLevelsByTopic(
    String topicId,
  );
}
