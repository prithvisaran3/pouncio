import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' hide GlassCard;

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../models/job.dart';
import '../../home/application/saved_jobs_provider.dart';
import '../../filters/application/filters_provider.dart';
import '../../../shared/widgets/classy_app_bar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/freshness_badge.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';

/// SavedJobsView renders the list of jobs bookmarked by the user,
/// separated into Bookmarked and Already Applied tabs.
class SavedJobsView extends ConsumerStatefulWidget {
  const SavedJobsView({super.key});

  @override
  ConsumerState<SavedJobsView> createState() => _SavedJobsViewState();
}

class _SavedJobsViewState extends ConsumerState<SavedJobsView> {
  int _selectedTabIndex = 0; // 0 for Bookmarked, 1 for Already Applied

  @override
  Widget build(BuildContext context) {
    final savedJobs = ref.watch(savedJobsStateProvider);
    final isFiltersOpen = ref.watch(isFiltersOpenProvider);

    final bookmarkedJobs = savedJobs.where((j) => j.appliedAt == null).toList();
    final appliedJobs = savedJobs.where((j) => j.appliedAt != null).toList();

    final activeJobsList = _selectedTabIndex == 0 ? bookmarkedJobs : appliedJobs;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background(context),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ClassyAppBar(title: 'Saved Jobs'),
            
            // Premium tab toggle control
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.scale(context, AppConstants.screenPadding),
                vertical: Responsive.scale(context, 10.0),
              ),
              child: SizedBox(
                width: double.infinity,
                child: GlassSegmentedControl(
                  segments: const ['Bookmarked', 'Already Applied'],
                  selectedIndex: _selectedTabIndex,
                  onSegmentSelected: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  useOwnLayer: true,
                  indicatorColor: AppColors.accent,
                  height: Responsive.scale(context, 36.0),
                  borderRadius: Responsive.scale(context, 18.0),
                  selectedTextStyle: TextStyle(
                    fontSize: Responsive.scaleText(context, 13.0),
                    fontWeight: FontWeight.w700,
                    color: CupertinoColors.white,
                  ),
                  unselectedTextStyle: TextStyle(
                    fontSize: Responsive.scaleText(context, 13.0),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
            ),

            Expanded(
              child: isFiltersOpen
                  ? const SizedBox.shrink()
                  : activeJobsList.isEmpty
                  ? Center(
                      child: _selectedTabIndex == 0
                          ? const EmptyState(
                              icon: CupertinoIcons.bookmark,
                              title: 'No Bookmarked Jobs',
                              message: 'Explore listings and bookmark positions to see them here.',
                            )
                          : const EmptyState(
                              icon: CupertinoIcons.paperplane,
                              title: 'No Applications Yet',
                              message: 'Mark jobs as applied in the detail view to track your applications.',
                            ),
                    )
                  : CupertinoScrollbar(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          Responsive.scale(context, AppConstants.screenPadding),
                          Responsive.scale(context, 6.0),
                          Responsive.scale(context, AppConstants.screenPadding),
                          MediaQuery.paddingOf(context).bottom + Responsive.scale(context, 84.0),
                        ),
                        itemCount: activeJobsList.length,
                        itemBuilder: (context, i) {
                          final job = activeJobsList[i];
                          return Padding(
                            padding: EdgeInsets.only(bottom: Responsive.scale(context, AppConstants.space12)),
                            child: Hero(
                              tag: 'saved_job_hero_${job.id}',
                              child: GlassCard(
                                onTap: () => context.push('/job/${job.id}'),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            job.company,
                                            style: AppTypography.bodySecondary(context).copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: Responsive.scaleText(context, 13.0),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          minSize: 0,
                                          onPressed: () => ref
                                              .read(savedJobsStateProvider.notifier)
                                              .toggleSaveJob(job),
                                          child: Icon(
                                            CupertinoIcons.bookmark_fill,
                                            size: Responsive.scale(context, 18.0),
                                            color: AppColors.accent,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Responsive.scale(context, AppConstants.space4)),
                                    Text(
                                      job.role,
                                      style: AppTypography.title(context).copyWith(
                                        fontSize: Responsive.scaleText(context, 18.0),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: Responsive.scale(context, AppConstants.space8)),
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.location_solid,
                                          size: Responsive.scale(context, 12.0),
                                          color: AppColors.textSecondary(context),
                                        ),
                                        SizedBox(width: Responsive.scale(context, AppConstants.space4)),
                                        Expanded(
                                          child: Text(
                                            job.location,
                                            style: AppTypography.caption(context).copyWith(
                                              fontSize: Responsive.scaleText(context, 12.0),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Responsive.scale(context, AppConstants.space12)),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          FreshnessBadge(postedAt: job.postedAt),
                                          SizedBox(width: Responsive.scale(context, 8.0)),
                                          _tag(context, _remoteLabel(job.remoteType)),
                                          SizedBox(width: Responsive.scale(context, 8.0)),
                                          _sourceTag(context, job),
                                          if (_selectedTabIndex == 1 && job.appliedAt != null) ...[
                                            SizedBox(width: Responsive.scale(context, 8.0)),
                                            _appliedDateTag(context, job.appliedAt!),
                                          ],
                                          SizedBox(width: Responsive.scale(context, 8.0)),
                                          Text(
                                            timeAgo(job.postedAt),
                                            style: AppTypography.micro(context).copyWith(
                                              fontSize: Responsive.scaleText(context, 10.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(BuildContext context, String text) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.space8, vertical: AppConstants.space4),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(AppConstants.radiusChip),
          border: Border.all(color: AppColors.border(context), width: 0.5),
        ),
        child: Text(
          text,
          style: AppTypography.micro(context).copyWith(color: AppColors.textSecondary(context)),
        ),
      );

  Widget _appliedDateTag(BuildContext context, DateTime date) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.space8, vertical: AppConstants.space4),
        decoration: BoxDecoration(
          color: const Color(0x2210B981), // Translucent green
          borderRadius: BorderRadius.circular(AppConstants.radiusChip),
          border: Border.all(color: const Color(0xAA10B981), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.checkmark_alt, size: 10, color: Color(0xFF10B981)),
            const SizedBox(width: 3),
            Text(
              'Applied ${formatDate(date)}',
              style: AppTypography.micro(context).copyWith(
                color: const Color(0xFF10B981),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  String _remoteLabel(RemoteType t) => switch (t) {
        RemoteType.remote => 'Remote',
        RemoteType.hybrid => 'Hybrid',
        RemoteType.onsite => 'Onsite',
      };

  String _sourceLabel(JobSource s) => switch (s) {
        JobSource.simplifyJobs => 'Simplify',
        JobSource.greenhouse => 'Greenhouse',
        JobSource.lever => 'Lever',
        JobSource.ashby => 'Ashby',
        JobSource.linkedIn => 'LinkedIn',
        JobSource.handshake => 'Handshake',
        JobSource.other => 'Other',
      };

  Widget _sourceTag(BuildContext context, Job job) {
    final uri = Uri.tryParse(job.applyUrl);
    final domain = uri != null ? uri.host.replaceFirst('www.', '') : _sourceLabel(job.source);
    final path = uri?.path.replaceAll('/', '').toLowerCase() ?? '';
    final genericPaths = {'', 'jobs', 'careers', 'work', 'opportunities', 'hiring', 'join'};
    final isGeneric = genericPaths.contains(path);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space8, vertical: AppConstants.space4),
      decoration: BoxDecoration(
        color: isGeneric
            ? const Color(0x22FFCC00) // Translucent amber glass
            : AppColors.surface(context),
        borderRadius: BorderRadius.circular(AppConstants.radiusChip),
        border: Border.all(
          color: isGeneric ? const Color(0xAAFFCC00) : AppColors.border(context),
          width: 0.7,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGeneric ? CupertinoIcons.exclamationmark_circle_fill : CupertinoIcons.link,
            size: 10,
            color: isGeneric ? const Color(0xFFD48800) : AppColors.textSecondary(context),
          ),
          const SizedBox(width: 3),
          Text(
            domain,
            style: AppTypography.micro(context).copyWith(
              color: isGeneric ? const Color(0xFFB26B00) : AppColors.textSecondary(context),
              fontWeight: isGeneric ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
