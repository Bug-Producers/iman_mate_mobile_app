import 'package:dio/dio.dart';
import '../models/prayer_models.dart';

class PrayerApiService {
  final Dio _dio;

  PrayerApiService(this._dio);

  Future<Map<String, PrayerTimesModel>> getPrayerTimesCalendar(
      double lat, double lng, int month, int year) async {
    try {
      final response = await _dio.get(
        'https://api.aladhan.com/v1/calendar',
        queryParameters: {
          'latitude': lat,
          'longitude': lng,
          'method': 2, // ISNA or others, can be configurable
          'month': month,
          'year': year,
        },
      );

      final data = response.data['data'] as List;
      final Map<String, PrayerTimesModel> result = {};

      for (var dayData in data) {
        final dateStr = dayData['date']['gregorian']['date']; // DD-MM-YYYY
        // Parse dateStr to get YYYY-MM-DD key or just use the day index if reliable.
        // Better to parse.
        final parts = dateStr.split('-');
        final day = int.parse(parts[0]);
        // The API returns MM as int or string, usually standard.
        // Let's construct DateTime to be safe and use local service key format key.
        
        final timings = dayData['timings'];
        final model = PrayerTimesModel(
          fajr: _cleanTime(timings['Fajr']),
          sunrise: _cleanTime(timings['Sunrise']),
          dhuhr: _cleanTime(timings['Dhuhr']),
          asr: _cleanTime(timings['Asr']),
          maghrib: _cleanTime(timings['Maghrib']),
          isha: _cleanTime(timings['Isha']),
        );
        
        // Reconstruct date key "YYYY-MM-DD"
        // API date format is DD-MM-YYYY
         final dateKey = "${parts[2]}-${parts[1]}-${parts[0]}"; 
         result[dateKey] = model;
      }
      return result;
    } catch (e) {
      throw Exception('Failed to fetch prayer times: $e');
    }
  }

  String _cleanTime(String time) {
    // API returns "04:55 (EET)" sometimes. Remove timezone.
    return time.split(' ')[0];
  }
}
