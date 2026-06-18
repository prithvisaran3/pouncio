import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../models/job.dart';
import '../../filters/application/filters_provider.dart';

import '../../../services/firebase_job_service.dart';

part 'jobs_provider.g.dart';

final isManualRefreshingProvider = StateProvider<bool>((ref) => false);
final newlyAddedJobIdsProvider = StateProvider<List<String>>((ref) => <String>[]);

enum ProfileFilterOption { all, myProfile }

@riverpod
class ProfileFilterState extends _$ProfileFilterState {
  @override
  ProfileFilterOption build() => ProfileFilterOption.all;

  void setOption(ProfileFilterOption option) {
    state = option;
  }
}

@riverpod
class JobsState extends _$JobsState {
  @override
  Future<List<Job>> build() async {
    debugPrint('[JobsProvider] build: Building JobsState notifier...');
    final firebaseService = ref.read(firebaseJobServiceProvider);
    final jobs = await firebaseService.getJobs();
    debugPrint('[JobsProvider] build: Loaded ${jobs.length} real jobs from Firestore.');
    return jobs;
  }

  Future<Map<String, dynamic>?> refresh() async {
    debugPrint('[JobsProvider] refresh: Starting refresh operation...');
    ref.read(isManualRefreshingProvider.notifier).state = true;
    state = const AsyncValue.loading();
    Map<String, dynamic>? stats;
    state = await AsyncValue.guard(() async {
      try {
        debugPrint('[JobsProvider] refresh: Triggering manual scraper Cloud Function via endpoint...');
        final dio = Dio();
        dio.options.connectTimeout = const Duration(seconds: 60);
        dio.options.receiveTimeout = const Duration(seconds: 60);
        final scraperUrl = dotenv.env['SCRAPER_URL'] ?? 'https://us-central1-exspends-split.cloudfunctions.net/pouncioTriggerScrapeJobs';
        final response = await dio.get<dynamic>(scraperUrl);
        debugPrint('[JobsProvider] refresh: Manual scraper completed. Response status: ${response.statusCode}, body: ${response.data}');
        if (response.data is Map) {
          final dataMap = Map<String, dynamic>.from(response.data as Map);
          if (dataMap['stats'] is Map) {
            stats = Map<String, dynamic>.from(dataMap['stats'] as Map);
          }
        }
      } catch (e, stackTrace) {
        debugPrint('[JobsProvider WARNING] refresh: Triggering manual scraper failed, falling back to database fetch: $e\n$stackTrace');
      }

      debugPrint('[JobsProvider] refresh: Loading jobs list from database...');
      final firebaseService = ref.read(firebaseJobServiceProvider);
      final jobs = await firebaseService.getJobs();
      debugPrint('[JobsProvider] refresh: Loaded ${jobs.length} jobs.');
      return jobs;
    });
    ref.read(isManualRefreshingProvider.notifier).state = false;
    return stats;
  }
}

bool _isUSLocation(String location) {
  final loc = location.toLowerCase().trim();

  if (loc.isEmpty) return true;

  // 1. Explicit non-US indicators — checked FIRST to prevent false positives
  const nonUsIndicators = [
    'mexico', 'cdmx', 'guadalajara', 'monterrey',
    'bangalore', 'india', 'mumbai', 'hyderabad', 'pune',
    'dublin', 'ireland',
    'london', 'manchester', 'uk', 'united kingdom', 'england',
    'toronto', 'vancouver', 'montreal', 'canada',
    'germany', 'berlin', 'munich',
    'singapore',
    'tokyo', 'japan', 'osaka',
    'sydney', 'melbourne', 'australia',
    'paris', 'france',
    'amsterdam', 'netherlands',
    'zürich', 'switzerland',
  ];

  for (final nonUs in nonUsIndicators) {
    if (loc.contains(nonUs)) return false;
  }

  // 2. Explicit US signals
  if (loc.contains('united states') ||
      loc.contains('usa') ||
      loc.contains('u.s.a.') ||
      loc.contains('u.s.') ||
      loc.contains(', us') ||
      loc.contains('(us)') ||
      loc.contains('remote')) {
    return true;
  }

  // 3. Well-known US cities and state abbreviations
  const usCitiesAndStates = [
    'san francisco', 'new york', 'chicago', 'atlanta', 'seattle',
    'austin', 'boston', 'los angeles', 'denver', 'redmond',
    'mountain view', 'palo alto', 'sunnyvale', 'san jose', 'cupertino',
    'menlo park', 'new grad', // "New Grad" roles are typically US
  ];

  for (final hint in usCitiesAndStates) {
    if (loc.contains(hint)) return true;
  }

  // 4. Unknown location — include by default (we can tighten later)
  return true;
}
bool _suitsMobileAppDev(Job job) {
  final role = job.role.toLowerCase();
  return role.contains('mobile') ||
      role.contains('app ') || 
      role.contains(' app') || 
      role.contains('flutter') ||
      role.contains('ios') ||
      role.contains('android') ||
      role.contains('react native') ||
      role.contains('swift') ||
      role.contains('kotlin') ||
      role.contains('dart');
}

bool _isComputerScienceRole(Job job) {
  final role = job.role.toLowerCase();
  
  // Exclude non-CS engineering/technical subjects clearly:
  final nonCsExclusions = [
    'mechanical', 'aerospace', 'civil', 'electrical', 'chemical', 'industrial',
    'hardware', 'firmware', 'materials', 'materials science', 'physics',
    'operations center', 'fleet', 'automotive', 'nuclear', 'bio', 'biomedical',
    'construction', 'geotechnical', 'manufacturing', 'manufacturing engineer'
  ];

  for (final exclusion in nonCsExclusions) {
    if (role.contains(exclusion)) {
      return false;
    }
  }

  // Include typical CS / Software / Tech keywords:
  const csKeywords = [
    'software', 'developer', 'programmer', 'computer', 'web', 'frontend', 'backend', 'fullstack', 'full stack',
    'mobile', 'ios', 'android', 'flutter', 'react native', 'swift', 'kotlin', 'cloud', 'devops', 'sre', 
    'data engineer', 'data scientist', 'data science', 'machine learning', 'ml', 'ai', 'network engineer', 
    'systems engineer', 'application engineer', 'applications engineer', 'coding'
  ];

  for (final keyword in csKeywords) {
    if (role.contains(keyword)) {
      return true;
    }
  }

  return false;
}

@riverpod
List<Job> filteredJobs(FilteredJobsRef ref) {
  final jobsAsync = ref.watch(jobsStateProvider);
  final filter = ref.watch(filtersStateProvider);
  final profileFilter = ref.watch(profileFilterStateProvider);
  final newlyAddedIds = ref.watch(newlyAddedJobIdsProvider);

  return jobsAsync.maybeWhen(
    data: (jobs) {
      // 1. Filter out non-US jobs
      final usJobs = jobs.where((job) => _isUSLocation(job.location)).toList();
      
      // 2. Filter out non-CS jobs
      final csJobs = usJobs.where(_isComputerScienceRole).toList();
      
      // 3. Filter by Profile switch: All vs My Profile (Mobile App Dev)
      final profileJobs = csJobs.where((job) {
        if (profileFilter == ProfileFilterOption.myProfile) {
          return _suitsMobileAppDev(job);
        }
        return true;
      }).toList();

      // 3. Sort newlyAddedIds at the very top. Within each section, sort by postedAt descending.
      final sortedJobs = List<Job>.from(profileJobs)
        ..sort((a, b) {
          final aIsNew = newlyAddedIds.contains(a.id);
          final bIsNew = newlyAddedIds.contains(b.id);
          if (aIsNew && !bIsNew) return -1;
          if (!aIsNew && bIsNew) return 1;
          return b.postedAt.compareTo(a.postedAt);
        });
        
      // 4. Apply general active search filters
      final matched = sortedJobs.where((job) => filter.matches(job)).toList();
      
      final unmatchedCount = sortedJobs.length - matched.length;
      if (unmatchedCount > 0) {
        debugPrint('[filteredJobs] Filtered out $unmatchedCount jobs that did not match active filter.');
      }
      debugPrint('[filteredJobs] Returned ${matched.length} matched jobs.');
      return matched;
    },
    orElse: () => <Job>[],
  );
}
