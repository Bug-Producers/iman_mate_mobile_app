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

final prayerRepositoryProvider = Provider<PrayerRepository>((ref) {
  final local = ref.watch(prayerLocalServiceProvider);
  final location = ref.watch(locationLocalServiceProvider);
  final api = ref.watch(prayerApiServiceProvider);
  
  return PrayerRepository(local, location, api);
});

final prayerInitProvider = FutureProvider<void>((ref) async {
  final repo = ref.read(prayerRepositoryProvider);
  await repo.init();
  await repo.checkLocationAndFetchIfNeeded();
});

final todayPrayerProvider = StateProvider<PrayerDayModel?>((ref) {
  final local = ref.watch(prayerLocalServiceProvider);
  return local.getPrayerDay(DateTime.now());
});

final nextPrayerProvider = StreamProvider<Map<String, dynamic>>((ref) async* {
  while (true) {
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

final dailyPerformanceProvider = Provider.family<PrayerDayModel?, DateTime>((ref, date) {
    final local = ref.watch(prayerLocalServiceProvider);
    return local.getPrayerDay(date);
});

final monthlyPerformanceProvider = Provider.family<MonthlySummaryModel?, DateTime>((ref, date) {
    final local = ref.watch(prayerLocalServiceProvider);
    return local.getMonthlySummary(date.month, date.year);
});

final scoreConfigProvider = Provider<PrayerScoreConfigModel>((ref) {
    final local = ref.watch(prayerLocalServiceProvider);
    return local.getConfig();
});

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

final prayerPeriodicCheckProvider = StreamProvider<void>((ref) async* {
    final repo = ref.watch(prayerRepositoryProvider);
    await repo.checkLocationAndFetchIfNeeded();
    
    await for (final _ in Stream.periodic(const Duration(minutes: 30))) {
       await repo.checkLocationAndFetchIfNeeded();
       yield null;
    }
});
