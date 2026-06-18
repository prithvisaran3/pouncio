// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmploymentTypeAdapter extends TypeAdapter<EmploymentType> {
  @override
  final int typeId = 1;

  @override
  EmploymentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EmploymentType.fullTime;
      case 1:
        return EmploymentType.partTime;
      case 2:
        return EmploymentType.internship;
      case 3:
        return EmploymentType.freshGrad;
      default:
        return EmploymentType.fullTime;
    }
  }

  @override
  void write(BinaryWriter writer, EmploymentType obj) {
    switch (obj) {
      case EmploymentType.fullTime:
        writer.writeByte(0);
        break;
      case EmploymentType.partTime:
        writer.writeByte(1);
        break;
      case EmploymentType.internship:
        writer.writeByte(2);
        break;
      case EmploymentType.freshGrad:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmploymentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RemoteTypeAdapter extends TypeAdapter<RemoteType> {
  @override
  final int typeId = 2;

  @override
  RemoteType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RemoteType.remote;
      case 1:
        return RemoteType.hybrid;
      case 2:
        return RemoteType.onsite;
      default:
        return RemoteType.remote;
    }
  }

  @override
  void write(BinaryWriter writer, RemoteType obj) {
    switch (obj) {
      case RemoteType.remote:
        writer.writeByte(0);
        break;
      case RemoteType.hybrid:
        writer.writeByte(1);
        break;
      case RemoteType.onsite:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemoteTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VisaStatusAdapter extends TypeAdapter<VisaStatus> {
  @override
  final int typeId = 3;

  @override
  VisaStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VisaStatus.sponsor;
      case 1:
        return VisaStatus.noSponsor;
      case 2:
        return VisaStatus.unknown;
      default:
        return VisaStatus.sponsor;
    }
  }

  @override
  void write(BinaryWriter writer, VisaStatus obj) {
    switch (obj) {
      case VisaStatus.sponsor:
        writer.writeByte(0);
        break;
      case VisaStatus.noSponsor:
        writer.writeByte(1);
        break;
      case VisaStatus.unknown:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisaStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExperienceLevelAdapter extends TypeAdapter<ExperienceLevel> {
  @override
  final int typeId = 4;

  @override
  ExperienceLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExperienceLevel.intern;
      case 1:
        return ExperienceLevel.entry;
      case 2:
        return ExperienceLevel.associate;
      default:
        return ExperienceLevel.intern;
    }
  }

  @override
  void write(BinaryWriter writer, ExperienceLevel obj) {
    switch (obj) {
      case ExperienceLevel.intern:
        writer.writeByte(0);
        break;
      case ExperienceLevel.entry:
        writer.writeByte(1);
        break;
      case ExperienceLevel.associate:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExperienceLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JobSourceAdapter extends TypeAdapter<JobSource> {
  @override
  final int typeId = 5;

  @override
  JobSource read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return JobSource.simplifyJobs;
      case 1:
        return JobSource.greenhouse;
      case 2:
        return JobSource.lever;
      case 3:
        return JobSource.ashby;
      case 4:
        return JobSource.other;
      case 5:
        return JobSource.linkedIn;
      case 6:
        return JobSource.handshake;
      default:
        return JobSource.simplifyJobs;
    }
  }

  @override
  void write(BinaryWriter writer, JobSource obj) {
    switch (obj) {
      case JobSource.simplifyJobs:
        writer.writeByte(0);
        break;
      case JobSource.greenhouse:
        writer.writeByte(1);
        break;
      case JobSource.lever:
        writer.writeByte(2);
        break;
      case JobSource.ashby:
        writer.writeByte(3);
        break;
      case JobSource.other:
        writer.writeByte(4);
        break;
      case JobSource.linkedIn:
        writer.writeByte(5);
        break;
      case JobSource.handshake:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobSourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JobImplAdapter extends TypeAdapter<_$JobImpl> {
  @override
  final int typeId = 0;

  @override
  _$JobImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$JobImpl(
      id: fields[0] as String,
      company: fields[1] as String,
      role: fields[2] as String,
      location: fields[3] as String,
      applyUrl: fields[4] as String,
      description: fields[5] as String?,
      postedAt: fields[6] as DateTime,
      employmentType: fields[7] as EmploymentType,
      remoteType: fields[8] as RemoteType,
      visa: fields[9] as VisaStatus,
      experienceLevel: fields[10] as ExperienceLevel,
      source: fields[11] as JobSource,
      referralContacts: (fields[12] as List?)?.cast<String>(),
      appliedAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, _$JobImpl obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.company)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.applyUrl)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.postedAt)
      ..writeByte(7)
      ..write(obj.employmentType)
      ..writeByte(8)
      ..write(obj.remoteType)
      ..writeByte(9)
      ..write(obj.visa)
      ..writeByte(10)
      ..write(obj.experienceLevel)
      ..writeByte(11)
      ..write(obj.source)
      ..writeByte(13)
      ..write(obj.appliedAt)
      ..writeByte(12)
      ..write(obj.referralContacts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobImplAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobImpl _$$JobImplFromJson(Map<String, dynamic> json) => _$JobImpl(
      id: json['id'] as String,
      company: json['company'] as String,
      role: json['role'] as String,
      location: json['location'] as String,
      applyUrl: json['applyUrl'] as String,
      description: json['description'] as String?,
      postedAt: DateTime.parse(json['postedAt'] as String),
      employmentType:
          $enumDecode(_$EmploymentTypeEnumMap, json['employmentType']),
      remoteType: $enumDecode(_$RemoteTypeEnumMap, json['remoteType']),
      visa: $enumDecode(_$VisaStatusEnumMap, json['visa']),
      experienceLevel:
          $enumDecode(_$ExperienceLevelEnumMap, json['experienceLevel']),
      source: $enumDecode(_$JobSourceEnumMap, json['source']),
      referralContacts: (json['referralContacts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      appliedAt: json['appliedAt'] == null
          ? null
          : DateTime.parse(json['appliedAt'] as String),
    );

Map<String, dynamic> _$$JobImplToJson(_$JobImpl instance) => <String, dynamic>{
      'id': instance.id,
      'company': instance.company,
      'role': instance.role,
      'location': instance.location,
      'applyUrl': instance.applyUrl,
      'description': instance.description,
      'postedAt': instance.postedAt.toIso8601String(),
      'employmentType': _$EmploymentTypeEnumMap[instance.employmentType]!,
      'remoteType': _$RemoteTypeEnumMap[instance.remoteType]!,
      'visa': _$VisaStatusEnumMap[instance.visa]!,
      'experienceLevel': _$ExperienceLevelEnumMap[instance.experienceLevel]!,
      'source': _$JobSourceEnumMap[instance.source]!,
      'referralContacts': instance.referralContacts,
      'appliedAt': instance.appliedAt?.toIso8601String(),
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

const _$VisaStatusEnumMap = {
  VisaStatus.sponsor: 'sponsor',
  VisaStatus.noSponsor: 'noSponsor',
  VisaStatus.unknown: 'unknown',
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
