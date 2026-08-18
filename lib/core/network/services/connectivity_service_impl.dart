import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:math_matric/core/network/repositories/connectivity_service.dart';

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity connectivity;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  ConnectivityServiceImpl(this.connectivity) {_listen();}

  void _listen() {
    _subscription = connectivity.onConnectivityChanged.listen(
      (results) {
        final connected = results.any(
          (result) => result != ConnectivityResult.none,
        );

        _controller.add(connected);
      },
    );
  }

  @override
  Stream<bool> get connectionStream => _controller.stream;

  @override
  Future<bool> get isConnected async {
    final results = await connectivity.checkConnectivity();

    return results.any(
      (result) => result != ConnectivityResult.none,
    );
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _controller.close();
  }
}
