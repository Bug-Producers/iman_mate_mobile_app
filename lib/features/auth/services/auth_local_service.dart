import 'package:hive_flutter/hive_flutter.dart';
import '../models/auth_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authLocalServiceProvider = Provider<AuthLocalService>((ref) {
  return AuthLocalService();
});

class AuthLocalService {
  static const String _boxName = 'auth_box';
  static const String _userKey = 'user_data';

  Box? get _box => Hive.isBoxOpen(_boxName) ? Hive.box(_boxName) : null;

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  Future<void> saveUser(UserModel user) async {
    await init();
    await Hive.box(_boxName).put(_userKey, user.toJson());
  }

  UserModel? getUser() {
    final box = _box;
    if (box == null) return null;
    final data = box.get(_userKey);
    if (data != null && data is Map) {
      return UserModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<void> clearUser() async {
    await init();
    await Hive.box(_boxName).delete(_userKey);
  }

  String? get token => getUser()?.token;

  bool get isLoggedIn => token != null && token!.isNotEmpty;
}