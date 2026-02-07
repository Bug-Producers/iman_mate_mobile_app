import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iman_mate_mobile_app/features/prayer/repositories/prayer_repository.dart';
import 'package:iman_mate_mobile_app/features/prayer/services/prayer_local_service.dart';
import 'package:iman_mate_mobile_app/features/prayer/services/location_service.dart';
import 'package:iman_mate_mobile_app/features/prayer/services/prayer_api_service.dart';
import 'package:iman_mate_mobile_app/features/prayer/models/prayer_models.dart';
import 'package:iman_mate_mobile_app/features/prayer/models/performance_models.dart';

void main() {
  late PrayerRepository repository;
  late PrayerLocalService localService;
  late LocationLocalService locationService;
  late PrayerApiService apiService;

  setUpAll(() async {
    // Initialize Hive for testing (in memory)
    Hive.init('./test/hive_test_data');
    if (!Hive.isAdapterRegistered(10)) Hive.registerAdapter(UserLocationModelAdapter());
    if (!Hive.isAdapterRegistered(11)) Hive.registerAdapter(PrayerTimesModelAdapter());
    if (!Hive.isAdapterRegistered(12)) Hive.registerAdapter(PrayerStatusAdapter());
    if (!Hive.isAdapterRegistered(13)) Hive.registerAdapter(PrayerDayModelAdapter());
    if (!Hive.isAdapterRegistered(14)) Hive.registerAdapter(MonthlySummaryModelAdapter());
    if (!Hive.isAdapterRegistered(15)) Hive.registerAdapter(PrayerScoreConfigModelAdapter());
  });

  setUp(() async {
    localService = PrayerLocalService();
    locationService = LocationLocalService();
    
    // Use Real Dio for Real API
    final dio = Dio();
    apiService = PrayerApiService(dio);
    
    repository = PrayerRepository(localService, locationService, apiService);

    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  test('Integration Test: Fetch from Real API and Save', () async {
    // 1. Fetch Data using real coordinates (Cairo)
    // http://localhost:8000/api/v1/prayer/times-month?lat=30.0444&lng=31.2357
    
    // We can't control the 'checkLocationAndFetchIfNeeded' internal logic easily 
    // regarding the 15km check without mocking location service, 
    // but we can call _fetchAndSave's logic directly via public method if exposed, 
    // OR we can simulate the condition.
    
    // Ideally we'd test the API service call directly first to ensure connectivity.
    final now = DateTime.now();
    print('--------------------------------------------------');
    print('Fetching Prayer Times for ${now.month}/${now.year}...');
    final apiData = await apiService.getPrayerTimesCalendar(30.0444, 31.2357, now.month, now.year);
    
    print('Received ${apiData.length} days from API.');
    expect(apiData, isNotEmpty);
    expect(apiData.keys.first, contains('2026')); // Assuming the API returns 2026 dates as per previous data
    
    // 2. Save Data via Repository Logic
    print('Saving data to local storage...');
    await repository.transformAndSavePrayers(now.month, now.year, apiData);
    
    // 3. Verify Local Storage
    final firstKey = apiData.keys.first; 
    final date = DateTime.parse(firstKey);
    final savedDay = localService.getPrayerDay(date);
    
    print('Verifying saved data for $firstKey:');
    print('  - Fajr: ${savedDay!.timings.fajr}');
    print('  - Dhuhr: ${savedDay.timings.dhuhr}');
    print('  - Asr: ${savedDay.timings.asr}');
    print('  - Maghrib: ${savedDay.timings.maghrib}');
    print('  - Isha: ${savedDay.timings.isha}');
    
    expect(savedDay, isNotNull);
    expect(savedDay.timings.fajr, isNotNull);
    expect(savedDay.timings.fajr, apiData[firstKey]!.fajr);
    
    // 4. Test Marking Prayer on Real Data
    print('Marking Fajr as On Time...');
    await repository.markPrayer(date, 'Fajr', PrayerStatus.onTime);
    
    final updatedDay = localService.getPrayerDay(date);
    print('Updated Status for Fajr: ${updatedDay!.statuses['Fajr']}');
    print('New Daily Score: ${updatedDay.dailyScore}');
    print('--------------------------------------------------');
    
    expect(updatedDay.statuses['Fajr'], PrayerStatus.onTime);
    expect(updatedDay.dailyScore, greaterThan(0));
  });
}
