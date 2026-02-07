import 'package:geolocator/geolocator.dart';
import '../models/prayer_models.dart';
import '../models/performance_models.dart';
import '../services/prayer_local_service.dart';
import '../services/prayer_api_service.dart';
import '../services/location_service.dart';

class PrayerRepository {
  final PrayerLocalService _localService;
  final LocationLocalService _locationService;
  final PrayerApiService _apiService;

  PrayerRepository(
    this._localService,
    this._locationService,
    this._apiService,
  );

  Future<void> init() async {
    await _localService.init();
    await _locationService.init();
  }

  Future<void> transformAndSavePrayers(
      int month, int year, Map<String, PrayerTimesModel> apiData) async {
    for (var dateStr in apiData.keys) {
      final date = DateTime.parse(dateStr);
      final existing = _localService.getPrayerDay(date);
      
      final prayerDay = existing?.copyWith(timings: apiData[dateStr]) ??
          PrayerDayModel(
            date: date,
            timings: apiData[dateStr]!,
            statuses: {
              'Fajr': PrayerStatus.none,
              'Dhuhr': PrayerStatus.none,
              'Asr': PrayerStatus.none,
              'Maghrib': PrayerStatus.none,
              'Isha': PrayerStatus.none,
            },
          );
      
      await _localService.savePrayerDay(prayerDay);
    }
  }

  Future<void> checkLocationAndFetchIfNeeded() async {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      // Ignored
    }

    if (position == null) return;

    final userLoc = UserLocationModel(
      lat: position.latitude,
      lng: position.longitude,
      timestamp: DateTime.now(),
    );

    final lastLoc = _locationService.getLocation();
    bool shouldFetch = false;

    if (lastLoc == null) {
      shouldFetch = true;
    } else {
      final distance = Geolocator.distanceBetween(
        lastLoc.lat,
        lastLoc.lng,
        userLoc.lat,
        userLoc.lng,
      );
      if (distance > 15000) {
        shouldFetch = true;
      }
    }
    
    final today = DateTime.now();
    for (int i = 0; i < 5; i++) {
        final date = today.add(Duration(days: i));
        if (_localService.getPrayerDay(date) == null) {
            shouldFetch = true;
            break;
        }
    }

    if (shouldFetch) {
      await _fetchAndSave(userLoc.lat, userLoc.lng);
      await _locationService.saveLocation(userLoc);
    }
  }

  Future<void> _fetchAndSave(double lat, double lng) async {
    final now = DateTime.now();
    final data = await _apiService.getPrayerTimesCalendar(lat, lng, now.month, now.year);
    await transformAndSavePrayers(now.month, now.year, data);
    
    if (now.day > 25) {
       final nextMonth = now.month == 12 ? 1 : now.month + 1;
       final nextYear = now.month == 12 ? now.year + 1 : now.year;
       final dataNext = await _apiService.getPrayerTimesCalendar(lat, lng, nextMonth, nextYear);
       await transformAndSavePrayers(nextMonth, nextYear, dataNext);
    }
  }

  Future<void> markPrayer(DateTime date, String prayerName, PrayerStatus status) async {
    final day = _localService.getPrayerDay(date);
    if (day == null) return;

    final newStatuses = Map<String, PrayerStatus>.from(day.statuses);
    newStatuses[prayerName] = status;

    final config = _localService.getConfig();
    double score = 0;
    
    newStatuses.forEach((key, value) {
      switch (value) {
        case PrayerStatus.onTime:
          score += config.onTimePoints;
          break;
        case PrayerStatus.late:
          score += config.latePoints;
          break;
        case PrayerStatus.missed:
          score += config.missedPoints;
          break;
        case PrayerStatus.none:
          break;
      }
    });

    final updatedDay = day.copyWith(statuses: newStatuses, dailyScore: score);
    await _localService.savePrayerDay(updatedDay);

    await _recalculateMonthly(date.month, date.year);
  }

  Future<void> _recalculateMonthly(int month, int year) async {
    final days = _localService.getDaysForMonth(month, year);
    double totalScore = 0;
    
    final config = _localService.getConfig();
    double maxPointsPerDay = 5 * config.onTimePoints; 
    
    double totalMaxPoints = days.length * maxPointsPerDay;
    if (totalMaxPoints == 0) totalMaxPoints = 1;

    for (var day in days) {
      totalScore += day.dailyScore;
    }
    
    double percentage = (totalScore / totalMaxPoints) * 100;
    
    int level = 1;
    if (percentage > 90) level = 6;
    else if (percentage > 70) level = 5;
    else if (percentage > 60) level = 4;
    else if (percentage > 40) level = 3;
    else if (percentage > 20) level = 2;
    
    final summary = MonthlySummaryModel(
      month: month,
      year: year,
      totalScore: totalScore,
      level: level,
    );
    
    await _localService.saveMonthlySummary(summary);
  }
}
