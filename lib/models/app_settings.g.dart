// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppThemeAdapter extends TypeAdapter<AppTheme> {
  @override
  final int typeId = 12;

  @override
  AppTheme read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppTheme.light;
      case 1:
        return AppTheme.dark;
      case 2:
        return AppTheme.system;
      default:
        return AppTheme.light;
    }
  }

  @override
  void write(BinaryWriter writer, AppTheme obj) {
    switch (obj) {
      case AppTheme.light:
        writer.writeByte(0);
        break;
      case AppTheme.dark:
        writer.writeByte(1);
        break;
      case AppTheme.system:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppSettingsImplAdapter extends TypeAdapter<_$AppSettingsImpl> {
  @override
  final int typeId = 11;

  @override
  _$AppSettingsImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$AppSettingsImpl(
      notificationsEnabled: fields[0] as bool,
      freshnessThresholdMinutes: fields[1] as int,
      refreshFrequencyMinutes: fields[2] as int,
      theme: fields[3] as AppTheme,
      defaultFilter: fields[4] as JobFilter,
    );
  }

  @override
  void write(BinaryWriter writer, _$AppSettingsImpl obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.notificationsEnabled)
      ..writeByte(1)
      ..write(obj.freshnessThresholdMinutes)
      ..writeByte(2)
      ..write(obj.refreshFrequencyMinutes)
      ..writeByte(3)
      ..write(obj.theme)
      ..writeByte(4)
      ..write(obj.defaultFilter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsImplAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      notificationsEnabled: json['notificationsEnabled'] as bool,
      freshnessThresholdMinutes:
          (json['freshnessThresholdMinutes'] as num).toInt(),
      refreshFrequencyMinutes: (json['refreshFrequencyMinutes'] as num).toInt(),
      theme: $enumDecode(_$AppThemeEnumMap, json['theme']),
      defaultFilter:
          JobFilter.fromJson(json['defaultFilter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'notificationsEnabled': instance.notificationsEnabled,
      'freshnessThresholdMinutes': instance.freshnessThresholdMinutes,
      'refreshFrequencyMinutes': instance.refreshFrequencyMinutes,
      'theme': _$AppThemeEnumMap[instance.theme]!,
      'defaultFilter': instance.defaultFilter,
    };

const _$AppThemeEnumMap = {
  AppTheme.light: 'light',
  AppTheme.dark: 'dark',
  AppTheme.system: 'system',
};
