import 'location.dart';
import 'prayer.dart';

class PrayerTime {
  final DateTime date;
  final Location location;
  final Prayer fajr;
  final Prayer dhuhr;
  final Prayer asr;
  final Prayer maghrib;
  final Prayer isha;
  final DateTime sunrise;

  PrayerTime({
    required this.date,
    required this.location,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.sunrise,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    final prayers = (json['prayers'] as List)
        .map((p) => Prayer.fromJson(p))
        .toList();

    Prayer getPrayer(String name) =>
        prayers.firstWhere((p) => p.name.toLowerCase() == name.toLowerCase());

    return PrayerTime(
      date: DateTime.parse(json['date']),
      location: Location.fromJson(json['location']),
      fajr: getPrayer('Fajr'),
      dhuhr: getPrayer('Dhuhr'),
      asr: getPrayer('Asr'),
      maghrib: getPrayer('Maghrib'),
      isha: getPrayer('Isha'),
      sunrise: DateTime.parse(json['sunrise']),
    );
  }
}
