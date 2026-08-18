import 'package:math_matric/features/sync/domain/entities/curriculum_bundle.dart';

abstract class CurriculumBundleLocalDataSource {
  Future<void> installBundle(CurriculumBundle bundle,);
}
