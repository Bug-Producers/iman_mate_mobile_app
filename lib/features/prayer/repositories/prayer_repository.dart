import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
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

  // --- Core Sync Logic ---

  Future<void> transformAndSavePrayers(
      int month, int year, Map<String, PrayerTimesModel> apiData) async {
    // Save each day
    for (var dateStr in apiData.keys) {
      // dateStr is YYYY-MM-DD
      // but api key format is DD-MM-YYYY if from my previous logic?
      // Wait, in api service I parse it.
      // Let's assume apiData keys are "YYYY-MM-DD"
      
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
    // 1. Check Location
    // Simple check: get current position. 
    // In real app, handle permissions properly.
    
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      // Handle permission/service errors or fallback to cached
      print("Error getting location: $e");
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
      if (distance > 15000) { // 15 km
        shouldFetch = true;
      }
    }
    
    // Check if we have data for next 5 days
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
    // Fetch this month
    final data = await _apiService.getPrayerTimesCalendar(lat, lng, now.month, now.year);
    // Be careful with parsing keys from API service, ensuring they match "YYYY-MM-DD"
    // I need to make sure the keys in apiData match what I expect.
    // In api service I tried to format them as YYYY-MM-DD.
    
    // keys in data are already YYYY-MM-DD or similar?
    // In api service: result[dateKey] = model; where dateKey is YYYY-MM-DD.
    
    // We might need next month too if today is end of month
    await transformAndSavePrayers(now.month, now.year, data);
    
    if (now.day > 25) {
       final nextMonth = now.month == 12 ? 1 : now.month + 1;
       final nextYear = now.month == 12 ? now.year + 1 : now.year;
       final dataNext = await _apiService.getPrayerTimesCalendar(lat, lng, nextMonth, nextYear);
       await transformAndSavePrayers(nextMonth, nextYear, dataNext);
    }
  }

  // --- Status & Scoring ---

  Future<void> markPrayer(DateTime date, String prayerName, PrayerStatus status) async {
    final day = _localService.getPrayerDay(date);
    if (day == null) return;

    final newStatuses = Map<String, PrayerStatus>.from(day.statuses);
    newStatuses[prayerName] = status;

    // Recalculate daily score
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

    // Recalculate monthly
    await _recalculateMonthly(date.month, date.year);
  }

  Future<void> _recalculateMonthly(int month, int year) async {
    final days = _localService.getDaysForMonth(month, year);
    double totalScore = 0;
    int prayersCount = 0; // Or just use score?
    // Requirements: "Define 6 levels... based on performance (e.g., % of prayers on time)"
    // Or points? "each On time... will has point... gets the avg"
    
    // User said: "make sure each On time Late Missed / Didn’t pray will has point... gets the avg for the whole mo like the gpa"
    
    // Let's use points directly or % of max possible points?
    // GPA implies average.
    // Max points per day = 5 * onTimePoints.
    
    final config = _localService.getConfig();
    double maxPointsPerDay = 5 * config.onTimePoints; 
    // Assuming 5 prayers.
    
    double totalMaxPoints = days.length * maxPointsPerDay;
    if (totalMaxPoints == 0) totalMaxPoints = 1; // avoid div by 0

    for (var day in days) {
      totalScore += day.dailyScore;
    }
    
    // Calculate percentage or average
    // Level based on %?
    // Level 1: 0-20%, Level 2: 21-40%, etc.
    
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
