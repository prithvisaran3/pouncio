// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  @HiveField(0)
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  @HiveField(1)
  int get freshnessThresholdMinutes =>
      throw _privateConstructorUsedError; // default 60
  @HiveField(2)
  int get refreshFrequencyMinutes =>
      throw _privateConstructorUsedError; // display-only
  @HiveField(3)
  AppTheme get theme => throw _privateConstructorUsedError;
  @HiveField(4)
  JobFilter get defaultFilter => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call(
      {@HiveField(0) bool notificationsEnabled,
      @HiveField(1) int freshnessThresholdMinutes,
      @HiveField(2) int refreshFrequencyMinutes,
      @HiveField(3) AppTheme theme,
      @HiveField(4) JobFilter defaultFilter});

  $JobFilterCopyWith<$Res> get defaultFilter;
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationsEnabled = null,
    Object? freshnessThresholdMinutes = null,
    Object? refreshFrequencyMinutes = null,
    Object? theme = null,
    Object? defaultFilter = null,
  }) {
    return _then(_value.copyWith(
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      freshnessThresholdMinutes: null == freshnessThresholdMinutes
          ? _value.freshnessThresholdMinutes
          : freshnessThresholdMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      refreshFrequencyMinutes: null == refreshFrequencyMinutes
          ? _value.refreshFrequencyMinutes
          : refreshFrequencyMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as AppTheme,
      defaultFilter: null == defaultFilter
          ? _value.defaultFilter
          : defaultFilter // ignore: cast_nullable_to_non_nullable
              as JobFilter,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $JobFilterCopyWith<$Res> get defaultFilter {
    return $JobFilterCopyWith<$Res>(_value.defaultFilter, (value) {
      return _then(_value.copyWith(defaultFilter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
          _$AppSettingsImpl value, $Res Function(_$AppSettingsImpl) then) =
      __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) bool notificationsEnabled,
      @HiveField(1) int freshnessThresholdMinutes,
      @HiveField(2) int refreshFrequencyMinutes,
      @HiveField(3) AppTheme theme,
      @HiveField(4) JobFilter defaultFilter});

  @override
  $JobFilterCopyWith<$Res> get defaultFilter;
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
      _$AppSettingsImpl _value, $Res Function(_$AppSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationsEnabled = null,
    Object? freshnessThresholdMinutes = null,
    Object? refreshFrequencyMinutes = null,
    Object? theme = null,
    Object? defaultFilter = null,
  }) {
    return _then(_$AppSettingsImpl(
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      freshnessThresholdMinutes: null == freshnessThresholdMinutes
          ? _value.freshnessThresholdMinutes
          : freshnessThresholdMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      refreshFrequencyMinutes: null == refreshFrequencyMinutes
          ? _value.refreshFrequencyMinutes
          : refreshFrequencyMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as AppTheme,
      defaultFilter: null == defaultFilter
          ? _value.defaultFilter
          : defaultFilter // ignore: cast_nullable_to_non_nullable
              as JobFilter,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 11)
class _$AppSettingsImpl extends _AppSettings {
  const _$AppSettingsImpl(
      {@HiveField(0) required this.notificationsEnabled,
      @HiveField(1) required this.freshnessThresholdMinutes,
      @HiveField(2) required this.refreshFrequencyMinutes,
      @HiveField(3) required this.theme,
      @HiveField(4) required this.defaultFilter})
      : super._();

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  @HiveField(0)
  final bool notificationsEnabled;
  @override
  @HiveField(1)
  final int freshnessThresholdMinutes;
// default 60
  @override
  @HiveField(2)
  final int refreshFrequencyMinutes;
// display-only
  @override
  @HiveField(3)
  final AppTheme theme;
  @override
  @HiveField(4)
  final JobFilter defaultFilter;

  @override
  String toString() {
    return 'AppSettings(notificationsEnabled: $notificationsEnabled, freshnessThresholdMinutes: $freshnessThresholdMinutes, refreshFrequencyMinutes: $refreshFrequencyMinutes, theme: $theme, defaultFilter: $defaultFilter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.freshnessThresholdMinutes,
                    freshnessThresholdMinutes) ||
                other.freshnessThresholdMinutes == freshnessThresholdMinutes) &&
            (identical(
                    other.refreshFrequencyMinutes, refreshFrequencyMinutes) ||
                other.refreshFrequencyMinutes == refreshFrequencyMinutes) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.defaultFilter, defaultFilter) ||
                other.defaultFilter == defaultFilter));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, notificationsEnabled,
      freshnessThresholdMinutes, refreshFrequencyMinutes, theme, defaultFilter);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(
      this,
    );
  }
}

abstract class _AppSettings extends AppSettings {
  const factory _AppSettings(
          {@HiveField(0) required final bool notificationsEnabled,
          @HiveField(1) required final int freshnessThresholdMinutes,
          @HiveField(2) required final int refreshFrequencyMinutes,
          @HiveField(3) required final AppTheme theme,
          @HiveField(4) required final JobFilter defaultFilter}) =
      _$AppSettingsImpl;
  const _AppSettings._() : super._();

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  @HiveField(0)
  bool get notificationsEnabled;
  @override
  @HiveField(1)
  int get freshnessThresholdMinutes;
  @override // default 60
  @HiveField(2)
  int get refreshFrequencyMinutes;
  @override // display-only
  @HiveField(3)
  AppTheme get theme;
  @override
  @HiveField(4)
  JobFilter get defaultFilter;
  @override
  @JsonKey(ignore: true)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
