import 'package:hive_flutter/hive_flutter.dart';
import 'models/auth_models.dart';

class AuthLocalService {
  static const String _boxName = 'auth_box';
  static const String _userKey = 'user_data';

  AuthLocalService._();
  static final AuthLocalService instance = AuthLocalService._();

  Box? _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  Future<void> saveUser(UserModel user) async {
    if (_box == null) await init();
    await _box!.put(_userKey, user.toJson());
  }

  UserModel? getUser() {
    if (_box == null) return null;
    
    final data = _box!.get(_userKey);
    if (data != null && data is Map) {
      return UserModel.fromJson(data);
    }
    return null;
  }

  Future<void> clearUser() async {
    if (_box == null) await init();
    await _box!.delete(_userKey);
  }

  String? get token => getUser()?.token;
  
  bool get isLoggedIn => token != null && token!.isNotEmpty;
}
