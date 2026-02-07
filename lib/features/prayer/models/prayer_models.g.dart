// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserLocationModelAdapter extends TypeAdapter<UserLocationModel> {
  @override
  final int typeId = 10;

  @override
  UserLocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserLocationModel(
      lat: fields[0] as double,
      lng: fields[1] as double,
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserLocationModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.lng)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLocationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrayerTimesModelAdapter extends TypeAdapter<PrayerTimesModel> {
  @override
  final int typeId = 11;

  @override
  PrayerTimesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerTimesModel(
      fajr: fields[0] as String,
      sunrise: fields[1] as String,
      dhuhr: fields[2] as String,
      asr: fields[3] as String,
      maghrib: fields[4] as String,
      isha: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerTimesModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.fajr)
      ..writeByte(1)
      ..write(obj.sunrise)
      ..writeByte(2)
      ..write(obj.dhuhr)
      ..writeByte(3)
      ..write(obj.asr)
      ..writeByte(4)
      ..write(obj.maghrib)
      ..writeByte(5)
      ..write(obj.isha);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerTimesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrayerDayModelAdapter extends TypeAdapter<PrayerDayModel> {
  @override
  final int typeId = 13;

  @override
  PrayerDayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerDayModel(
      date: fields[0] as DateTime,
      timings: fields[1] as PrayerTimesModel,
      statuses: (fields[2] as Map).cast<String, PrayerStatus>(),
      dailyScore: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerDayModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.timings)
      ..writeByte(2)
      ..write(obj.statuses)
      ..writeByte(3)
      ..write(obj.dailyScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerDayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrayerStatusAdapter extends TypeAdapter<PrayerStatus> {
  @override
  final int typeId = 12;

  @override
  PrayerStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PrayerStatus.none;
      case 1:
        return PrayerStatus.onTime;
      case 2:
        return PrayerStatus.late;
      case 3:
        return PrayerStatus.missed;
      default:
        return PrayerStatus.none;
    }
  }

  @override
  void write(BinaryWriter writer, PrayerStatus obj) {
    switch (obj) {
      case PrayerStatus.none:
        writer.writeByte(0);
        break;
      case PrayerStatus.onTime:
        writer.writeByte(1);
        break;
      case PrayerStatus.late:
        writer.writeByte(2);
        break;
      case PrayerStatus.missed:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLocationModel _$UserLocationModelFromJson(Map<String, dynamic> json) =>
    UserLocationModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$UserLocationModelToJson(UserLocationModel instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'timestamp': instance.timestamp.toIso8601String(),
    };

PrayerTimesModel _$PrayerTimesModelFromJson(Map<String, dynamic> json) =>
    PrayerTimesModel(
      fajr: json['fajr'] as String,
      sunrise: json['sunrise'] as String,
      dhuhr: json['dhuhr'] as String,
      asr: json['asr'] as String,
      maghrib: json['maghrib'] as String,
      isha: json['isha'] as String,
    );

Map<String, dynamic> _$PrayerTimesModelToJson(PrayerTimesModel instance) =>
    <String, dynamic>{
      'fajr': instance.fajr,
      'sunrise': instance.sunrise,
      'dhuhr': instance.dhuhr,
      'asr': instance.asr,
      'maghrib': instance.maghrib,
      'isha': instance.isha,
    };

PrayerDayModel _$PrayerDayModelFromJson(Map<String, dynamic> json) =>
    PrayerDayModel(
      date: DateTime.parse(json['date'] as String),
      timings:
          PrayerTimesModel.fromJson(json['timings'] as Map<String, dynamic>),
      statuses: (json['statuses'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, $enumDecode(_$PrayerStatusEnumMap, e)),
      ),
      dailyScore: (json['dailyScore'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$PrayerDayModelToJson(PrayerDayModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'timings': instance.timings,
      'statuses': instance.statuses
          .map((k, e) => MapEntry(k, _$PrayerStatusEnumMap[e]!)),
      'dailyScore': instance.dailyScore,
    };

const _$PrayerStatusEnumMap = {
  PrayerStatus.none: 'none',
  PrayerStatus.onTime: 'onTime',
  PrayerStatus.late: 'late',
  PrayerStatus.missed: 'missed',
};
