// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_filter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisaFilterOptionAdapter extends TypeAdapter<VisaFilterOption> {
  @override
  final int typeId = 7;

  @override
  VisaFilterOption read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VisaFilterOption.sponsorOnly;
      case 1:
        return VisaFilterOption.any;
      default:
        return VisaFilterOption.sponsorOnly;
    }
  }

  @override
  void write(BinaryWriter writer, VisaFilterOption obj) {
    switch (obj) {
      case VisaFilterOption.sponsorOnly:
        writer.writeByte(0);
        break;
      case VisaFilterOption.any:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisaFilterOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JobFilterImplAdapter extends TypeAdapter<_$JobFilterImpl> {
  @override
  final int typeId = 6;

  @override
  _$JobFilterImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$JobFilterImpl(
      roleTypes: (fields[0] as List).cast<String>(),
      employmentTypes: (fields[1] as List).cast<EmploymentType>(),
      remoteTypes: (fields[2] as List).cast<RemoteType>(),
      visa: fields[3] as VisaFilterOption,
      experienceLevels: (fields[4] as List).cast<ExperienceLevel>(),
      sources: (fields[5] as List?)?.cast<JobSource>(),
    );
  }

  @override
  void write(BinaryWriter writer, _$JobFilterImpl obj) {
    writer
      ..writeByte(6)
      ..writeByte(3)
      ..write(obj.visa)
      ..writeByte(0)
      ..write(obj.roleTypes)
      ..writeByte(1)
      ..write(obj.employmentTypes)
      ..writeByte(2)
      ..write(obj.remoteTypes)
      ..writeByte(4)
      ..write(obj.experienceLevels)
      ..writeByte(5)
      ..write(obj.sources);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobFilterImplAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobFilterImpl _$$JobFilterImplFromJson(Map<String, dynamic> json) =>
    _$JobFilterImpl(
      roleTypes:
          (json['roleTypes'] as List<dynamic>).map((e) => e as String).toList(),
      employmentTypes: (json['employmentTypes'] as List<dynamic>)
          .map((e) => $enumDecode(_$EmploymentTypeEnumMap, e))
          .toList(),
      remoteTypes: (json['remoteTypes'] as List<dynamic>)
          .map((e) => $enumDecode(_$RemoteTypeEnumMap, e))
          .toList(),
      visa: $enumDecode(_$VisaFilterOptionEnumMap, json['visa']),
      experienceLevels: (json['experienceLevels'] as List<dynamic>)
          .map((e) => $enumDecode(_$ExperienceLevelEnumMap, e))
          .toList(),
      sources: (json['sources'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$JobSourceEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$$JobFilterImplToJson(_$JobFilterImpl instance) =>
    <String, dynamic>{
      'roleTypes': instance.roleTypes,
      'employmentTypes': instance.employmentTypes
          .map((e) => _$EmploymentTypeEnumMap[e]!)
          .toList(),
      'remoteTypes':
          instance.remoteTypes.map((e) => _$RemoteTypeEnumMap[e]!).toList(),
      'visa': _$VisaFilterOptionEnumMap[instance.visa]!,
      'experienceLevels': instance.experienceLevels
          .map((e) => _$ExperienceLevelEnumMap[e]!)
          .toList(),
      'sources': instance.sources?.map((e) => _$JobSourceEnumMap[e]!).toList(),
    };

const _$EmploymentTypeEnumMap = {
  EmploymentType.fullTime: 'fullTime',
  EmploymentType.partTime: 'partTime',
  EmploymentType.internship: 'internship',
  EmploymentType.freshGrad: 'freshGrad',
};

const _$RemoteTypeEnumMap = {
  RemoteType.remote: 'remote',
  RemoteType.hybrid: 'hybrid',
  RemoteType.onsite: 'onsite',
};

const _$VisaFilterOptionEnumMap = {
  VisaFilterOption.sponsorOnly: 'sponsorOnly',
  VisaFilterOption.any: 'any',
};

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.intern: 'intern',
  ExperienceLevel.entry: 'entry',
  ExperienceLevel.associate: 'associate',
};

const _$JobSourceEnumMap = {
  JobSource.simplifyJobs: 'simplifyJobs',
  JobSource.greenhouse: 'greenhouse',
  JobSource.lever: 'lever',
  JobSource.ashby: 'ashby',
  JobSource.other: 'other',
  JobSource.linkedIn: 'linkedIn',
  JobSource.handshake: 'handshake',
};
