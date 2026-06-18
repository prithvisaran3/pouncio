// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JobFilter _$JobFilterFromJson(Map<String, dynamic> json) {
  return _JobFilter.fromJson(json);
}

/// @nodoc
mixin _$JobFilter {
  @HiveField(0)
  List<String> get roleTypes => throw _privateConstructorUsedError;
  @HiveField(1)
  List<EmploymentType> get employmentTypes =>
      throw _privateConstructorUsedError;
  @HiveField(2)
  List<RemoteType> get remoteTypes => throw _privateConstructorUsedError;
  @HiveField(3)
  VisaFilterOption get visa => throw _privateConstructorUsedError;
  @HiveField(4)
  List<ExperienceLevel> get experienceLevels =>
      throw _privateConstructorUsedError;
  @HiveField(5)
  List<JobSource>? get sources => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JobFilterCopyWith<JobFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobFilterCopyWith<$Res> {
  factory $JobFilterCopyWith(JobFilter value, $Res Function(JobFilter) then) =
      _$JobFilterCopyWithImpl<$Res, JobFilter>;
  @useResult
  $Res call(
      {@HiveField(0) List<String> roleTypes,
      @HiveField(1) List<EmploymentType> employmentTypes,
      @HiveField(2) List<RemoteType> remoteTypes,
      @HiveField(3) VisaFilterOption visa,
      @HiveField(4) List<ExperienceLevel> experienceLevels,
      @HiveField(5) List<JobSource>? sources});
}

/// @nodoc
class _$JobFilterCopyWithImpl<$Res, $Val extends JobFilter>
    implements $JobFilterCopyWith<$Res> {
  _$JobFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roleTypes = null,
    Object? employmentTypes = null,
    Object? remoteTypes = null,
    Object? visa = null,
    Object? experienceLevels = null,
    Object? sources = freezed,
  }) {
    return _then(_value.copyWith(
      roleTypes: null == roleTypes
          ? _value.roleTypes
          : roleTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      employmentTypes: null == employmentTypes
          ? _value.employmentTypes
          : employmentTypes // ignore: cast_nullable_to_non_nullable
              as List<EmploymentType>,
      remoteTypes: null == remoteTypes
          ? _value.remoteTypes
          : remoteTypes // ignore: cast_nullable_to_non_nullable
              as List<RemoteType>,
      visa: null == visa
          ? _value.visa
          : visa // ignore: cast_nullable_to_non_nullable
              as VisaFilterOption,
      experienceLevels: null == experienceLevels
          ? _value.experienceLevels
          : experienceLevels // ignore: cast_nullable_to_non_nullable
              as List<ExperienceLevel>,
      sources: freezed == sources
          ? _value.sources
          : sources // ignore: cast_nullable_to_non_nullable
              as List<JobSource>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JobFilterImplCopyWith<$Res>
    implements $JobFilterCopyWith<$Res> {
  factory _$$JobFilterImplCopyWith(
          _$JobFilterImpl value, $Res Function(_$JobFilterImpl) then) =
      __$$JobFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) List<String> roleTypes,
      @HiveField(1) List<EmploymentType> employmentTypes,
      @HiveField(2) List<RemoteType> remoteTypes,
      @HiveField(3) VisaFilterOption visa,
      @HiveField(4) List<ExperienceLevel> experienceLevels,
      @HiveField(5) List<JobSource>? sources});
}

/// @nodoc
class __$$JobFilterImplCopyWithImpl<$Res>
    extends _$JobFilterCopyWithImpl<$Res, _$JobFilterImpl>
    implements _$$JobFilterImplCopyWith<$Res> {
  __$$JobFilterImplCopyWithImpl(
      _$JobFilterImpl _value, $Res Function(_$JobFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roleTypes = null,
    Object? employmentTypes = null,
    Object? remoteTypes = null,
    Object? visa = null,
    Object? experienceLevels = null,
    Object? sources = freezed,
  }) {
    return _then(_$JobFilterImpl(
      roleTypes: null == roleTypes
          ? _value._roleTypes
          : roleTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      employmentTypes: null == employmentTypes
          ? _value._employmentTypes
          : employmentTypes // ignore: cast_nullable_to_non_nullable
              as List<EmploymentType>,
      remoteTypes: null == remoteTypes
          ? _value._remoteTypes
          : remoteTypes // ignore: cast_nullable_to_non_nullable
              as List<RemoteType>,
      visa: null == visa
          ? _value.visa
          : visa // ignore: cast_nullable_to_non_nullable
              as VisaFilterOption,
      experienceLevels: null == experienceLevels
          ? _value._experienceLevels
          : experienceLevels // ignore: cast_nullable_to_non_nullable
              as List<ExperienceLevel>,
      sources: freezed == sources
          ? _value._sources
          : sources // ignore: cast_nullable_to_non_nullable
              as List<JobSource>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 6)
class _$JobFilterImpl extends _JobFilter {
  const _$JobFilterImpl(
      {@HiveField(0) required final List<String> roleTypes,
      @HiveField(1) required final List<EmploymentType> employmentTypes,
      @HiveField(2) required final List<RemoteType> remoteTypes,
      @HiveField(3) required this.visa,
      @HiveField(4) required final List<ExperienceLevel> experienceLevels,
      @HiveField(5) final List<JobSource>? sources})
      : _roleTypes = roleTypes,
        _employmentTypes = employmentTypes,
        _remoteTypes = remoteTypes,
        _experienceLevels = experienceLevels,
        _sources = sources,
        super._();

  factory _$JobFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobFilterImplFromJson(json);

  final List<String> _roleTypes;
  @override
  @HiveField(0)
  List<String> get roleTypes {
    if (_roleTypes is EqualUnmodifiableListView) return _roleTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roleTypes);
  }

  final List<EmploymentType> _employmentTypes;
  @override
  @HiveField(1)
  List<EmploymentType> get employmentTypes {
    if (_employmentTypes is EqualUnmodifiableListView) return _employmentTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employmentTypes);
  }

  final List<RemoteType> _remoteTypes;
  @override
  @HiveField(2)
  List<RemoteType> get remoteTypes {
    if (_remoteTypes is EqualUnmodifiableListView) return _remoteTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_remoteTypes);
  }

  @override
  @HiveField(3)
  final VisaFilterOption visa;
  final List<ExperienceLevel> _experienceLevels;
  @override
  @HiveField(4)
  List<ExperienceLevel> get experienceLevels {
    if (_experienceLevels is EqualUnmodifiableListView)
      return _experienceLevels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_experienceLevels);
  }

  final List<JobSource>? _sources;
  @override
  @HiveField(5)
  List<JobSource>? get sources {
    final value = _sources;
    if (value == null) return null;
    if (_sources is EqualUnmodifiableListView) return _sources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'JobFilter(roleTypes: $roleTypes, employmentTypes: $employmentTypes, remoteTypes: $remoteTypes, visa: $visa, experienceLevels: $experienceLevels, sources: $sources)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobFilterImpl &&
            const DeepCollectionEquality()
                .equals(other._roleTypes, _roleTypes) &&
            const DeepCollectionEquality()
                .equals(other._employmentTypes, _employmentTypes) &&
            const DeepCollectionEquality()
                .equals(other._remoteTypes, _remoteTypes) &&
            (identical(other.visa, visa) || other.visa == visa) &&
            const DeepCollectionEquality()
                .equals(other._experienceLevels, _experienceLevels) &&
            const DeepCollectionEquality().equals(other._sources, _sources));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_roleTypes),
      const DeepCollectionEquality().hash(_employmentTypes),
      const DeepCollectionEquality().hash(_remoteTypes),
      visa,
      const DeepCollectionEquality().hash(_experienceLevels),
      const DeepCollectionEquality().hash(_sources));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JobFilterImplCopyWith<_$JobFilterImpl> get copyWith =>
      __$$JobFilterImplCopyWithImpl<_$JobFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobFilterImplToJson(
      this,
    );
  }
}

abstract class _JobFilter extends JobFilter {
  const factory _JobFilter(
      {@HiveField(0) required final List<String> roleTypes,
      @HiveField(1) required final List<EmploymentType> employmentTypes,
      @HiveField(2) required final List<RemoteType> remoteTypes,
      @HiveField(3) required final VisaFilterOption visa,
      @HiveField(4) required final List<ExperienceLevel> experienceLevels,
      @HiveField(5) final List<JobSource>? sources}) = _$JobFilterImpl;
  const _JobFilter._() : super._();

  factory _JobFilter.fromJson(Map<String, dynamic> json) =
      _$JobFilterImpl.fromJson;

  @override
  @HiveField(0)
  List<String> get roleTypes;
  @override
  @HiveField(1)
  List<EmploymentType> get employmentTypes;
  @override
  @HiveField(2)
  List<RemoteType> get remoteTypes;
  @override
  @HiveField(3)
  VisaFilterOption get visa;
  @override
  @HiveField(4)
  List<ExperienceLevel> get experienceLevels;
  @override
  @HiveField(5)
  List<JobSource>? get sources;
  @override
  @JsonKey(ignore: true)
  _$$JobFilterImplCopyWith<_$JobFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
