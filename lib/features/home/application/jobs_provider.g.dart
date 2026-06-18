// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jobs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredJobsHash() => r'2233d5ffab88e2c14d894f7bf88ee24344af8923';

/// See also [filteredJobs].
@ProviderFor(filteredJobs)
final filteredJobsProvider = AutoDisposeProvider<List<Job>>.internal(
  filteredJobs,
  name: r'filteredJobsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$filteredJobsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredJobsRef = AutoDisposeProviderRef<List<Job>>;
String _$profileFilterStateHash() =>
    r'1d0c5bcfa8b4ea9bab0bbec5cec20de96171ef5c';

/// See also [ProfileFilterState].
@ProviderFor(ProfileFilterState)
final profileFilterStateProvider = AutoDisposeNotifierProvider<
    ProfileFilterState, ProfileFilterOption>.internal(
  ProfileFilterState.new,
  name: r'profileFilterStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileFilterStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileFilterState = AutoDisposeNotifier<ProfileFilterOption>;
String _$jobsStateHash() => r'4b5f7d5a715ba8256231a9faa0f3058023a2e3fe';

/// See also [JobsState].
@ProviderFor(JobsState)
final jobsStateProvider =
    AutoDisposeAsyncNotifierProvider<JobsState, List<Job>>.internal(
  JobsState.new,
  name: r'jobsStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$jobsStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$JobsState = AutoDisposeAsyncNotifier<List<Job>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
