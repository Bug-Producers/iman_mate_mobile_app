import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_local_service.dart';
import 'auth_provider.dart';

final tokenProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);

  return authState.maybeWhen(
    data: (user) => user?.token,
    orElse: () => ref.read(authLocalServiceProvider).token,
  );
});