import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'connection_service.dart';

enum ConnectionStatus { connected, disconnected }

final connectionStatusProvider = StreamProvider<ConnectionStatus>((ref) {
  final service = ref.watch(connectionServiceProvider);

  return service.onConnectionChange.map((isConnected) {
    return isConnected ? ConnectionStatus.connected : ConnectionStatus.disconnected;
  });
});