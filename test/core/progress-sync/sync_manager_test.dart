import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/core/network/services/sync_progress_manager.dart';
import 'blocking_fake_sync_coordinator.dart';
import 'fake_connectivit_service.dart';
import 'fake_internet_checker.dart';
import 'fake_sync_coordinator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  //Test 1:
  test(
    //Given InternetChecker.hasInternet() returns false, SyncManager does not call SyncCoordinator.syncAll().
    'does not sync when there is no internet',
    () async {
      // Arrange:
      final connectivity = FakeConnectivityService();
      final internetChecker = FakeInternetChecker()..hasInternetResult = false;
      final coordinator = FakeSyncCoordinator();
      final manager = SyncProgressManager(
        connectivityService: connectivity,
        internetChecker: internetChecker,
        syncCoordinator: coordinator, 
      );

      // Act:
      await manager.start();

      // Assert:
      expect(
        coordinator.syncCount,
        0,
      );

      await manager.stop();
    },
  );

  //Test 2:
  test(
    'syncs when internet is available',
    () async {
      // Arrange:
      final connectivity = FakeConnectivityService();
      final internetChecker = FakeInternetChecker()..hasInternetResult = true;
      final coordinator = FakeSyncCoordinator();
      final manager = SyncProgressManager(
        connectivityService: connectivity,
        internetChecker: internetChecker,
        syncCoordinator: coordinator, 
      );

      //Act:
      await manager.start();

      //Assert:
      expect(
        coordinator.syncCount,
        1,
      );

      await manager.stop();
    },
  );

  test(
    'does not sync again within the 10 minute cooldown',
    () async {
      // Arrange
      var currentTime = DateTime(2026, 8, 18, 10, 0);

      final connectivity = FakeConnectivityService();

      final internetChecker = FakeInternetChecker()..hasInternetResult = true;

      final coordinator = FakeSyncCoordinator();

      final manager = SyncProgressManager(
        connectivityService: connectivity,
        internetChecker: internetChecker,
        syncCoordinator: coordinator,
        now: () => currentTime,
      );

      // Act
      await manager.start();

      // First sync should happen.
      expect(
        coordinator.syncCount,
        1,
      );

      // Move time forward by 5 minutes.
      currentTime = currentTime.add(
        const Duration(minutes: 5),
      );

      // Try syncing again.
      await manager.syncNow();

      // Assert
      expect(
        coordinator.syncCount,
        1,
      );

      await manager.stop();
    },
  );

  test(
    'does not start another sync while one is already running',
    () async {
      // Arrange:
      final connectivity = FakeConnectivityService();
      final internetChecker = FakeInternetChecker()..hasInternetResult = true;
      final coordinator = BlockingFakeSyncCoordinator();
      final manager = SyncProgressManager(
        connectivityService: connectivity,
        internetChecker: internetChecker,
        syncCoordinator: coordinator,
      );

      // Act:
      final firstSync = manager.start();

      // Wait until the first sync has actually started.
      await coordinator.syncStarted.future;

      expect(
        coordinator.syncCount,
        1,
      );

      // Try to trigger another sync while
      // the first one is still running.
      await manager.syncNow();

      // Assert:
      expect(
        coordinator.syncCount,
        1,
      );

      // Allow the first sync to finish.
      coordinator.allowSyncToFinish.complete();

      await firstSync;

      await manager.stop();
    },
  );
}
