import 'package:flutter/foundation.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/domain/repositories/curriculum_bundle_repository.dart';
import 'package:math_matric/shared/registrations/ui/register_analytics_streak_module.dart';

class DevSeeder {
  static const String _targetBundleId = 'mathematics_grade12'; 

  // Call this inside main() during development to seed Drift from Firestore once.
  static Future<void> seedDatabaseOnce() async {
    if (!kDebugMode) return; // never runs in production

    try {
      debugPrint(' [DevSeeder] Starting dev bundle download from Firestore...');

      final repository = getIt<CurriculumBundleRepository>();
      await repository.downloadAndInstallBundle(_targetBundleId);

      debugPrint('[DevSeeder] Drift database seeded successfully!');
    } catch (e, stackTrace) {
      debugPrint('❌ [DevSeeder] Failed to seed database: $e');
      debugPrint(stackTrace.toString());
    }
  }
}
