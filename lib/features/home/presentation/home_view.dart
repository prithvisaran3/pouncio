import 'dart:ui';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' hide GlassCard;
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../models/job.dart';
import '../../../models/notification_item.dart';
import '../application/jobs_provider.dart';
import '../application/saved_jobs_provider.dart';
import '../../filters/presentation/filters_view.dart';
import '../../filters/application/filters_provider.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/freshness_badge.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/scraper_progress_loader.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';

/// HomeView — full Liquid Glass UI powered by cupertino_native.
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late final ScrollController _scrollController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final offset = _scrollController.offset;
      if (offset != _scrollOffset) {
        setState(() {
          _scrollOffset = offset;
        });
      }
    }
  }

  /// Unified refresh handler — triggered by both the top-right button and pull-to-refresh.
  Future<void> _handleRefresh() async {
    final stats = await ref.read(jobsStateProvider.notifier).refresh();
    if (!mounted) return;
    if (stats != null) {
      final newCount = stats['newJobs'] as int? ?? 0;
      final newIds = List<String>.from((stats['newJobIds'] as List<dynamic>?) ?? <dynamic>[]);
      ref.read(newlyAddedJobIdsProvider.notifier).state = newIds;
      await showCupertinoDialog<void>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Refresh Complete'),
          content: Text(
            newCount > 0
                ? 'Found $newCount new job${newCount == 1 ? '' : 's'} matching your profile.'
                : 'No new jobs were added. All listings are up to date!',
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      await showCupertinoDialog<void>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Refresh Complete'),
          content: const Text('Refresh completed. Check the feed for updates.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  void _onTabChanged(int index) {
    final option = index == 0 ? ProfileFilterOption.all : ProfileFilterOption.myProfile;
    ref.read(profileFilterStateProvider.notifier).setOption(option);
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(jobsStateProvider);
    final filteredList = ref.watch(filteredJobsProvider);
    final isManualRefreshing = ref.watch(isManualRefreshingProvider);
    final profileOption = ref.watch(profileFilterStateProvider);
    final tabIndex = profileOption == ProfileFilterOption.all ? 0 : 1;

    final safeAreaTop = MediaQuery.paddingOf(context).top;
    const double collapseThreshold = 80.0;
    final double t = _scrollOffset.clamp(0.0, collapseThreshold) / collapseThreshold;

    // Title row fades out and collapses from height 60 to 0
    final double titleHeight = (1.0 - t) * Responsive.scale(context, 60.0);
    final double titleOpacity = 1.0 - t;

    // Overall dynamic top padding for the feed list
    final double topPadding = safeAreaTop + Responsive.scale(context, 144.0);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background(context),
      child: Stack(
        children: [
          // ── Ambient Glass Glows ──────────────────────────────────────
          Positioned(
            top: -50,
            right: -50,
            child: IgnorePointer(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.07),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.07),
                      blurRadius: 100,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 280,
            left: -80,
            child: IgnorePointer(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF10B981).withValues(alpha: 0.04),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.04),
                      blurRadius: 100,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Feed ─────────────────────────────────────────────────────
          jobsAsync.when(
            data: (_) {
              if (filteredList.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: topPadding),
                    child: EmptyState(
                      icon: CupertinoIcons.search,
                      title: 'No Matching Jobs',
                      message: 'Try adjusting your filters or switching to "All Jobs".',
                      action: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CNButton(
                            label: 'Open Filters',
                            onPressed: () => _openFilters(context),
                          ),
                          const SizedBox(height: AppConstants.space8),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Text(
                              'Clear All Filters',
                              style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              ref.read(filtersStateProvider.notifier).resetFilter();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return _buildFeedList(context, ref, filteredList, topPadding);
            },
            loading: () {
              if (isManualRefreshing) {
                final bottomMargin = MediaQuery.paddingOf(context).bottom + Responsive.scale(context, 12.0);
                final barHeight = Responsive.scale(context, 58.0);
                return Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: topPadding,
                      bottom: bottomMargin + barHeight,
                    ),
                    child: const Center(
                      child: ScraperProgressLoader(),
                    ),
                  ),
                );
              }
              return _buildShimmerFeed(context, topPadding);
            },
            error: (err, _) => Center(
              child: ErrorState(
                message: err.toString(),
                onRetry: () => ref.read(jobsStateProvider.notifier).refresh(),
              ),
            ),
          ),

          // ── Sticky Liquid Glass Header ────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: _LiquidGlassHeader(
              scrollOffset: _scrollOffset,
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top row (Collapsible)
                    SizedBox(
                      height: titleHeight,
                      child: Opacity(
                        opacity: titleOpacity,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Container(
                            height: Responsive.scale(context, 60.0),
                            padding: EdgeInsets.fromLTRB(
                              Responsive.scale(context, AppConstants.screenPadding),
                              Responsive.scale(context, 6.0),
                              Responsive.scale(context, 4.0),
                              0,
                            ),
                            child: Row(
                              children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Pouncio',
                                        style: TextStyle(
                                          fontFamily: 'Georgia',
                                          fontWeight: FontWeight.w900,
                                          fontStyle: FontStyle.italic,
                                          fontSize: Responsive.scaleText(context, 28.0),
                                          color: AppColors.textPrimary(context),
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                // Refresh
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: Responsive.scale(context, 12.0),
                                  ),
                                  child: jobsAsync.maybeWhen(
                                    loading: () => Padding(
                                      padding: EdgeInsets.all(Responsive.scale(context, 6.0)),
                                      child: const CupertinoActivityIndicator(color: AppColors.accent),
                                    ),
                                    orElse: () => GlassButton(
                                      icon: Icon(
                                        CupertinoIcons.arrow_clockwise,
                                        size: Responsive.scale(context, 18.0),
                                        color: AppColors.textPrimary(context),
                                      ),
                                      onTap: () {
                                        debugPrint('[Refresh Button] Tapped (GlassButton), triggering refresh...');
                                        _handleRefresh();
                                      },
                                      useOwnLayer: true,
                                      width: Responsive.scale(context, 36.0),
                                      height: Responsive.scale(context, 36.0),
                                      shape: const LiquidOval(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Profile Segmented Control & Filter button (native Liquid Glass)
                    Padding(
                      padding: EdgeInsets.only(
                        left: Responsive.scale(context, AppConstants.screenPadding),
                        right: Responsive.scale(context, AppConstants.screenPadding),
                        top: Responsive.scale(context, 6.0),
                        bottom: Responsive.scale(context, 16.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GlassSegmentedControl(
                              segments: const ['All Jobs', 'My Profile'],
                              selectedIndex: tabIndex,
                              onSegmentSelected: _onTabChanged,
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
                          SizedBox(width: Responsive.scale(context, 10.0)),
                          GlassButton.custom(
                            onTap: () {
                              debugPrint('[Filters Button] Tapped (GlassButton), triggering _openFilters...');
                              _openFilters(context);
                            },
                            persistPressOnDrag: false,
                            useOwnLayer: true,
                            width: Responsive.scale(context, 36.0),
                            height: Responsive.scale(context, 36.0),
                            shape: const LiquidOval(),
                            child: Center(
                              child: Icon(
                                CupertinoIcons.slider_horizontal_3,
                                size: Responsive.scale(context, 18.0),
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: Responsive.scale(context, AppConstants.screenPadding),
                        right: Responsive.scale(context, AppConstants.screenPadding),
                        bottom: Responsive.scale(context, 14.0),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${filteredList.length} US jobs found',
                          style: AppTypography.caption(context).copyWith(
                            fontSize: Responsive.scaleText(context, 12.0),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerFeed(BuildContext context, double topPadding) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final baseColor = isDark ? const Color(0x1BFFFFFF) : const Color(0x0C000000);
    final highlightColor = isDark ? const Color(0x33FFFFFF) : const Color(0x1A000000);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          Responsive.scale(context, AppConstants.screenPadding),
          topPadding + Responsive.scale(context, 12.0),
          Responsive.scale(context, AppConstants.screenPadding),
          Responsive.scale(context, 100.0),
        ),
        itemCount: 4,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: Responsive.scale(context, AppConstants.space12)),
          child: Container(
            height: Responsive.scale(context, 140.0),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(Responsive.scale(context, AppConstants.radiusCard)),
            ),
          ),
        ),
      ),
    );
  }

  void _openFilters(BuildContext context) {
    debugPrint('[HomeView] _openFilters: Invoking showCupertinoModalPopup...');
    ref.read(isFiltersOpenProvider.notifier).state = true;
    try {
      showCupertinoModalPopup<void>(
        context: context,
        useRootNavigator: true,
        builder: (context) {
          debugPrint('[HomeView] _openFilters modal builder: constructing FiltersView');
          return const FiltersView();
        },
      ).then((_) {
        debugPrint('[HomeView] _openFilters: modal popup dismissed, resetting isFiltersOpenProvider');
        ref.read(isFiltersOpenProvider.notifier).state = false;
      });
      debugPrint('[HomeView] _openFilters: showCupertinoModalPopup called successfully.');
    } catch (e, stack) {
      debugPrint('[HomeView ERROR] _openFilters failed to open popup: $e\n$stack');
      ref.read(isFiltersOpenProvider.notifier).state = false;
    }
  }

  Widget _buildFeedList(BuildContext context, WidgetRef ref, List<Job> jobs, double topPadding) {
    final newlyAddedIds = ref.watch(newlyAddedJobIdsProvider);
    final now = DateTime.now().toUtc();
    final newOpenings = <Job>[];
    final postedNow = <Job>[];
    final recent = <Job>[];
    final today = <Job>[];
    final earlier = <Job>[];

    for (final job in jobs) {
      if (newlyAddedIds.contains(job.id)) {
        newOpenings.add(job);
        continue;
      }
      final tier = NotificationItem.computeFreshnessTier(job.postedAt, now);
      switch (tier) {
        case FreshnessTier.now:    postedNow.add(job);
        case FreshnessTier.recent: recent.add(job);
        case FreshnessTier.today:  today.add(job);
        case FreshnessTier.older:  earlier.add(job);
      }
    }

    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: topPadding)),
        CupertinoSliverRefreshControl(
          onRefresh: _handleRefresh,
        ),
        if (newOpenings.isNotEmpty) ...[ _headerSliver(context, 'New Openings'), _cardsSliver(newOpenings) ],
        if (postedNow.isNotEmpty)   ...[ _headerSliver(context, 'Posted Now (<30m)'), _cardsSliver(postedNow) ],
        if (recent.isNotEmpty)      ...[ _headerSliver(context, 'Recent (<1h)'),     _cardsSliver(recent)   ],
        if (today.isNotEmpty)       ...[ _headerSliver(context, 'Today (<24h)'),      _cardsSliver(today)    ],
        if (earlier.isNotEmpty)     ...[ _headerSliver(context, 'Earlier Opportunities'), _cardsSliver(earlier)  ],
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.paddingOf(context).bottom + Responsive.scale(context, 84.0),
          ),
        ),
      ],
    );
  }

  Widget _headerSliver(BuildContext context, String title) => SliverToBoxAdapter(
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        Responsive.scale(context, AppConstants.screenPadding),
        Responsive.scale(context, 6.0),
        Responsive.scale(context, AppConstants.screenPadding),
        Responsive.scale(context, 8.0),
      ),
      child: Text(
        title,
        style: AppTypography.title(context).copyWith(
          fontSize: Responsive.scaleText(context, 16.0),
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );

  Widget _cardsSliver(List<Job> jobs) => SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: Responsive.scale(context, AppConstants.screenPadding)),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          final job = jobs[i];
          return Padding(
            padding: EdgeInsets.only(bottom: Responsive.scale(context, AppConstants.space12)),
            child: Consumer(
              builder: (context, ref, _) {
                final isSaved = ref.watch(savedJobsStateProvider).any((j) => j.id == job.id);
                return RepaintBoundary(
                  child: Hero(
                    tag: 'job_hero_${job.id}',
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
                              Row(
                                children: [
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                onPressed: () => ref
                                    .read(savedJobsStateProvider.notifier)
                                    .toggleSaveJob(job),
                                child: Icon(
                                  isSaved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                                  size: Responsive.scale(context, 18.0),
                                  color: isSaved ? AppColors.accent : AppColors.textSecondary(context),
                                ),
                              ),
                                ],
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
          );
        },
        childCount: jobs.length,
      ),
    ),
  );

  Widget _tag(BuildContext context, String text) => Container(
    padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.space8, vertical: AppConstants.space4),
    decoration: BoxDecoration(
      color: AppColors.surface(context),
      borderRadius: BorderRadius.circular(AppConstants.radiusChip),
      border: Border.all(color: AppColors.border(context), width: 0.5),
    ),
    child: Text(text,
        style: AppTypography.micro(context).copyWith(color: AppColors.textSecondary(context))),
  );

  String _remoteLabel(RemoteType t) => switch (t) {
    RemoteType.remote => 'Remote', RemoteType.hybrid => 'Hybrid', RemoteType.onsite => 'Onsite',
  };

  String _sourceLabel(JobSource s) => switch (s) {
    JobSource.simplifyJobs => 'Simplify', JobSource.greenhouse => 'Greenhouse',
    JobSource.lever => 'Lever', JobSource.ashby => 'Ashby', JobSource.linkedIn => 'LinkedIn',
    JobSource.handshake => 'Handshake',
    JobSource.other => 'Other',
  };

  /// Shows the actual domain from which the job was fetched (e.g. greenhouse.io/stripe).
  /// Adds an orange dot if the URL is a generic homepage instead of a direct listing.
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
          color: isGeneric
              ? const Color(0xAAFFCC00)
              : AppColors.border(context),
          width: 0.7,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGeneric
                ? CupertinoIcons.exclamationmark_circle_fill
                : CupertinoIcons.link,
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

// ── Liquid Glass frosted header background ───────────────────────────────────
class _LiquidGlassHeader extends ConsumerWidget {
  final Widget child;
  final double scrollOffset;
  const _LiquidGlassHeader({required this.child, required this.scrollOffset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isFiltersOpen = ref.watch(isFiltersOpenProvider);
    // Show glass background only when we have scrolled down past the top, OR filters are open.
    // This removes the blur when at the very top, fixing the blurry logo and revealing the glass buttons.
    final bool showBackground = scrollOffset > 0.0 || isFiltersOpen;

    return ClipRect(
      child: Stack(
        children: [
          if (showBackground)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  color: AppColors.glassColor(context),
                ),
              ),
            ),
          RepaintBoundary(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: showBackground ? AppColors.border(context) : const Color(0x00000000), 
                    width: 0.4
                  )
                ),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}


