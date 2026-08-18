import 'package:math_matric/features/sync/domain/entities/sync_progress.dart';

abstract class ContentSyncService {

  Stream<SyncProgress> synchronize();

  Future<bool> needsUpdate();

  Future<void> clearLocalContent();

}
