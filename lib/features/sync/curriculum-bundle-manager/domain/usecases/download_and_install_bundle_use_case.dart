import 'package:math_matric/features/sync/curriculum-bundle-manager/domain/repositories/curriculum_bundle_repository.dart';

class DownloadAndInstallBundleUseCase {
  final CurriculumBundleRepository repository;

  DownloadAndInstallBundleUseCase(this.repository);

  Future<void> call(String bundleId) async {
    return repository.downloadAndInstallBundle(bundleId);
  }
}
