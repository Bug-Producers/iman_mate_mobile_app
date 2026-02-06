import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String authBoxName = 'authBox';
  static const String tokenKey = 'token';
  static const String userKey = 'user';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(authBoxName);
  }

  static Box get authBox => Hive.box(authBoxName);

  static Future<void> saveToken(String token) async {
    await authBox.put(tokenKey, token);
  }

  static String? getToken() {
    return authBox.get(tokenKey);
  }

  static Future<void> deleteToken() async {
    await authBox.delete(tokenKey);
  }

   static Future<void> saveUser(Map<String, dynamic> userJson) async {
    await authBox.put(userKey, userJson);
  }

  static Map<dynamic, dynamic>? getUser() {
    return authBox.get(userKey);
  }
  
  static Future<void> deleteUser() async {
    await authBox.delete(userKey);
  }

  static Future<void> clearAll() async {
    await authBox.clear();
  }
}
