import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/queries/curriculum/curriculum_bundle_queries.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/data/datasource/local/curriculum_bundle_local_data_source.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/domain/entities/curriculum_bundle.dart';

class CurriculumBundleLocalDataSourceImpl implements CurriculumBundleLocalDataSource {
  final AppDatabase db;
  CurriculumBundleLocalDataSourceImpl(this.db);

  @override
  Future<void> installBundle(
    CurriculumBundle bundle,
  ) async {
    final now = DateTime.now();

    await db.installCurriculumBundle(
      subjectsList: bundle.subjects
          .map((subject) => subject.toCompanion(
              version: bundle.info.version,
              updatedAt: now,
            ),
          )
          .toList(),

      topicsList: bundle.topics
          .map((topic) => topic.toCompanion(
              version: bundle.info.version,
              updatedAt: now,
            ),
          )
          .toList(),

      levelsList: bundle.levels
          .map((level) => level.toCompanion(
              version: bundle.info.version,
              updatedAt: now,
            ),
          )
          .toList(),

      questionsList: bundle.questions
          .map((question) => question.toCompanion(
              bundle.info.version,
              now,
            ),
          )
          .toList(),
       
      examPapersList: bundle.examPapers
          .map((paper) => paper.toCompanion(),)
          .toList(),
    );
  }
}

// installCurriculumBundle("grade12_math_v1")
//               ↓
//        get BundleInfo
//               ↓
//        download Bundle
//               ↓
//           Drift batch
//               ↓
//      save DownloadedBundle
