import 'package:hive_flutter/hive_flutter.dart';
import '../models/prayer_models.dart';

class LocationLocalService {
  static const String _locationBoxName = 'user_location';

  Future<void> init() async {
    if (!Hive.isBoxOpen(_locationBoxName)) {
      await Hive.openBox<UserLocationModel>(_locationBoxName);
    }
  }

  Box<UserLocationModel> get _box => Hive.box<UserLocationModel>(_locationBoxName);

  Future<void> saveLocation(UserLocationModel location) async {
    await _box.put('current_location', location);
  }

  UserLocationModel? getLocation() {
    return _box.get('current_location');
  }
}
