import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/queries/levels_queries.dart';
import 'package:math_matric/features/curriculum/levels/data/datasource/local/levels_local_datasource.dart';
import 'package:math_matric/features/curriculum/levels/data/models/levels_model.dart';

class LevelsLocalDatasourceImpl implements LevelsLocalDatasource {
  final AppDatabase db;

  LevelsLocalDatasourceImpl(this.db);

  @override
  Future<List<LevelsModel>> getAllLevels() async {
    final rows = await db.getAllLevels();

    return rows
        .map(LevelsModel.fromDrift)
        .toList();
  }

  @override
  Future<LevelsModel?> getLevel(
    String levelId,
  ) async {
    final row = await db.getLevel(levelId);

    if (row == null) return null;

    return LevelsModel.fromDrift(row);
  }

  @override
  Future<List<LevelsModel>> getLevelsByTopic(
    String topicId,
  ) async {
    final rows = await db.getLevelsByTopic(
      topicId,
    );

    return rows
        .map(LevelsModel.fromDrift)
        .toList();
  }

  @override
  Future<void> saveLevels(
    List<LevelsModel> levels,
  ) async {
    await db.insertLevels(
      levels.map((level) => level.toCompanion(
          version: 1,
          updatedAt: DateTime.now(),
        ),
      )
      .toList(),
    );
  }

  @override
  Future<void> clearLevels() async {
    await db.clearLevels();
  }

  @override
  Future<int> deleteLevel(
    String levelId,
  ) {
    return db.deleteLevel(levelId);
  }
}
