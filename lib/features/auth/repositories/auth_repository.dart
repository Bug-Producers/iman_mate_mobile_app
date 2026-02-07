import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_models.dart';
import '../services/auth_local_service.dart';
import '../services/auth_api_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref);
});

class AuthRepository {
  final Ref _ref;

  AuthRepository(this._ref);

  AuthApiService get _apiService => _ref.read(authApiServiceProvider);
  AuthLocalService get _localService => _ref.read(authLocalServiceProvider);

  Future<UserModel> login(String email, String password) async {
    final response = await _apiService.login(email, password);
    final user = UserModel.fromJson(response);
    await _localService.saveUser(user);
    return user;
  }

  Future<UserModel> register(String email, String password, String fullName) async {
    final response = await _apiService.register(email, password, fullName);
    final user = UserModel.fromJson(response);
    await _localService.saveUser(user);
    return user;
  }

  Future<UserModel> googleSignIn(String idToken) async {
    final response = await _apiService.googleSignIn(idToken);
    final user = UserModel.fromJson(response);
    await _localService.saveUser(user);
    return user;
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } finally {
      await _localService.clearUser();
    }
  }

  Future<bool> testConnection() async {
    try {
      final response = await _apiService.testConnection();
      return response['status'] == 'ok';
    } catch (_) {
      return false;
    }
  }

  Future<UserModel> fetchCurrentUser() async {
    final response = await _apiService.fetchCurrentUser();
    final user = UserModel.fromJson(response);
    await _localService.saveUser(user);
    return user;
  }

  Future<void> checkAuthStatus() async {
    await _localService.init();
  }

  UserModel? get currentUser => _localService.getUser();
  bool get isLoggedIn => _localService.isLoggedIn;
}