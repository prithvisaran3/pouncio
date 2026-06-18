import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'job_filter.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@HiveType(typeId: 12)
enum AppTheme {
  @HiveField(0)
  light,
  @HiveField(1)
  dark,
  @HiveField(2)
  system,
}

@freezed
class AppSettings with _$AppSettings {
  @HiveType(typeId: 11)
  const factory AppSettings({
    @HiveField(0) required bool notificationsEnabled,
    @HiveField(1) required int freshnessThresholdMinutes, // default 60
    @HiveField(2) required int refreshFrequencyMinutes,    // display-only
    @HiveField(3) required AppTheme theme,
    @HiveField(4) required JobFilter defaultFilter,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  const AppSettings._();

  /// Default application settings instance.
  factory AppSettings.defaultSettings() => AppSettings(
        notificationsEnabled: true,
        freshnessThresholdMinutes: 60,
        refreshFrequencyMinutes: 5,
        theme: AppTheme.system,
        defaultFilter: JobFilter.empty(),
      );
}
