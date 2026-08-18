abstract class ConnectivityService {
  Stream<bool> get connectionStream;

  Future<bool> get isConnected;

  Future<void> dispose();
}
