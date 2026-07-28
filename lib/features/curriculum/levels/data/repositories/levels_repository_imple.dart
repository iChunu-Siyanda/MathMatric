import 'package:math_matric/features/curriculum/levels/data/datasource/local/levels_local_datasource.dart';
import 'package:math_matric/features/curriculum/levels/domain/entities/levels_entity.dart';
import 'package:math_matric/features/curriculum/levels/domain/repositories/levels_repository.dart';

class LevelsRepositoryImpl  implements LevelsRepository {
  final LevelsLocalDatasource local;

  LevelsRepositoryImpl(this.local);

  @override
  Future<List<LevelsEntity>> getAllLevels() async {
    final models = await local.getAllLevels();

    return models
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<LevelsEntity?> getLevel(
    String levelId,
  ) async {
    final model = await local.getLevel(
      levelId,
    );

    return model?.toEntity();
  }

  @override
  Future<List<LevelsEntity>> getLevelsByTopic(
    String topicId,
  ) async {
    final models = await local.getLevelsByTopic(
      topicId,
    );

    return models
        .map((m) => m.toEntity())
        .toList();
  }
}
