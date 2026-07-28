import 'package:math_matric/features/curriculum/levels/domain/entities/levels_entity.dart';

abstract class LevelsRepository {
  Future<List<LevelsEntity>> getAllLevels();

  Future<LevelsEntity?> getLevel(
    String levelId,
  );

  Future<List<LevelsEntity>> getLevelsByTopic(
    String topicId,
  );
}
