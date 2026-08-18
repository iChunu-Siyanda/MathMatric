import 'package:math_matric/features/sync/curriculum-bundle-manager/domain/entities/curriculum_bundle.dart';

abstract class CurriculumBundleLocalDataSource {
  Future<void> installBundle(CurriculumBundle bundle,);
}
