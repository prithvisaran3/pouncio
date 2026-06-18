import 'dart:ui';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../models/job.dart';
import '../../home/application/jobs_provider.dart';
import '../../home/application/saved_jobs_provider.dart';
import '../../../shared/widgets/classy_app_bar.dart';
import '../../../shared/widgets/freshness_badge.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';

/// JobDetailView — Liquid Glass redesign with CNButton for actions.
class JobDetailView extends ConsumerWidget {
  final String jobId;
  const JobDetailView({super.key, required this.jobId});

  Future<void> _launchApplyUrl(BuildContext context, String urlString) async {
    final uri = Uri.tryParse(urlString);
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        if (context.mounted) _showErrorDialog(context, 'Could not open apply link: $e');
      }
    } else {
      _showErrorDialog(context, 'Invalid apply URL.');
    }
  }

  Future<void> _shareJobLink(BuildContext context, Job job) async {
    final text = 'Check out this early career opportunity!\n\n'
        '${job.role} at ${job.company}\nLocation: ${job.location}\n'
        'Apply here: ${job.applyUrl}\n\nShared via Pouncio.';
    try {
      await Share.share(text, subject: 'Job Opening: ${job.role} at ${job.company}');
    } catch (e) {
      if (context.mounted) _showErrorDialog(context, 'Failed to share: $e');
    }
  }

  /// Returns true if the URL is a generic careers homepage (not a direct job listing).
  bool _isGenericUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return true;
    final path = uri.path.replaceAll('/', '').toLowerCase();
    // Generic if path is empty or only contains 'jobs', 'careers', 'work-at-us'
    final genericPaths = {'', 'jobs', 'careers', 'work', 'opportunities', 'hiring', 'join-us', 'join', 'openings'};
    return genericPaths.contains(path);
  }



  void _showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.of(context).pop())],
      ),
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Job? job = ref.watch<AsyncValue<List<Job>>>(jobsStateProvider).maybeWhen<Job?>(
          data: (List<Job> list) {
            try { return list.firstWhere((j) => j.id == jobId); } catch (_) { return null; }
          },
          orElse: () => null,
        ) ??
        ref.watch<List<Job>>(savedJobsStateProvider).cast<Job?>().firstWhere(
          (j) => j?.id == jobId, orElse: () => null);

    if (job == null) {
      return CupertinoPageScaffold(
        backgroundColor: AppColors.background(context),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const ClassyAppBar(title: 'Job Details'),
              Expanded(
                child: Center(
                  child: Text(
                    'Job not found.',
                    style: TextStyle(fontSize: Responsive.scaleText(context, 16.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isSaved = ref.watch<List<Job>>(savedJobsStateProvider).any((j) => j.id == job.id);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background(context),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ClassyAppBar(
              title: job.company,
              actions: [
                CNButton.icon(
                  icon: CNSymbol(
                    isSaved ? 'bookmark.fill' : 'bookmark',
                    size: Responsive.scale(context, 18.0),
                  ),
                  onPressed: () =>
                      ref.read<SavedJobsState>(savedJobsStateProvider.notifier).toggleSaveJob(job),
                ),
              ],
            ),
            Expanded(
              child: Hero(
                tag: 'job_hero_${job.id}',
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.all(Responsive.scale(context, AppConstants.screenPadding)),
                        children: [
                          // Company badge
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Responsive.scale(context, 12.0),
                                vertical: Responsive.scale(context, 6.0),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(Responsive.scale(context, 20.0)),
                                border: Border.all(color: AppColors.accent.withValues(alpha: 0.35)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CNIcon(symbol: CNSymbol('building.2.fill', size: Responsive.scale(context, 13.0))),
                                  SizedBox(width: Responsive.scale(context, 6.0)),
                                  Text(
                                    job.company,
                                    style: AppTypography.caption(context).copyWith(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: Responsive.scaleText(context, 12.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: Responsive.scale(context, AppConstants.space16)),

                          // Role title
                          Text(
                            job.role,
                            style: AppTypography.display(context).copyWith(
                              fontSize: Responsive.scaleText(context, 28.0),
                            ),
                          ),
                          SizedBox(height: Responsive.scale(context, AppConstants.space8)),

                          // Location + time
                          Row(
                            children: [
                              CNIcon(
                                symbol: CNSymbol('location.fill', size: Responsive.scale(context, 13.0)),
                              ),
                              SizedBox(width: Responsive.scale(context, AppConstants.space4)),
                              Expanded(
                                child: Text(
                                  job.location,
                                  style: AppTypography.bodySecondary(context).copyWith(
                                    fontSize: Responsive.scaleText(context, 14.0),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                timeAgo(job.postedAt),
                                style: AppTypography.caption(context).copyWith(
                                  fontSize: Responsive.scaleText(context, 12.0),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Responsive.scale(context, AppConstants.space16)),

                          // Badges row
                          Row(
                            children: [
                              FreshnessBadge(postedAt: job.postedAt),
                              SizedBox(width: Responsive.scale(context, AppConstants.space8)),
                              _tag(context, _remoteLabel(job.remoteType)),
                              SizedBox(width: Responsive.scale(context, AppConstants.space8)),
                              _tag(context, _sourceLabel(job.source)),
                            ],
                          ),
                          SizedBox(height: Responsive.scale(context, AppConstants.space24)),

                          Container(height: 0.5, color: AppColors.border(context)),
                          SizedBox(height: Responsive.scale(context, AppConstants.space24)),

                          // Spec cards
                          Text(
                            'Job Specifications',
                            style: AppTypography.title(context).copyWith(
                              fontSize: Responsive.scaleText(context, 18.0),
                            ),
                          ),
                          SizedBox(height: Responsive.scale(context, AppConstants.space12)),
                          Row(children: [
                            Expanded(child: _specCard(context, 'Employment', _employmentLabel(job.employmentType))),
                            SizedBox(width: Responsive.scale(context, AppConstants.space12)),
                            Expanded(child: _specCard(context, 'Experience', _experienceLabel(job.experienceLevel))),
                          ]),
                          SizedBox(height: Responsive.scale(context, AppConstants.space12)),
                           Row(children: [
                            Expanded(child: _specCard(context, 'Visa Sponsor', _visaLabel(job.visa))),
                            SizedBox(width: Responsive.scale(context, AppConstants.space12)),
                            Expanded(child: _specCard(context, 'Source', _sourceLabel(job.source))),
                          ]),
                          SizedBox(height: Responsive.scale(context, AppConstants.space24)),

                          // Application Status
                          Text(
                            'Application Status',
                            style: AppTypography.title(context).copyWith(
                              fontSize: Responsive.scaleText(context, 18.0),
                            ),
                          ),
                          SizedBox(height: Responsive.scale(context, AppConstants.space12)),
                          Builder(
                            builder: (context) {
                              final savedJobs = ref.watch(savedJobsStateProvider);
                              final savedJob = savedJobs.firstWhere((j) => j.id == job.id, orElse: () => job);
                              final appliedAt = savedJob.appliedAt;
                              final isApplied = appliedAt != null;

                              return GlassCard(
                                padding: EdgeInsets.all(Responsive.scale(context, AppConstants.space16)),
                                radius: Responsive.scale(context, AppConstants.radiusCard),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(Responsive.scale(context, 10.0)),
                                      decoration: BoxDecoration(
                                        color: isApplied
                                            ? const Color(0x2210B981) // Translucent green
                                            : AppColors.accent.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isApplied ? const Color(0xAA10B981) : AppColors.accent.withValues(alpha: 0.25),
                                        ),
                                      ),
                                      child: Icon(
                                        isApplied ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.paperplane_fill,
                                        color: isApplied ? const Color(0xFF10B981) : AppColors.accent,
                                        size: Responsive.scale(context, 20.0),
                                      ),
                                    ),
                                    SizedBox(width: Responsive.scale(context, AppConstants.space16)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isApplied ? 'Application Submitted' : 'Not Applied yet',
                                            style: TextStyle(
                                              fontSize: Responsive.scaleText(context, 15.0),
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary(context),
                                            ),
                                          ),
                                          SizedBox(height: Responsive.scale(context, 2.0)),
                                          Text(
                                            isApplied 
                                                ? 'Applied on ${formatDate(appliedAt)}'
                                                : 'Mark to keep track of this application',
                                            style: TextStyle(
                                              fontSize: Responsive.scaleText(context, 12.0),
                                              color: AppColors.textSecondary(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: Responsive.scale(context, AppConstants.space8)),
                                    CNButton(
                                      label: isApplied ? 'Undo' : 'Mark Applied',
                                      onPressed: () {
                                        ref.read(savedJobsStateProvider.notifier).toggleAppliedJob(job);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: Responsive.scale(context, AppConstants.space24)),

                          // Description
                          Text(
                            'Description',
                            style: AppTypography.title(context).copyWith(
                              fontSize: Responsive.scaleText(context, 18.0),
                            ),
                          ),
                          SizedBox(height: Responsive.scale(context, AppConstants.space12)),
                          Text(
                            job.description ?? 'No description provided for this opening.',
                            style: AppTypography.body(context).copyWith(
                              fontSize: Responsive.scaleText(context, 15.0),
                              height: 1.6,
                            ),
                          ),

                          // Referral contacts
                          if (job.referralContacts != null && job.referralContacts!.isNotEmpty) ...[
                            SizedBox(height: Responsive.scale(context, AppConstants.space24)),
                            Text(
                              'Referral Contacts',
                              style: AppTypography.title(context).copyWith(
                                  fontSize: Responsive.scaleText(context, 18.0)),
                            ),
                            SizedBox(height: Responsive.scale(context, AppConstants.space12)),
                            ...job.referralContacts!.map((c) => Padding(
                              padding: EdgeInsets.only(bottom: Responsive.scale(context, AppConstants.space8)),
                              child: GlassCard(
                                padding: EdgeInsets.all(Responsive.scale(context, AppConstants.space12)),
                                radius: Responsive.scale(context, AppConstants.radiusChip),
                                child: Row(
                                  children: [
                                    CNIcon(symbol: CNSymbol('envelope.fill', size: Responsive.scale(context, 15.0))),
                                    SizedBox(width: Responsive.scale(context, AppConstants.space8)),
                                    Expanded(
                                      child: Text(
                                        c,
                                        style: AppTypography.body(context).copyWith(
                                          fontSize: Responsive.scaleText(context, 15.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          ],
                          SizedBox(height: Responsive.scale(context, AppConstants.space24)),
                        ],
                      ),
                    ),

                    // ── Sticky Apply/Share bar ────────────────────────────────
                    Builder(
                      builder: (context) {
                        final route = ModalRoute.of(context);
                        final bool isCurrent = route == null || route.isCurrent;

                        if (!isCurrent) {
                          return Container(
                            padding: EdgeInsets.all(Responsive.scale(context, AppConstants.screenPadding)),
                            decoration: BoxDecoration(
                              color: AppColors.glassColor(context).withValues(alpha: 0.95),
                              border: Border(top: BorderSide(color: AppColors.border(context), width: 0.5)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Warning banner if URL is generic
                                if (_isGenericUrl(job.applyUrl)) ...[
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: Responsive.scale(context, 10.0)),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Responsive.scale(context, 12.0),
                                      vertical: Responsive.scale(context, 8.0),
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0x22FFCC00), // Translucent amber glass
                                      borderRadius: BorderRadius.circular(Responsive.scale(context, 10.0)),
                                      border: Border.all(color: const Color(0xAAFFCC00), width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.exclamationmark_triangle_fill,
                                          color: const Color(0xFFD48800),
                                          size: Responsive.scale(context, 14.0),
                                        ),
                                        SizedBox(width: Responsive.scale(context, 6.0)),
                                        Expanded(
                                          child: Text(
                                            'Link leads to a general careers page — search for "${job.role}" once there.',
                                            style: TextStyle(
                                              fontSize: Responsive.scaleText(context, 11.5),
                                              color: const Color(0xFFB26B00),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: Responsive.scale(context, 50.0),
                                        decoration: BoxDecoration(
                                          color: AppColors.accent,
                                          borderRadius: BorderRadius.circular(Responsive.scale(context, 16.0)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.accent.withValues(alpha: 0.3),
                                              blurRadius: Responsive.scale(context, 10.0),
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () => _launchApplyUrl(context, job.applyUrl),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Open Application',
                                                style: TextStyle(
                                                  color: CupertinoColors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Responsive.scaleText(context, 15.5),
                                                  letterSpacing: -0.2,
                                                ),
                                              ),
                                              SizedBox(width: Responsive.scale(context, 6.0)),
                                              Icon(
                                                CupertinoIcons.arrow_up_right,
                                                color: CupertinoColors.white,
                                                size: Responsive.scale(context, 15.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: Responsive.scale(context, AppConstants.space12)),
                                    Container(
                                      width: Responsive.scale(context, 50.0),
                                      height: Responsive.scale(context, 50.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface(context),
                                        borderRadius: BorderRadius.circular(Responsive.scale(context, 16.0)),
                                        border: Border.all(color: AppColors.border(context), width: 0.8),
                                      ),
                                      child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        child: CNIcon(
                                          symbol: CNSymbol('square.and.arrow.up', size: Responsive.scale(context, 20.0)),
                                          color: AppColors.textPrimary(context),
                                        ),
                                        onPressed: () => _shareJobLink(context, job),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }

                        return ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              padding: EdgeInsets.all(Responsive.scale(context, AppConstants.screenPadding)),
                              decoration: BoxDecoration(
                                color: AppColors.glassColor(context),
                                border: Border(top: BorderSide(color: AppColors.border(context), width: 0.5)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Warning banner if URL is generic
                                  if (_isGenericUrl(job.applyUrl)) ...[
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(bottom: Responsive.scale(context, 10.0)),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Responsive.scale(context, 12.0),
                                        vertical: Responsive.scale(context, 8.0),
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0x22FFCC00), // Translucent amber glass
                                        borderRadius: BorderRadius.circular(Responsive.scale(context, 10.0)),
                                        border: Border.all(color: const Color(0xAAFFCC00), width: 1),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.exclamationmark_triangle_fill,
                                            color: const Color(0xFFD48800),
                                            size: Responsive.scale(context, 14.0),
                                          ),
                                          SizedBox(width: Responsive.scale(context, 6.0)),
                                          Expanded(
                                            child: Text(
                                              'Link leads to a general careers page — search for "${job.role}" once there.',
                                              style: TextStyle(
                                                fontSize: Responsive.scaleText(context, 11.5),
                                                color: const Color(0xFFB26B00),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: Responsive.scale(context, 50.0),
                                          decoration: BoxDecoration(
                                            color: AppColors.accent,
                                            borderRadius: BorderRadius.circular(Responsive.scale(context, 16.0)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.accent.withValues(alpha: 0.3),
                                                blurRadius: Responsive.scale(context, 10.0),
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () => _launchApplyUrl(context, job.applyUrl),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Open Application',
                                                  style: TextStyle(
                                                    color: CupertinoColors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Responsive.scaleText(context, 15.5),
                                                    letterSpacing: -0.2,
                                                  ),
                                                ),
                                                SizedBox(width: Responsive.scale(context, 6.0)),
                                                Icon(
                                                  CupertinoIcons.arrow_up_right,
                                                  color: CupertinoColors.white,
                                                  size: Responsive.scale(context, 15.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: Responsive.scale(context, AppConstants.space12)),
                                      Container(
                                        width: Responsive.scale(context, 50.0),
                                        height: Responsive.scale(context, 50.0),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface(context),
                                          borderRadius: BorderRadius.circular(Responsive.scale(context, 16.0)),
                                          border: Border.all(color: AppColors.border(context), width: 0.8),
                                        ),
                                        child: CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          child: CNIcon(
                                            symbol: CNSymbol('square.and.arrow.up', size: Responsive.scale(context, 20.0)),
                                            color: AppColors.textPrimary(context),
                                          ),
                                          onPressed: () => _shareJobLink(context, job),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _specCard(BuildContext context, String header, String value) => GlassCard(
    padding: EdgeInsets.all(Responsive.scale(context, AppConstants.space12)),
    radius: Responsive.scale(context, AppConstants.radiusChip),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: AppTypography.micro(context).copyWith(
            fontSize: Responsive.scaleText(context, 10.0),
          ),
        ),
        SizedBox(height: Responsive.scale(context, AppConstants.space4)),
        Text(
          value,
          style: AppTypography.body(context).copyWith(
            fontWeight: FontWeight.bold,
            fontSize: Responsive.scaleText(context, 14.0),
          ),
        ),
      ],
    ),
  );

  Widget _tag(BuildContext context, String text) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: Responsive.scale(context, AppConstants.space8),
      vertical: Responsive.scale(context, AppConstants.space4),
    ),
    decoration: BoxDecoration(
      color: AppColors.surface(context),
      borderRadius: BorderRadius.circular(Responsive.scale(context, AppConstants.radiusChip)),
      border: Border.all(color: AppColors.border(context), width: 0.5),
    ),
    child: Text(
      text,
      style: AppTypography.micro(context).copyWith(
        color: AppColors.textSecondary(context),
        fontSize: Responsive.scaleText(context, 10.0),
      ),
    ),
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
  String _employmentLabel(EmploymentType t) => switch (t) {
    EmploymentType.fullTime => 'Full Time', EmploymentType.partTime => 'Part Time',
    EmploymentType.internship => 'Internship', EmploymentType.freshGrad => 'Fresh Grad',
  };
  String _experienceLabel(ExperienceLevel l) => switch (l) {
    ExperienceLevel.intern => 'Intern', ExperienceLevel.entry => 'Entry Level',
    ExperienceLevel.associate => 'Associate',
  };
  String _visaLabel(VisaStatus s) => switch (s) {
    VisaStatus.sponsor => 'Available', VisaStatus.noSponsor => 'No Sponsorship',
    VisaStatus.unknown => 'Unknown',
  };
}
