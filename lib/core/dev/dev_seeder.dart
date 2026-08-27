import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:math_matric/core/constants/bundle_ids.dart';
import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/domain/repositories/curriculum_bundle_repository.dart';
import 'package:math_matric/shared/registrations/dependencies/register_app_database_module.dart';

class DevSeeder {
  static const String _targetBundleId = BundleIds.mathematicsBundleId;

  static Future<void> seedDatabaseOnce() async {
    if (!kDebugMode) return;

    try {
      final auth = FirebaseAuth.instance;

      // 1. Authenticate if no active user
      if (auth.currentUser == null) {
        debugPrint('🔑 [DevSeeder] Signing in anonymously for dev seeding...');
        final credential = await auth.signInAnonymously();
        debugPrint('✅ [DevSeeder] Signed in as UID: ${credential.user?.uid}');
      } else {
        debugPrint('🔑 [DevSeeder] Using active auth session (UID: ${auth.currentUser?.uid})');
      }

      // 2. Allow Firestore a tiny tick to register the active auth state
      await Future.delayed(const Duration(milliseconds: 100));

      final db = getIt<AppDatabase>();
      final alreadySeeded = await db.hasCurriculumData();

      if (alreadySeeded) {
        debugPrint('📦 [DevSeeder] Drift DB already contains data. Skipping seed.');
        return;
      }

      debugPrint('🌱 [DevSeeder] DB is empty. Downloading dev bundle from Firestore...');

      // 3. Download and install
      final repository = getIt<CurriculumBundleRepository>();
      await repository.downloadAndInstallBundle(_targetBundleId);

      debugPrint('🎉 [DevSeeder] Drift database seeded successfully!');
    } catch (e, stackTrace) {
      debugPrint('❌ [DevSeeder] Failed to seed database: $e');
      debugPrint(stackTrace.toString());
    }
  }
}
