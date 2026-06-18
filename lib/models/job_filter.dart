import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'job.dart';

part 'job_filter.freezed.dart';
part 'job_filter.g.dart';

@HiveType(typeId: 7)
enum VisaFilterOption {
  @HiveField(0)
  sponsorOnly,
  @HiveField(1)
  any,
}

@freezed
class JobFilter with _$JobFilter {
  @HiveType(typeId: 6)
  const factory JobFilter({
    @HiveField(0) required List<String> roleTypes,
    @HiveField(1) required List<EmploymentType> employmentTypes,
    @HiveField(2) required List<RemoteType> remoteTypes,
    @HiveField(3) required VisaFilterOption visa,
    @HiveField(4) required List<ExperienceLevel> experienceLevels,
    @HiveField(5) List<JobSource>? sources,
  }) = _JobFilter;

  factory JobFilter.fromJson(Map<String, dynamic> json) => _$JobFilterFromJson(json);

  const JobFilter._();

  /// Create an empty filter that matches everything.
  factory JobFilter.empty() => const JobFilter(
        roleTypes: [],
        employmentTypes: [],
        remoteTypes: [],
        visa: VisaFilterOption.any,
        experienceLevels: [],
        sources: [],
      );

  /// Helper to determine if a job matches this filter criteria.
  bool matches(Job job) {
    // 1. Role type matching (partial text matches in job.role)
    if (roleTypes.isNotEmpty) {
      bool roleMatched = false;
      for (final type in roleTypes) {
        if (job.role.toLowerCase().contains(type.toLowerCase())) {
          roleMatched = true;
          break;
        }
      }
      if (!roleMatched) return false;
    }

    // 2. Employment type matching
    if (employmentTypes.isNotEmpty && !employmentTypes.contains(job.employmentType)) {
      return false;
    }

    // 3. Remote type matching
    if (remoteTypes.isNotEmpty && !remoteTypes.contains(job.remoteType)) {
      return false;
    }

    // 4. Visa matching
    if (visa == VisaFilterOption.sponsorOnly && job.visa != VisaStatus.sponsor) {
      return false;
    }

    // 5. Experience level matching
    if (experienceLevels.isNotEmpty && !experienceLevels.contains(job.experienceLevel)) {
      return false;
    }

    // 6. Source matching
    if (sources != null && sources!.isNotEmpty && !sources!.contains(job.source)) {
      return false;
    }

    return true;
  }
}
