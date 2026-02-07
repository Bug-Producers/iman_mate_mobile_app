import '../../../core/modules/location.dart';
import 'prayer.dart';

class PrayerForDay {
  final DateTime date;
  final Location location;
  final Prayer fajr;
  final Prayer dhuhr;
  final Prayer asr;
  final Prayer maghrib;
  final Prayer isha;
  final DateTime sunrise;

  PrayerForDay({
    required this.date,
    required this.location,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.sunrise,
  });

  factory PrayerForDay.fromJson(Map<String, dynamic> json) {
    final String datePart = json['date'];
    final List<dynamic> prayersJson = json['prayers'];

    final prayers = prayersJson
        .map((p) => Prayer.fromJson(p, datePart))
        .toList();

    Prayer getPrayer(String name) =>
        prayers.firstWhere((p) => p.name.toLowerCase() == name.toLowerCase());

    return PrayerForDay(
      date: DateTime.parse(datePart),
      location: Location.fromJson(json['location']),
      fajr: getPrayer('Fajr'),
      dhuhr: getPrayer('Dhuhr'),
      asr: getPrayer('Asr'),
      maghrib: getPrayer('Maghrib'),
      isha: getPrayer('Isha'),
      sunrise: DateTime.parse("${datePart}T${json['sunrise']}:00"),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0],
      'location': location.toJson(),
      'sunrise': "${sunrise.hour.toString().padLeft(2, '0')}:${sunrise.minute.toString().padLeft(2, '0')}",
      'prayers': [fajr.toJson(), dhuhr.toJson(), asr.toJson(), maghrib.toJson(), isha.toJson()],
    };
  }
}