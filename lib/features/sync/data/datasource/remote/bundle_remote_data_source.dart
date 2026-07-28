import 'package:math_matric/features/sync/data/models/bundle_info_model.dart';
import 'package:math_matric/features/sync/domain/entities/curriculum_bundle.dart';

abstract class BundleRemoteDataSource {
  Future<BundleInfoModel?> getBundleInfo(
    String bundleId,
  );

  Future<CurriculumBundle> downloadBundle(
    String bundleId,
  );
}
