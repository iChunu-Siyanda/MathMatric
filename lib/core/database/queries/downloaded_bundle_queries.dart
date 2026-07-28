import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';

extension DownloadedBundleQueries on AppDatabase {
  Future<List<DownloadedBundleData>> getAllDownloadedBundles() {
    return (select(downloadedBundle)
          ..orderBy([
            (b) => OrderingTerm.desc(b.downloadedAt),
          ]))
        .get();
  }

  Future<DownloadedBundleData?> getDownloadedBundle(
    String bundleId,
  ) {
    return (select(downloadedBundle)
          ..where((b) => b.id.equals(bundleId)))
        .getSingleOrNull();
  }

  Future<DownloadedBundleData?> getCurrentDownloadedBundle() {
    return (select(downloadedBundle)
          ..limit(1))
        .getSingleOrNull();
  }

  Future<DownloadedBundleData?> getLatestDownloadedBundle() {
    return (select(downloadedBundle)
          ..orderBy([
            (b) => OrderingTerm.desc(b.downloadedAt),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> getDownloadedBundleCount() async {
    final query = selectOnly(downloadedBundle)
      ..addColumns([downloadedBundle.id.count()]);

    final result = await query.getSingle();

    return result.read(downloadedBundle.id.count()) ?? 0;
  }

  Future<int> insertDownloadedBundle(
    DownloadedBundleCompanion bundle,
  ) {
    return into(downloadedBundle).insert(bundle);
  }

  Future<void> insertDownloadedBundles(
    List<DownloadedBundleCompanion> bundles,
  ) {
    return batch((batch) {
      batch.insertAll(downloadedBundle, bundles);
    });
  }

  Future<bool> updateDownloadedBundle(
    DownloadedBundleData bundle,
  ) {
    return update(downloadedBundle).replace(bundle);
  }

  Future<int> deleteDownloadedBundle(
    String bundleId,
  ) {
    return (delete(downloadedBundle)
          ..where((b) => b.id.equals(bundleId)))
        .go();
  }

  Future<int> clearDownloadedBundles() {
    return delete(downloadedBundle).go();
  }

  Future<bool> hasDownloadedBundles() async {
    final bundles = await getAllDownloadedBundles();

    return bundles.isNotEmpty;
  }
}
