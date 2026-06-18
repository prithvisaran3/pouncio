import 'package:flutter_test/flutter_test.dart';
import 'package:pouncio/models/job.dart';
import 'package:pouncio/models/job_filter.dart';
import 'package:pouncio/models/notification_item.dart';

void main() {
  group('Pouncio Model & Filtering Tests', () {
    final mockJob = Job(
      id: 'test_id',
      company: 'Test Company',
      role: 'Software Engineer',
      location: 'New York, NY',
      applyUrl: 'https://test.com',
      description: 'Test Description',
      postedAt: DateTime.now().toUtc().subtract(const Duration(minutes: 10)),
      employmentType: EmploymentType.fullTime,
      remoteType: RemoteType.remote,
      visa: VisaStatus.sponsor,
      experienceLevel: ExperienceLevel.entry,
      source: JobSource.simplifyJobs,
      referralContacts: ['test@contact.com'],
      appliedAt: null,
    );

    test('Job JSON serialization and deserialization matches', () {
      final jsonMap = mockJob.toJson();
      final parsedJob = Job.fromJson(jsonMap);

      expect(parsedJob.id, mockJob.id);
      expect(parsedJob.company, mockJob.company);
      expect(parsedJob.role, mockJob.role);
      expect(parsedJob.postedAt.toIso8601String(), mockJob.postedAt.toIso8601String());
      expect(parsedJob.visa, VisaStatus.sponsor);
    });

    test('JobFilter matches matching job', () {
      const filter = JobFilter(
        roleTypes: ['Software'],
        employmentTypes: [EmploymentType.fullTime],
        remoteTypes: [RemoteType.remote],
        visa: VisaFilterOption.sponsorOnly,
        experienceLevels: [ExperienceLevel.entry],
      );

      expect(filter.matches(mockJob), isTrue);
    });

    test('JobFilter does not match mismatched role type', () {
      const filter = JobFilter(
        roleTypes: ['Mobile'],
        employmentTypes: [],
        remoteTypes: [],
        visa: VisaFilterOption.any,
        experienceLevels: [],
      );

      expect(filter.matches(mockJob), isFalse);
    });

    test('JobFilter does not match mismatched visa option', () {
      final noSponsorJob = mockJob.copyWith(visa: VisaStatus.noSponsor);
      const filter = JobFilter(
        roleTypes: [],
        employmentTypes: [],
        remoteTypes: [],
        visa: VisaFilterOption.sponsorOnly,
        experienceLevels: [],
      );

      expect(filter.matches(noSponsorJob), isFalse);
    });

    test('NotificationItem computes freshness tier correctly', () {
      final now = DateTime.now().toUtc();
      
      final postNow = now.subtract(const Duration(minutes: 15));
      expect(
        NotificationItem.computeFreshnessTier(postNow, now),
        FreshnessTier.now,
      );

      final postRecent = now.subtract(const Duration(minutes: 45));
      expect(
        NotificationItem.computeFreshnessTier(postRecent, now),
        FreshnessTier.recent,
      );

      final postToday = now.subtract(const Duration(hours: 12));
      expect(
        NotificationItem.computeFreshnessTier(postToday, now),
        FreshnessTier.today,
      );

      final postOlder = now.subtract(const Duration(days: 2));
      expect(
        NotificationItem.computeFreshnessTier(postOlder, now),
        FreshnessTier.older,
      );
    });
  });
}
