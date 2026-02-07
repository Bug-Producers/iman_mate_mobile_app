import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prayer_models.g.dart';

@HiveType(typeId: 10)
@JsonSerializable()
class UserLocationModel {
  @HiveField(0)
  final double lat;
  @HiveField(1)
  final double lng;
  @HiveField(2)
  final DateTime timestamp;

  UserLocationModel({
    required this.lat,
    required this.lng,
    required this.timestamp,
  });

  factory UserLocationModel.fromJson(Map<String, dynamic> json) =>
      _$UserLocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserLocationModelToJson(this);
}

@HiveType(typeId: 11)
@JsonSerializable()
class PrayerTimesModel {
  @HiveField(0)
  final String fajr;
  @HiveField(1)
  final String sunrise; // Helpful for logic
  @HiveField(2)
  final String dhuhr;
  @HiveField(3)
  final String asr;
  @HiveField(4)
  final String maghrib;
  @HiveField(5)
  final String isha;

  PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimesModelFromJson(json);
  Map<String, dynamic> toJson() => _$PrayerTimesModelToJson(this);
}

@HiveType(typeId: 12)
enum PrayerStatus {
  @HiveField(0)
  none,
  @HiveField(1)
  onTime,
  @HiveField(2)
  late,
  @HiveField(3)
  missed,
}

@HiveType(typeId: 13)
@JsonSerializable()
class PrayerDayModel {
  @HiveField(0)
  final DateTime date;
  
  @HiveField(1)
  final PrayerTimesModel timings;
  
  @HiveField(2)
  final Map<String, PrayerStatus> statuses; // e.g. "Fajr": PrayerStatus.onTime
  
  @HiveField(3)
  final double dailyScore;

  PrayerDayModel({
    required this.date,
    required this.timings,
    required this.statuses,
    this.dailyScore = 0.0,
  });

  PrayerDayModel copyWith({
    DateTime? date,
    PrayerTimesModel? timings,
    Map<String, PrayerStatus>? statuses,
    double? dailyScore,
  }) {
    return PrayerDayModel(
      date: date ?? this.date,
      timings: timings ?? this.timings,
      statuses: statuses ?? this.statuses,
      dailyScore: dailyScore ?? this.dailyScore,
    );
  }

  factory PrayerDayModel.fromJson(Map<String, dynamic> json) =>
      _$PrayerDayModelFromJson(json);
  Map<String, dynamic> toJson() => _$PrayerDayModelToJson(this);
}
