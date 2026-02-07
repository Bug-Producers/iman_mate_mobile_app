// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonthlySummaryModelAdapter extends TypeAdapter<MonthlySummaryModel> {
  @override
  final int typeId = 14;

  @override
  MonthlySummaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MonthlySummaryModel(
      month: fields[0] as int,
      year: fields[1] as int,
      totalScore: fields[2] as double,
      level: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MonthlySummaryModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.month)
      ..writeByte(1)
      ..write(obj.year)
      ..writeByte(2)
      ..write(obj.totalScore)
      ..writeByte(3)
      ..write(obj.level);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlySummaryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrayerScoreConfigModelAdapter
    extends TypeAdapter<PrayerScoreConfigModel> {
  @override
  final int typeId = 15;

  @override
  PrayerScoreConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerScoreConfigModel(
      onTimePoints: fields[0] as double,
      latePoints: fields[1] as double,
      missedPoints: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerScoreConfigModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.onTimePoints)
      ..writeByte(1)
      ..write(obj.latePoints)
      ..writeByte(2)
      ..write(obj.missedPoints);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerScoreConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlySummaryModel _$MonthlySummaryModelFromJson(Map<String, dynamic> json) =>
    MonthlySummaryModel(
      month: (json['month'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      totalScore: (json['totalScore'] as num).toDouble(),
      level: (json['level'] as num).toInt(),
    );

Map<String, dynamic> _$MonthlySummaryModelToJson(
        MonthlySummaryModel instance) =>
    <String, dynamic>{
      'month': instance.month,
      'year': instance.year,
      'totalScore': instance.totalScore,
      'level': instance.level,
    };

PrayerScoreConfigModel _$PrayerScoreConfigModelFromJson(
        Map<String, dynamic> json) =>
    PrayerScoreConfigModel(
      onTimePoints: (json['onTimePoints'] as num?)?.toDouble() ?? 10.0,
      latePoints: (json['latePoints'] as num?)?.toDouble() ?? 5.0,
      missedPoints: (json['missedPoints'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$PrayerScoreConfigModelToJson(
        PrayerScoreConfigModel instance) =>
    <String, dynamic>{
      'onTimePoints': instance.onTimePoints,
      'latePoints': instance.latePoints,
      'missedPoints': instance.missedPoints,
    };
