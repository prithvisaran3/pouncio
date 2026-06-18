import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'job.freezed.dart';
part 'job.g.dart';

@HiveType(typeId: 1)
enum EmploymentType {
  @HiveField(0)
  fullTime,
  @HiveField(1)
  partTime,
  @HiveField(2)
  internship,
  @HiveField(3)
  freshGrad,
}

@HiveType(typeId: 2)
enum RemoteType {
  @HiveField(0)
  remote,
  @HiveField(1)
  hybrid,
  @HiveField(2)
  onsite,
}

@HiveType(typeId: 3)
enum VisaStatus {
  @HiveField(0)
  sponsor,
  @HiveField(1)
  noSponsor,
  @HiveField(2)
  unknown,
}

@HiveType(typeId: 4)
enum ExperienceLevel {
  @HiveField(0)
  intern,
  @HiveField(1)
  entry,
  @HiveField(2)
  associate,
}

@HiveType(typeId: 5)
enum JobSource {
  @HiveField(0)
  simplifyJobs,
  @HiveField(1)
  greenhouse,
  @HiveField(2)
  lever,
  @HiveField(3)
  ashby,
  @HiveField(4)
  other,
  @HiveField(5)
  linkedIn,
  @HiveField(6)
  handshake,
}

@freezed
class Job with _$Job {
  @HiveType(typeId: 0)
  const factory Job({
    @HiveField(0) required String id,
    @HiveField(1) required String company,
    @HiveField(2) required String role,
    @HiveField(3) required String location,
    @HiveField(4) required String applyUrl,
    @HiveField(5) required String? description,
    @HiveField(6) required DateTime postedAt,
    @HiveField(7) required EmploymentType employmentType,
    @HiveField(8) required RemoteType remoteType,
    @HiveField(9) required VisaStatus visa,
    @HiveField(10) required ExperienceLevel experienceLevel,
    @HiveField(11) required JobSource source,
    @HiveField(12) required List<String>? referralContacts,
    @HiveField(13) required DateTime? appliedAt,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}
