import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:math_matric/core/network/repositories/connectivity_service.dart';
import 'package:math_matric/core/network/repositories/internet_checker.dart';
import 'package:math_matric/features/sync/user-data-progress/services/sync_progress_coordinator.dart';

typedef Now = DateTime Function();

class SyncProgressManager with WidgetsBindingObserver {
  final ConnectivityService connectivityService;
  final InternetChecker internetChecker;
  final SyncProgressCoordinator syncCoordinator;
  final Now now;

  SyncProgressManager({
    required this.connectivityService,
    required this.internetChecker,
    required this.syncCoordinator,
    Now? now,
  }): now = now ?? DateTime.now;

  StreamSubscription<bool>? _connectionSubscription;
  DateTime? _lastSync;
  bool _isSyncing = false;
  static const Duration syncCooldown = Duration(minutes: 10);
  bool _started = false; //Prevent duplicate connectivity subscriptions and duplicate startup syncs.

  Future<void> start() async {
    if(_started) return;
    _started = true;

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
  
  Future<void> syncNow() async {
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

      _lastSync = now();
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

    return now().difference(_lastSync!) >= syncCooldown;
  }
}
