import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'performance_models.g.dart';

@HiveType(typeId: 14)
@JsonSerializable()
class MonthlySummaryModel {
  @HiveField(0)
  final int month;
  @HiveField(1)
  final int year;
  @HiveField(2)
  final double totalScore;
  @HiveField(3)
  final int level;

  MonthlySummaryModel({
    required this.month,
    required this.year,
    required this.totalScore,
    required this.level,
  });

   factory MonthlySummaryModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlySummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$MonthlySummaryModelToJson(this);
}

@HiveType(typeId: 15)
@JsonSerializable()
class PrayerScoreConfigModel {
  @HiveField(0)
  final double onTimePoints;
  @HiveField(1)
  final double latePoints;
  @HiveField(2)
  final double missedPoints;

  PrayerScoreConfigModel({
     this.onTimePoints = 10.0,
     this.latePoints = 5.0,
     this.missedPoints = 0.0,
  });

  PrayerScoreConfigModel copyWith({
    double? onTimePoints,
    double? latePoints,
    double? missedPoints,
  }) {
    return PrayerScoreConfigModel(
      onTimePoints: onTimePoints ?? this.onTimePoints,
      latePoints: latePoints ?? this.latePoints,
      missedPoints: missedPoints ?? this.missedPoints,
    );
  }

  factory PrayerScoreConfigModel.fromJson(Map<String, dynamic> json) =>
      _$PrayerScoreConfigModelFromJson(json);
  Map<String, dynamic> toJson() => _$PrayerScoreConfigModelToJson(this);
}
