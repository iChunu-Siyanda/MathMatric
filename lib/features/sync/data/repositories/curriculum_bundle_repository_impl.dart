import 'package:math_matric/features/sync/data/datasource/local/curriculum_bundle_local_data_source.dart';
import 'package:math_matric/features/sync/data/datasource/local/downloaded_bundle_local_data_source.dart';
import 'package:math_matric/features/sync/data/datasource/remote/bundle_remote_data_source.dart';
import 'package:math_matric/features/sync/data/models/downloaded_bundle_model.dart';
import 'package:math_matric/features/sync/domain/repositories/curriculum_bundle_repository.dart';

class CurriculumBundleRepositoryImpl implements CurriculumBundleRepository {
  final BundleRemoteDataSource remote;
  final CurriculumBundleLocalDataSource curriculumLocal;
  final DownloadedBundleLocalDataSource bundleLocal;


  CurriculumBundleRepositoryImpl({
    required this.remote, 
    required this.curriculumLocal,
    required this.bundleLocal,
  });

  @override
  Future<void> downloadAndInstallBundle(
    String bundleId,
  ) async {
    // 1. Get the latest bundle information from Firebase.
    final remoteInfo = await remote.getBundleInfo(bundleId);

    if (remoteInfo == null) {
      throw Exception('Bundle $bundleId not found.',);
    }

    // 2. Check whether this bundle is already installed.
    final localBundle = await bundleLocal.getBundle(bundleId);

    // 3. Already have the latest version.
    if (localBundle != null && localBundle.version >= remoteInfo.version) {
      return;
    }

    // 4. Download the complete bundle.
    final bundle = await remote.downloadBundle(bundleId);

    // 5. Install everything into Drift.
    await curriculumLocal.installBundle(bundle);

    // 6. Only mark it installed AFTER
    //    the curriculum transaction succeeds.
    await bundleLocal.saveBundle(
      DownloadedBundleModel(
        id: bundle.info.id,
        version: bundle.info.version,
        downloadedAt: DateTime.now(),
      ),
    );
  }
}
