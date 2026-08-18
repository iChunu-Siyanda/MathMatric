import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:math_matric/core/network/repositories/connectivity_service.dart';
import 'package:math_matric/core/network/repositories/internet_checker.dart';
import 'package:math_matric/features/sync/user-data-progress/services/sync_progress_coordinator.dart';

class SyncProgressManager with WidgetsBindingObserver {
  final ConnectivityService connectivityService;
  final InternetChecker internetChecker;
  final SyncProgressCoordinator syncCoordinator;

  SyncProgressManager({
    required this.connectivityService,
    required this.internetChecker,
    required this.syncCoordinator,
  });

  StreamSubscription<bool>? _connectionSubscription;
  DateTime? _lastSync;
  bool _isSyncing = false;
  static const Duration syncCooldown = Duration(minutes: 10);



  Future<void> start() async {
    WidgetsBinding.instance.addObserver(this);

    _connectionSubscription = connectivityService.connectionStream.listen(
      _handleConnectionChange,
    );

    await _attemptSync();
  }

  Future<void> stop() async {
    WidgetsBinding.instance.removeObserver(this);

    await _connectionSubscription?.cancel();

    _connectionSubscription = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state,) {
    if (state == AppLifecycleState.resumed) {
      _attemptSync();
    }
  }

  Future<void> _handleConnectionChange(bool connected,) async {
    if (!connected) return;

    await _attemptSync();
  }

  Future<void> _attemptSync() async {
    if (_isSyncing) return;
    if (!_shouldSync()) return;

    final hasInternet = await internetChecker.hasInternet();

    if (!hasInternet) return;

    _isSyncing = true;

    try {
      await syncCoordinator.syncAll();

      _lastSync = DateTime.now();
    } catch (e, stackTrace) {
      debugPrint('Sync failed: $e');

      debugPrintStack(stackTrace: stackTrace,);
    } finally {
      _isSyncing = false;
    }
  }

  bool _shouldSync() {
    if (_lastSync == null) {
      return true;
    }

    return DateTime.now().difference(_lastSync!) >= syncCooldown;
  }
}