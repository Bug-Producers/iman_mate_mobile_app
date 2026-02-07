import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../services/auth_local_service.dart';

class AuthRepository {
  final DioClient _dioClient;
  final AuthLocalService _localService;

  AuthRepository({
    required DioClient dioClient,
    required AuthLocalService localService,
  })  : _dioClient = dioClient,
        _localService = localService;

  Future<UserModel> login(String email, String password) async {
    try {
      final data = await _dioClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      final user = UserModel.fromJson(data);
      await _localService.saveUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> register(String email, String password, String fullName) async {
    try {
      final data = await _dioClient.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'full_name': fullName,
        },
      );

      final user = UserModel.fromJson(data);
      await _localService.saveUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }
  
  Future<UserModel> googleSignIn(String idToken) async {
     try {
      final data = await _dioClient.post(
        '/auth/google/signin',
        data: {'id_token': idToken},
      );

      final user = UserModel.fromJson(data);
      await _localService.saveUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // Call backend to invalidate token
      await _dioClient.post('/auth/logout');
    } catch (e) {
      // Continue to clear local storage even if backend fails
      print('Logout API failed: $e');
    } finally {
      await _localService.clearUser();
    }
  }

  Future<bool> testConnection() async {
    try {
      final response = await _dioClient.get('/auth/test');
      return response['status'] == 'ok'; // Assuming backend returns {status: "ok"}
    } catch (e) {
      return false;
    }
  }

  Future<UserModel> fetchCurrentUser() async {
    try {
      final data = await _dioClient.get('/auth/me');
      final user = UserModel.fromJson(data);
      // Update local storage with fresh data
      await _localService.saveUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkAuthStatus() async {
    await _localService.init();
    // Optional: Verify token validity on startup
    // if (isLoggedIn) {
    //   try { await fetchCurrentUser(); } catch (_) { await logout(); }
    // }
  }

  UserModel? get currentUser => _localService.getUser();
  bool get isLoggedIn => _localService.isLoggedIn;
}
