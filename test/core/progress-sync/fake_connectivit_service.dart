import 'package:math_matric/core/network/repositories/connectivity_service.dart';

class FakeConnectivityService implements ConnectivityService {
  bool connected = true;

  @override
  Stream<bool> get connectionStream => const Stream.empty();

  @override
  Future<bool> get isConnected async => connected;

  @override
  Future<void> dispose() async {}
}
