import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/queries/curriculum/downloaded_bundle_queries.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/data/datasource/local/downloaded_bundle_local_data_source.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/data/models/downloaded_bundle_model.dart';

class DownloadedBundleLocalDataSourceImpl implements DownloadedBundleLocalDataSource {
  final AppDatabase db;
  DownloadedBundleLocalDataSourceImpl(this.db);

  @override
  Future<DownloadedBundleModel?> getBundle(
    String bundleId,
  ) async {
    final row = await db.getDownloadedBundle(bundleId);

    if (row == null) return null;

    return DownloadedBundleModel.fromDrift(row);
  }

  @override
  Future<void> saveBundle(
    DownloadedBundleModel bundle,
  ) async {
    await db.insertDownloadedBundle(
      bundle.toCompanion(),
    );
  }

  @override
  Future<void> clearBundle() async {
    await db.clearDownloadedBundles();
  }

  @override
  Future<int> deleteBundle(
    String bundleId,
  ) {
    return db.deleteDownloadedBundle(
      bundleId,
    );
  }
}
