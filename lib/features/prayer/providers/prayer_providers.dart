import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/prayer_models.dart';
import '../models/performance_models.dart';
import '../services/prayer_local_service.dart';
import '../services/location_service.dart';
import '../services/prayer_api_service.dart';
import '../repositories/prayer_repository.dart';
import '../../../core/services/network/dio_provider.dart';

// --- Services ---

final prayerLocalServiceProvider = Provider<PrayerLocalService>((ref) {
  return PrayerLocalService();
});

final locationLocalServiceProvider = Provider<LocationLocalService>((ref) {
  return LocationLocalService();
});

final prayerApiServiceProvider = Provider<PrayerApiService>((ref) {
  final dio = ref.watch(dioClientProvider);
  return PrayerApiService(dio.dio);
});

// --- Repository ---

final prayerRepositoryProvider = Provider<PrayerRepository>((ref) {
  final local = ref.watch(prayerLocalServiceProvider);
  final location = ref.watch(locationLocalServiceProvider);
  final api = ref.watch(prayerApiServiceProvider);
  
  return PrayerRepository(local, location, api);
});

// --- Initialization ---

final prayerInitProvider = FutureProvider<void>((ref) async {
  final repo = ref.read(prayerRepositoryProvider);
  await repo.init();
  await repo.checkLocationAndFetchIfNeeded();
});

// --- Data Providers ---

final todayPrayerProvider = StateProvider<PrayerDayModel?>((ref) {
  final local = ref.watch(prayerLocalServiceProvider);
  // This needs to be reactive. 
  // We can't easily watch Hive box without ValueListenableBuilder or Stream.
  // We'll rely on manual refresh/invalidation when actions happen.
  return local.getPrayerDay(DateTime.now());
});

// Stream that updates every minute to check for prayer changes
final nextPrayerProvider = StreamProvider<Map<String, dynamic>>((ref) async* {
  // refresh today's data if needed?
  // We just rely on todayPrayerProvider.
  
  // We yield every second for "Remaining Time"
  while (true) {
    // Re-read today's data in case it changed (though unlikely for *timings*)
    final local = ref.read(prayerLocalServiceProvider);
    final today = local.getPrayerDay(DateTime.now());

    if (today == null) {
       yield {'name': 'Loading...', 'time': null, 'remaining': Duration.zero};
       await Future.delayed(const Duration(seconds: 1));
       continue;
    }

    final now = DateTime.now();
    final timings = today.timings;
    
    DateTime parseTime(String t) {
         final parts = t.split(':');
         return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
    }
      
    final Map<String, DateTime> prayers = {
        'Fajr': parseTime(timings.fajr),
        'Dhuhr': parseTime(timings.dhuhr),
        'Asr': parseTime(timings.asr),
        'Maghrib': parseTime(timings.maghrib),
        'Isha': parseTime(timings.isha),
    };

    String nextName = 'Fajr';
    DateTime nextTime = prayers['Fajr']!.add(const Duration(days: 1));

    // Find first prayer strictly after now
    for (var entry in prayers.entries) {
        if (entry.value.isAfter(now)) {
          nextName = entry.key;
          nextTime = entry.value;
          break;
        }
    }
      
    final remaining = nextTime.difference(now);
      
    yield {
        'name': nextName,
        'time': nextTime,
        'remaining': remaining,
    };

    await Future.delayed(const Duration(seconds: 1));
  }
});

// --- Performance ---

final dailyPerformanceProvider = Provider.family<PrayerDayModel?, DateTime>((ref, date) {
    final local = ref.watch(prayerLocalServiceProvider);
    return local.getPrayerDay(date);
});

final monthlyPerformanceProvider = Provider.family<MonthlySummaryModel?, DateTime>((ref, date) {
    final local = ref.watch(prayerLocalServiceProvider);
// --- Configuration ---

final scoreConfigProvider = Provider<PrayerScoreConfigModel>((ref) {
    final local = ref.watch(prayerLocalServiceProvider);
    return local.getConfig();
});

// --- Actions / Controllers ---

class PrayerStateNotifier extends StateNotifier<AsyncValue<void>> {
  final PrayerRepository _repo;
  PrayerStateNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> markPrayer(DateTime date, String prayerName, PrayerStatus status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.markPrayer(date, prayerName, status));
  }
}

final prayerStateProvider = StateNotifierProvider<PrayerStateNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(prayerRepositoryProvider);
  return PrayerStateNotifier(repo);
});

// --- Periodic Location Check ---

final prayerPeriodicCheckProvider = StreamProvider<void>((ref) async* {
    final repo = ref.watch(prayerRepositoryProvider);
    // Check immediately
    await repo.checkLocationAndFetchIfNeeded();
    
    // Then every 30 minutes
    await for (final _ in Stream.periodic(const Duration(minutes: 30))) {
       await repo.checkLocationAndFetchIfNeeded();
       yield null;
    }
});
