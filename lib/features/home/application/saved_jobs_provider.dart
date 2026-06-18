import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/job.dart';

part 'saved_jobs_provider.g.dart';

@riverpod
class SavedJobsState extends _$SavedJobsState {
  late Box<Job> _box;

  @override
  List<Job> build() {
    debugPrint('[SavedJobsProvider] build: Loading saved/bookmarked jobs from local Hive database...');
    _box = Hive.box<Job>('saved_jobs');
    final savedJobs = _box.values.toList();
    debugPrint('[SavedJobsProvider] build: Successfully loaded ${savedJobs.length} bookmarked jobs.');
    return savedJobs;
  }

  Future<void> toggleSaveJob(Job job) async {
    final isAlreadySaved = _box.containsKey(job.id);
    debugPrint('[SavedJobsProvider] toggleSaveJob: ${isAlreadySaved ? "Removing" : "Adding"} job: ${job.id} (${job.role} at ${job.company}).');
    if (isAlreadySaved) {
      await _box.delete(job.id);
    } else {
      // Make sure when we bookmark a fresh job, it starts with appliedAt as null
      await _box.put(job.id, job.copyWith(appliedAt: null));
    }
    state = _box.values.toList();
    debugPrint('[SavedJobsProvider] toggleSaveJob: Local storage updated. Total saved jobs now: ${state.length}.');
  }

  Future<void> toggleAppliedJob(Job job) async {
    final existing = _box.get(job.id);
    if (existing == null) {
      final updatedJob = job.copyWith(appliedAt: DateTime.now());
      await _box.put(job.id, updatedJob);
      debugPrint('[SavedJobsProvider] toggleAppliedJob: Added new applied job: ${job.id}');
    } else {
      final isCurrentlyApplied = existing.appliedAt != null;
      final updatedJob = existing.copyWith(
        appliedAt: isCurrentlyApplied ? null : DateTime.now(),
      );
      await _box.put(job.id, updatedJob);
      debugPrint('[SavedJobsProvider] toggleAppliedJob: Toggled applied status for: ${job.id} to ${!isCurrentlyApplied}');
    }
    state = _box.values.toList();
    debugPrint('[SavedJobsProvider] toggleAppliedJob: Local storage updated. Total saved jobs now: ${state.length}.');
  }

  bool isSaved(String jobId) {
    return _box.containsKey(jobId);
  }
}
