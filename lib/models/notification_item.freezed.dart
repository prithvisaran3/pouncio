// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationItem _$NotificationItemFromJson(Map<String, dynamic> json) {
  return _NotificationItem.fromJson(json);
}

/// @nodoc
mixin _$NotificationItem {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get jobId => throw _privateConstructorUsedError;
  @HiveField(2)
  String get title => throw _privateConstructorUsedError;
  @HiveField(3)
  String get body => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime get postedAt => throw _privateConstructorUsedError;
  @HiveField(5)
  FreshnessTier get freshnessTier => throw _privateConstructorUsedError;
  @HiveField(6)
  ReadState get readState => throw _privateConstructorUsedError;
  @HiveField(7)
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationItemCopyWith<NotificationItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationItemCopyWith<$Res> {
  factory $NotificationItemCopyWith(
          NotificationItem value, $Res Function(NotificationItem) then) =
      _$NotificationItemCopyWithImpl<$Res, NotificationItem>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String? jobId,
      @HiveField(2) String title,
      @HiveField(3) String body,
      @HiveField(4) DateTime postedAt,
      @HiveField(5) FreshnessTier freshnessTier,
      @HiveField(6) ReadState readState,
      @HiveField(7) DateTime createdAt});
}

/// @nodoc
class _$NotificationItemCopyWithImpl<$Res, $Val extends NotificationItem>
    implements $NotificationItemCopyWith<$Res> {
  _$NotificationItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobId = freezed,
    Object? title = null,
    Object? body = null,
    Object? postedAt = null,
    Object? freshnessTier = null,
    Object? readState = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      jobId: freezed == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      postedAt: null == postedAt
          ? _value.postedAt
          : postedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      freshnessTier: null == freshnessTier
          ? _value.freshnessTier
          : freshnessTier // ignore: cast_nullable_to_non_nullable
              as FreshnessTier,
      readState: null == readState
          ? _value.readState
          : readState // ignore: cast_nullable_to_non_nullable
              as ReadState,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationItemImplCopyWith<$Res>
    implements $NotificationItemCopyWith<$Res> {
  factory _$$NotificationItemImplCopyWith(_$NotificationItemImpl value,
          $Res Function(_$NotificationItemImpl) then) =
      __$$NotificationItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String? jobId,
      @HiveField(2) String title,
      @HiveField(3) String body,
      @HiveField(4) DateTime postedAt,
      @HiveField(5) FreshnessTier freshnessTier,
      @HiveField(6) ReadState readState,
      @HiveField(7) DateTime createdAt});
}

/// @nodoc
class __$$NotificationItemImplCopyWithImpl<$Res>
    extends _$NotificationItemCopyWithImpl<$Res, _$NotificationItemImpl>
    implements _$$NotificationItemImplCopyWith<$Res> {
  __$$NotificationItemImplCopyWithImpl(_$NotificationItemImpl _value,
      $Res Function(_$NotificationItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobId = freezed,
    Object? title = null,
    Object? body = null,
    Object? postedAt = null,
    Object? freshnessTier = null,
    Object? readState = null,
    Object? createdAt = null,
  }) {
    return _then(_$NotificationItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      jobId: freezed == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      postedAt: null == postedAt
          ? _value.postedAt
          : postedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      freshnessTier: null == freshnessTier
          ? _value.freshnessTier
          : freshnessTier // ignore: cast_nullable_to_non_nullable
              as FreshnessTier,
      readState: null == readState
          ? _value.readState
          : readState // ignore: cast_nullable_to_non_nullable
              as ReadState,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 8)
class _$NotificationItemImpl extends _NotificationItem {
  const _$NotificationItemImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) this.jobId,
      @HiveField(2) required this.title,
      @HiveField(3) required this.body,
      @HiveField(4) required this.postedAt,
      @HiveField(5) required this.freshnessTier,
      @HiveField(6) required this.readState,
      @HiveField(7) required this.createdAt})
      : super._();

  factory _$NotificationItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationItemImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String? jobId;
  @override
  @HiveField(2)
  final String title;
  @override
  @HiveField(3)
  final String body;
  @override
  @HiveField(4)
  final DateTime postedAt;
  @override
  @HiveField(5)
  final FreshnessTier freshnessTier;
  @override
  @HiveField(6)
  final ReadState readState;
  @override
  @HiveField(7)
  final DateTime createdAt;

  @override
  String toString() {
    return 'NotificationItem(id: $id, jobId: $jobId, title: $title, body: $body, postedAt: $postedAt, freshnessTier: $freshnessTier, readState: $readState, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.postedAt, postedAt) ||
                other.postedAt == postedAt) &&
            (identical(other.freshnessTier, freshnessTier) ||
                other.freshnessTier == freshnessTier) &&
            (identical(other.readState, readState) ||
                other.readState == readState) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, jobId, title, body, postedAt,
      freshnessTier, readState, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationItemImplCopyWith<_$NotificationItemImpl> get copyWith =>
      __$$NotificationItemImplCopyWithImpl<_$NotificationItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationItemImplToJson(
      this,
    );
  }
}

abstract class _NotificationItem extends NotificationItem {
  const factory _NotificationItem(
          {@HiveField(0) required final String id,
          @HiveField(1) final String? jobId,
          @HiveField(2) required final String title,
          @HiveField(3) required final String body,
          @HiveField(4) required final DateTime postedAt,
          @HiveField(5) required final FreshnessTier freshnessTier,
          @HiveField(6) required final ReadState readState,
          @HiveField(7) required final DateTime createdAt}) =
      _$NotificationItemImpl;
  const _NotificationItem._() : super._();

  factory _NotificationItem.fromJson(Map<String, dynamic> json) =
      _$NotificationItemImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String? get jobId;
  @override
  @HiveField(2)
  String get title;
  @override
  @HiveField(3)
  String get body;
  @override
  @HiveField(4)
  DateTime get postedAt;
  @override
  @HiveField(5)
  FreshnessTier get freshnessTier;
  @override
  @HiveField(6)
  ReadState get readState;
  @override
  @HiveField(7)
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$NotificationItemImplCopyWith<_$NotificationItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
