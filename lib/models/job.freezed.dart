// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Job _$JobFromJson(Map<String, dynamic> json) {
  return _Job.fromJson(json);
}

/// @nodoc
mixin _$Job {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get company => throw _privateConstructorUsedError;
  @HiveField(2)
  String get role => throw _privateConstructorUsedError;
  @HiveField(3)
  String get location => throw _privateConstructorUsedError;
  @HiveField(4)
  String get applyUrl => throw _privateConstructorUsedError;
  @HiveField(5)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime get postedAt => throw _privateConstructorUsedError;
  @HiveField(7)
  EmploymentType get employmentType => throw _privateConstructorUsedError;
  @HiveField(8)
  RemoteType get remoteType => throw _privateConstructorUsedError;
  @HiveField(9)
  VisaStatus get visa => throw _privateConstructorUsedError;
  @HiveField(10)
  ExperienceLevel get experienceLevel => throw _privateConstructorUsedError;
  @HiveField(11)
  JobSource get source => throw _privateConstructorUsedError;
  @HiveField(12)
  List<String>? get referralContacts => throw _privateConstructorUsedError;
  @HiveField(13)
  DateTime? get appliedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JobCopyWith<Job> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobCopyWith<$Res> {
  factory $JobCopyWith(Job value, $Res Function(Job) then) =
      _$JobCopyWithImpl<$Res, Job>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String company,
      @HiveField(2) String role,
      @HiveField(3) String location,
      @HiveField(4) String applyUrl,
      @HiveField(5) String? description,
      @HiveField(6) DateTime postedAt,
      @HiveField(7) EmploymentType employmentType,
      @HiveField(8) RemoteType remoteType,
      @HiveField(9) VisaStatus visa,
      @HiveField(10) ExperienceLevel experienceLevel,
      @HiveField(11) JobSource source,
      @HiveField(12) List<String>? referralContacts,
      @HiveField(13) DateTime? appliedAt});
}

/// @nodoc
class _$JobCopyWithImpl<$Res, $Val extends Job> implements $JobCopyWith<$Res> {
  _$JobCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? company = null,
    Object? role = null,
    Object? location = null,
    Object? applyUrl = null,
    Object? description = freezed,
    Object? postedAt = null,
    Object? employmentType = null,
    Object? remoteType = null,
    Object? visa = null,
    Object? experienceLevel = null,
    Object? source = null,
    Object? referralContacts = freezed,
    Object? appliedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      company: null == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      applyUrl: null == applyUrl
          ? _value.applyUrl
          : applyUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      postedAt: null == postedAt
          ? _value.postedAt
          : postedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      employmentType: null == employmentType
          ? _value.employmentType
          : employmentType // ignore: cast_nullable_to_non_nullable
              as EmploymentType,
      remoteType: null == remoteType
          ? _value.remoteType
          : remoteType // ignore: cast_nullable_to_non_nullable
              as RemoteType,
      visa: null == visa
          ? _value.visa
          : visa // ignore: cast_nullable_to_non_nullable
              as VisaStatus,
      experienceLevel: null == experienceLevel
          ? _value.experienceLevel
          : experienceLevel // ignore: cast_nullable_to_non_nullable
              as ExperienceLevel,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as JobSource,
      referralContacts: freezed == referralContacts
          ? _value.referralContacts
          : referralContacts // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      appliedAt: freezed == appliedAt
          ? _value.appliedAt
          : appliedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JobImplCopyWith<$Res> implements $JobCopyWith<$Res> {
  factory _$$JobImplCopyWith(_$JobImpl value, $Res Function(_$JobImpl) then) =
      __$$JobImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String company,
      @HiveField(2) String role,
      @HiveField(3) String location,
      @HiveField(4) String applyUrl,
      @HiveField(5) String? description,
      @HiveField(6) DateTime postedAt,
      @HiveField(7) EmploymentType employmentType,
      @HiveField(8) RemoteType remoteType,
      @HiveField(9) VisaStatus visa,
      @HiveField(10) ExperienceLevel experienceLevel,
      @HiveField(11) JobSource source,
      @HiveField(12) List<String>? referralContacts,
      @HiveField(13) DateTime? appliedAt});
}

/// @nodoc
class __$$JobImplCopyWithImpl<$Res> extends _$JobCopyWithImpl<$Res, _$JobImpl>
    implements _$$JobImplCopyWith<$Res> {
  __$$JobImplCopyWithImpl(_$JobImpl _value, $Res Function(_$JobImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? company = null,
    Object? role = null,
    Object? location = null,
    Object? applyUrl = null,
    Object? description = freezed,
    Object? postedAt = null,
    Object? employmentType = null,
    Object? remoteType = null,
    Object? visa = null,
    Object? experienceLevel = null,
    Object? source = null,
    Object? referralContacts = freezed,
    Object? appliedAt = freezed,
  }) {
    return _then(_$JobImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      company: null == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      applyUrl: null == applyUrl
          ? _value.applyUrl
          : applyUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      postedAt: null == postedAt
          ? _value.postedAt
          : postedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      employmentType: null == employmentType
          ? _value.employmentType
          : employmentType // ignore: cast_nullable_to_non_nullable
              as EmploymentType,
      remoteType: null == remoteType
          ? _value.remoteType
          : remoteType // ignore: cast_nullable_to_non_nullable
              as RemoteType,
      visa: null == visa
          ? _value.visa
          : visa // ignore: cast_nullable_to_non_nullable
              as VisaStatus,
      experienceLevel: null == experienceLevel
          ? _value.experienceLevel
          : experienceLevel // ignore: cast_nullable_to_non_nullable
              as ExperienceLevel,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as JobSource,
      referralContacts: freezed == referralContacts
          ? _value._referralContacts
          : referralContacts // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      appliedAt: freezed == appliedAt
          ? _value.appliedAt
          : appliedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 0)
class _$JobImpl implements _Job {
  const _$JobImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.company,
      @HiveField(2) required this.role,
      @HiveField(3) required this.location,
      @HiveField(4) required this.applyUrl,
      @HiveField(5) required this.description,
      @HiveField(6) required this.postedAt,
      @HiveField(7) required this.employmentType,
      @HiveField(8) required this.remoteType,
      @HiveField(9) required this.visa,
      @HiveField(10) required this.experienceLevel,
      @HiveField(11) required this.source,
      @HiveField(12) required final List<String>? referralContacts,
      @HiveField(13) required this.appliedAt})
      : _referralContacts = referralContacts;

  factory _$JobImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String company;
  @override
  @HiveField(2)
  final String role;
  @override
  @HiveField(3)
  final String location;
  @override
  @HiveField(4)
  final String applyUrl;
  @override
  @HiveField(5)
  final String? description;
  @override
  @HiveField(6)
  final DateTime postedAt;
  @override
  @HiveField(7)
  final EmploymentType employmentType;
  @override
  @HiveField(8)
  final RemoteType remoteType;
  @override
  @HiveField(9)
  final VisaStatus visa;
  @override
  @HiveField(10)
  final ExperienceLevel experienceLevel;
  @override
  @HiveField(11)
  final JobSource source;
  final List<String>? _referralContacts;
  @override
  @HiveField(12)
  List<String>? get referralContacts {
    final value = _referralContacts;
    if (value == null) return null;
    if (_referralContacts is EqualUnmodifiableListView)
      return _referralContacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @HiveField(13)
  final DateTime? appliedAt;

  @override
  String toString() {
    return 'Job(id: $id, company: $company, role: $role, location: $location, applyUrl: $applyUrl, description: $description, postedAt: $postedAt, employmentType: $employmentType, remoteType: $remoteType, visa: $visa, experienceLevel: $experienceLevel, source: $source, referralContacts: $referralContacts, appliedAt: $appliedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.applyUrl, applyUrl) ||
                other.applyUrl == applyUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.postedAt, postedAt) ||
                other.postedAt == postedAt) &&
            (identical(other.employmentType, employmentType) ||
                other.employmentType == employmentType) &&
            (identical(other.remoteType, remoteType) ||
                other.remoteType == remoteType) &&
            (identical(other.visa, visa) || other.visa == visa) &&
            (identical(other.experienceLevel, experienceLevel) ||
                other.experienceLevel == experienceLevel) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality()
                .equals(other._referralContacts, _referralContacts) &&
            (identical(other.appliedAt, appliedAt) ||
                other.appliedAt == appliedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      company,
      role,
      location,
      applyUrl,
      description,
      postedAt,
      employmentType,
      remoteType,
      visa,
      experienceLevel,
      source,
      const DeepCollectionEquality().hash(_referralContacts),
      appliedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JobImplCopyWith<_$JobImpl> get copyWith =>
      __$$JobImplCopyWithImpl<_$JobImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobImplToJson(
      this,
    );
  }
}

abstract class _Job implements Job {
  const factory _Job(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String company,
      @HiveField(2) required final String role,
      @HiveField(3) required final String location,
      @HiveField(4) required final String applyUrl,
      @HiveField(5) required final String? description,
      @HiveField(6) required final DateTime postedAt,
      @HiveField(7) required final EmploymentType employmentType,
      @HiveField(8) required final RemoteType remoteType,
      @HiveField(9) required final VisaStatus visa,
      @HiveField(10) required final ExperienceLevel experienceLevel,
      @HiveField(11) required final JobSource source,
      @HiveField(12) required final List<String>? referralContacts,
      @HiveField(13) required final DateTime? appliedAt}) = _$JobImpl;

  factory _Job.fromJson(Map<String, dynamic> json) = _$JobImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get company;
  @override
  @HiveField(2)
  String get role;
  @override
  @HiveField(3)
  String get location;
  @override
  @HiveField(4)
  String get applyUrl;
  @override
  @HiveField(5)
  String? get description;
  @override
  @HiveField(6)
  DateTime get postedAt;
  @override
  @HiveField(7)
  EmploymentType get employmentType;
  @override
  @HiveField(8)
  RemoteType get remoteType;
  @override
  @HiveField(9)
  VisaStatus get visa;
  @override
  @HiveField(10)
  ExperienceLevel get experienceLevel;
  @override
  @HiveField(11)
  JobSource get source;
  @override
  @HiveField(12)
  List<String>? get referralContacts;
  @override
  @HiveField(13)
  DateTime? get appliedAt;
  @override
  @JsonKey(ignore: true)
  _$$JobImplCopyWith<_$JobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
