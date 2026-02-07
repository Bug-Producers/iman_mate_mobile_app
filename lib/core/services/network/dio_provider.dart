import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/viewmodels/token_provider.dart';
import 'dio_client.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  final client = DioClient();

  ref.listen<String?>(
    tokenProvider,
        (previous, next) {
      client.setToken(next);
    },
    fireImmediately: true,
  );

  return client;
});