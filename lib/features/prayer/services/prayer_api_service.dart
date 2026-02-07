import 'package:dio/dio.dart';
import '../models/prayer_models.dart';

class PrayerApiService {
  final Dio _dio;

  PrayerApiService(this._dio);

  Future<Map<String, PrayerTimesModel>> getPrayerTimesCalendar(
      double lat, double lng, int month, int year) async {
    try {
      final response = await _dio.get(
        'http://localhost:8000/api/v1/prayer/times-month',
        queryParameters: {
          'lat': lat,
          'lng': lng,
        },
      );

      final data = response.data;
      final List days = data['days'] as List;
      final Map<String, PrayerTimesModel> result = {};

      for (var dayData in days) {
        final dateStr = dayData['date'];
        final List prayers = dayData['prayers'] as List;
        final String sunrise = dayData['sunrise'];

        String getPrayerTime(String name) {
          final p = prayers.firstWhere(
            (element) => element['name'] == name,
            orElse: () => {'time': '00:00'},
          );
          return p['time'];
        }

        final model = PrayerTimesModel(
          fajr: getPrayerTime('Fajr'),
          sunrise: sunrise, 
          dhuhr: getPrayerTime('Dhuhr'),
          asr: getPrayerTime('Asr'),
          maghrib: getPrayerTime('Maghrib'),
          isha: getPrayerTime('Isha'),
        );
        
        result[dateStr] = model;
      }
      return result;
    } catch (e) {
      throw Exception('Failed to fetch prayer times: $e');
    }
  }
}
