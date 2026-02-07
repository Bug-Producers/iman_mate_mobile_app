import '../../../core/modules/location.dart';
import 'prayer_for_day.dart';

class MonthlyPrayerSchedule {
  final DateTime startDate;
  final DateTime endDate;
  final Location location;
  final Map<DateTime, PrayerForDay> days;
  final int totalDays;

  MonthlyPrayerSchedule({
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.days,
    required this.totalDays,
  });

  factory MonthlyPrayerSchedule.fromJson(Map<String, dynamic> json) {
    final daysList = json['days'] as List;

    final Map<DateTime, PrayerForDay> daysMap = {
      for (var dayJson in daysList)
        DateTime.parse(dayJson['date']): PrayerForDay.fromJson(dayJson)
    };

    return MonthlyPrayerSchedule(
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      location: Location.fromJson(json['location']),
      days: daysMap,
      totalDays: json['total_days'],
    );
  }
}