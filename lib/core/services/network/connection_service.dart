import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectionServiceProvider = Provider<ConnectionService>((ref) {
  return ConnectionService();
});

class ConnectionService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hasConnection() async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    return _isConnected(results);
  }

  Stream<bool> get onConnectionChange =>
      _connectivity.onConnectivityChanged.map(_isConnected);

  bool _isConnected(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }
}