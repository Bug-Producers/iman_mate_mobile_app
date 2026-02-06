import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/network/dio_client.dart';
import '../data/auth_local_service.dart';
import '../data/auth_repository.dart';
import '../data/models/auth_models.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dioClient: DioClient(),
    localService: AuthLocalService.instance,
  );
});

class AuthNotifier extends AsyncNotifier<UserModel?> {
  late final AuthRepository _repository;

  @override
  FutureOr<UserModel?> build() async {
    _repository = ref.read(authRepositoryProvider);
    await _repository.checkAuthStatus();
    return _repository.currentUser;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _repository.login(email, password);
    });
  }

  Future<void> register(String email, String password, String fullName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _repository.register(email, password, fullName);
    });
  }

  Future<void> googleSignIn() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        clientId: "222170423521-7625ndo4fqjp5qfk31pklp57d87un9hj.apps.googleusercontent.com",
      );
      
      final account = await googleSignIn.signIn();
      if (account == null) throw Exception('Google Sign-In cancelled');
      
      final googleAuth = await account.authentication;
      final idToken = googleAuth.idToken;
      
      if (idToken == null) throw Exception('Failed to retrieve Google ID Token');
      
      return await _repository.googleSignIn(idToken);
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await _repository.logout();
    state = const AsyncValue.data(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(() {
  return AuthNotifier();
});
