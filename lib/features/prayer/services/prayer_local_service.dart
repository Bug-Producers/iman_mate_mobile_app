import 'package:hive_flutter/hive_flutter.dart';
import '../models/prayer_models.dart';
import '../models/performance_models.dart';

class PrayerLocalService {
  static const String _prayerBoxName = 'prayer_data';
  static const String _configBoxName = 'prayer_config';
  static const String _monthlyBoxName = 'monthly_summary';

  Future<void> init() async {
    if (!Hive.isBoxOpen(_prayerBoxName)) {
      await Hive.openBox<PrayerDayModel>(_prayerBoxName);
    }
    if (!Hive.isBoxOpen(_configBoxName)) {
      await Hive.openBox<PrayerScoreConfigModel>(_configBoxName);
    }
    if (!Hive.isBoxOpen(_monthlyBoxName)) {
      await Hive.openBox<MonthlySummaryModel>(_monthlyBoxName);
    }
  }

  Box<PrayerDayModel> get _prayerBox => Hive.box<PrayerDayModel>(_prayerBoxName);

  Future<void> savePrayerDay(PrayerDayModel day) async {
    final key = _getDateKey(day.date);
    await _prayerBox.put(key, day);
  }

  PrayerDayModel? getPrayerDay(DateTime date) {
    final key = _getDateKey(date);
    return _prayerBox.get(key);
  }

  List<PrayerDayModel> getDaysForMonth(int month, int year) {
    return _prayerBox.values.where((day) {
      return day.date.month == month && day.date.year == year;
    }).toList();
  }

  Box<PrayerScoreConfigModel> get _configBox => Hive.box<PrayerScoreConfigModel>(_configBoxName);

  Future<void> saveConfig(PrayerScoreConfigModel config) async {
    await _configBox.put('config', config);
  }

  PrayerScoreConfigModel getConfig() {
    return _configBox.get('config') ?? PrayerScoreConfigModel();
  }

  Box<MonthlySummaryModel> get _monthlyBox => Hive.box<MonthlySummaryModel>(_monthlyBoxName);

  Future<void> saveMonthlySummary(MonthlySummaryModel summary) async {
    final key = '${summary.year}-${summary.month}';
    await _monthlyBox.put(key, summary);
  }

  MonthlySummaryModel? getMonthlySummary(int month, int year) {
    final key = '$year-$month';
    return _monthlyBox.get(key);
  }

  String _getDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
