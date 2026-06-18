import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/job_filter.dart';

part 'filters_provider.g.dart';

final isFiltersOpenProvider = StateProvider<bool>((ref) => false);

@riverpod
class FiltersState extends _$FiltersState {
  late Box<JobFilter> _box;

  @override
  JobFilter build() {
    debugPrint('[FiltersProvider] build: Loading job search filters from Hive...');
    _box = Hive.box<JobFilter>('filters');
    final activeFilters = _box.get('job_filters', defaultValue: JobFilter.empty())!;
    debugPrint('[FiltersProvider] build: Search filters loaded successfully: $activeFilters');
    return activeFilters;
  }

  Future<void> updateFilter(JobFilter filter) async {
    debugPrint('[FiltersProvider] updateFilter: Updating job filters to: $filter');
    state = filter;
    await _box.put('job_filters', filter);
    debugPrint('[FiltersProvider] updateFilter: Successfully saved filter updates to local database.');
  }

  Future<void> resetFilter() async {
    debugPrint('[FiltersProvider] resetFilter: Resetting job search filters to empty defaults.');
    final emptyFilter = JobFilter.empty();
    state = emptyFilter;
    await _box.put('job_filters', emptyFilter);
    debugPrint('[FiltersProvider] resetFilter: Filters reset successfully.');
  }
}
