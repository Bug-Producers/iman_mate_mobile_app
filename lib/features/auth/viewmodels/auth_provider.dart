import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../repositories/auth_repository.dart';
import '../models/auth_models.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: "222170423521-7625ndo4fqjp5qfk31pklp57d87un9hj.apps.googleusercontent.com",
  );
});

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  FutureOr<UserModel?> build() async {
    final repository = ref.watch(authRepositoryProvider);
    await repository.checkAuthStatus();
    return repository.currentUser;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).login(email, password);
    });
  }

  Future<void> register(String email, String password, String fullName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).register(email, password, fullName);
    });
  }

  Future<void> googleSignIn() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final googleSignIn = ref.read(googleSignInProvider);
      final account = await googleSignIn.signIn();
      if (account == null) throw Exception('Google Sign-In cancelled');
      final googleAuth = await account.authentication;
      return await ref.read(authRepositoryProvider).googleSignIn(googleAuth.idToken!);
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(() {
  return AuthNotifier();
});