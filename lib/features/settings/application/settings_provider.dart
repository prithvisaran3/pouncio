import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/app_settings.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsState extends _$SettingsState {
  late Box<AppSettings> _box;

  @override
  AppSettings build() {
    debugPrint('[SettingsProvider] build: Loading app settings from Hive...');
    _box = Hive.box<AppSettings>('settings');
    final settings = _box.get('app_settings', defaultValue: AppSettings.defaultSettings())!;
    debugPrint('[SettingsProvider] build: App settings loaded successfully: $settings');
    return settings;
  }

  Future<void> updateSettings(AppSettings settings) async {
    debugPrint('[SettingsProvider] updateSettings: Updating app settings to: $settings');
    state = settings;
    await _box.put('app_settings', settings);
    debugPrint('[SettingsProvider] updateSettings: Successfully saved app settings updates to local database.');
  }

  Future<void> toggleNotifications(bool enabled) async {
    debugPrint('[SettingsProvider] toggleNotifications: Toggling notification settings to: $enabled');
    final updated = state.copyWith(notificationsEnabled: enabled);
    await updateSettings(updated);
  }

  Future<void> updateThreshold(int minutes) async {
    debugPrint('[SettingsProvider] updateThreshold: Updating freshness threshold settings to: $minutes minutes');
    final updated = state.copyWith(freshnessThresholdMinutes: minutes);
    await updateSettings(updated);
  }

  Future<void> updateTheme(AppTheme theme) async {
    debugPrint('[SettingsProvider] updateTheme: Updating application theme setting to: $theme');
    final updated = state.copyWith(theme: theme);
    await updateSettings(updated);
  }
}
