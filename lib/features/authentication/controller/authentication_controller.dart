import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
}

class AuthenticationController extends StateNotifier<AuthStatus> {
  AuthenticationController() : super(AuthStatus.initial);

  Future<void> checkAuth() async {
    try {
      await Future.delayed(const Duration(seconds: 2)); 
      
      var box = await Hive.openBox("authentication");

      final isAuth = box.get('isAuth', defaultValue: false);
      
      if (isAuth.toString() == "true") {
        state = AuthStatus.authenticated;
      } else {
        state = AuthStatus.unauthenticated;
      }
    } catch (e) {
      state = AuthStatus.unauthenticated;
    }
  }

  Future<void> login() async {
    state = AuthStatus.authenticated;
    var box = await Hive.openBox("authentication");
    await box.put('isAuth', "true");
  }

  Future<void> logout() async {
    state = AuthStatus.unauthenticated;
    var box = await Hive.openBox("authentication");
    await box.put('isAuth', "false");
  }
}

final authenticationControllerProvider = 
    StateNotifierProvider<AuthenticationController, AuthStatus>((ref) {
  return AuthenticationController();
});