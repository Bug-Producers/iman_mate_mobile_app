import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iman_mate_mobile_app/core/modules/location.dart';
import 'package:iman_mate_mobile_app/features/prayertimes/models/monthly_prayer_schedule.dart';

import '../../../core/services/LocationService.dart';
import '../../../core/services/network/dio_client.dart';
import '../../../core/services/network/dio_provider.dart';


final prayersApiServiceProvider = Provider<PrayersApiService?>((ref) {
  final dio = ref.watch(dioClientProvider);
  final locationAsync = ref.watch(currentLocationProvider);

  return locationAsync.when(
    data: (location) => PrayersApiService(dio, location),
    loading: () => null,
    error: (err, stack) => null,
  );
});

class PrayersApiService {
  final DioClient dio;
  final Location location;

  PrayersApiService(this.dio,this.location);


  Future<Response> getMonthlyPrayerSchedule() async {
    return await dio.get(
      '/api/v1/prayer/times-month',
      queryParameters: {
        'lat': location.lat,
        'lng': location.lng,
      },
    );
  }
}
