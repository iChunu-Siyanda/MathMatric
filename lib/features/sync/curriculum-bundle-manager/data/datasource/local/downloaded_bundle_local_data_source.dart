import 'package:math_matric/features/sync/curriculum-bundle-manager/data/models/downloaded_bundle_model.dart';

abstract class DownloadedBundleLocalDataSource {
  Future<DownloadedBundleModel?> getBundle(String bundleId);

  Future<void> saveBundle(
    DownloadedBundleModel bundle,
  );

  Future<void> clearBundle();

  Future<int> deleteBundle(
    String bundleId,
  );
}
