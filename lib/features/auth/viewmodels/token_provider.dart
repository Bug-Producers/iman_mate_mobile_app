import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../data/auth_local_service.dart';
import 'auth_provider.dart';

final tokenProvider = Provider<String?>((ref) {
  // Listen to Auth State changes
  final authState = ref.watch(authProvider);
  
  return authState.when(
    data: (user) {
      // Sync with DioClient
      DioClient().setToken(user?.token);
      return user?.token;
    },
    error: (_, __) {
      DioClient().setToken(null);
      return null;
    },
    loading: () {
      final token = AuthLocalService.instance.token;
      DioClient().setToken(token);
      return token;
    },
  );
});
