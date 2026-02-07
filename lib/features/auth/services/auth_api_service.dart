import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/network/dio_client.dart';
import '../../../core/services/network/dio_provider.dart';


final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService(ref);
});

class AuthApiService {
  final Ref _ref;

  AuthApiService(this._ref);

  DioClient get _dioClient => _ref.read(dioClientProvider);

  Future<dynamic> login(String email, String password) async {
    return await _dioClient.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<dynamic> register(String email, String password, String fullName) async {
    return await _dioClient.post(
      '/auth/register',
      data: {'email': email, 'password': password, 'full_name': fullName},
    );
  }

  Future<dynamic> googleSignIn(String idToken) async {
    return await _dioClient.post(
      '/auth/google/signin',
      data: {'id_token': idToken},
    );
  }

  Future<void> logout() async {
    try {
      await _dioClient.post('/auth/logout');
    } catch (_) {}
  }

  Future<dynamic> testConnection() async {
    return await _dioClient.get('/auth/test');
  }

  Future<dynamic> fetchCurrentUser() async {
    return await _dioClient.get('/auth/me');
  }
}