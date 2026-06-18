// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FreshnessTierAdapter extends TypeAdapter<FreshnessTier> {
  @override
  final int typeId = 9;

  @override
  FreshnessTier read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FreshnessTier.now;
      case 1:
        return FreshnessTier.recent;
      case 2:
        return FreshnessTier.today;
      case 3:
        return FreshnessTier.older;
      default:
        return FreshnessTier.now;
    }
  }

  @override
  void write(BinaryWriter writer, FreshnessTier obj) {
    switch (obj) {
      case FreshnessTier.now:
        writer.writeByte(0);
        break;
      case FreshnessTier.recent:
        writer.writeByte(1);
        break;
      case FreshnessTier.today:
        writer.writeByte(2);
        break;
      case FreshnessTier.older:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FreshnessTierAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReadStateAdapter extends TypeAdapter<ReadState> {
  @override
  final int typeId = 10;

  @override
  ReadState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReadState.unread;
      case 1:
        return ReadState.read;
      default:
        return ReadState.unread;
    }
  }

  @override
  void write(BinaryWriter writer, ReadState obj) {
    switch (obj) {
      case ReadState.unread:
        writer.writeByte(0);
        break;
      case ReadState.read:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationItemImplAdapter extends TypeAdapter<_$NotificationItemImpl> {
  @override
  final int typeId = 8;

  @override
  _$NotificationItemImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$NotificationItemImpl(
      id: fields[0] as String,
      jobId: fields[1] as String?,
      title: fields[2] as String,
      body: fields[3] as String,
      postedAt: fields[4] as DateTime,
      freshnessTier: fields[5] as FreshnessTier,
      readState: fields[6] as ReadState,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, _$NotificationItemImpl obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.postedAt)
      ..writeByte(5)
      ..write(obj.freshnessTier)
      ..writeByte(6)
      ..write(obj.readState)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationItemImplAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationItemImpl _$$NotificationItemImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationItemImpl(
      id: json['id'] as String,
      jobId: json['jobId'] as String?,
      title: json['title'] as String,
      body: json['body'] as String,
      postedAt: DateTime.parse(json['postedAt'] as String),
      freshnessTier: $enumDecode(_$FreshnessTierEnumMap, json['freshnessTier']),
      readState: $enumDecode(_$ReadStateEnumMap, json['readState']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$NotificationItemImplToJson(
        _$NotificationItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jobId': instance.jobId,
      'title': instance.title,
      'body': instance.body,
      'postedAt': instance.postedAt.toIso8601String(),
      'freshnessTier': _$FreshnessTierEnumMap[instance.freshnessTier]!,
      'readState': _$ReadStateEnumMap[instance.readState]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$FreshnessTierEnumMap = {
  FreshnessTier.now: 'now',
  FreshnessTier.recent: 'recent',
  FreshnessTier.today: 'today',
  FreshnessTier.older: 'older',
};

const _$ReadStateEnumMap = {
  ReadState.unread: 'unread',
  ReadState.read: 'read',
};
