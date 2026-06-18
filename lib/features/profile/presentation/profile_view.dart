import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' hide GlassCard;

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../models/app_settings.dart';
import '../../../models/job_filter.dart';
import '../../../services/auth_provider.dart';
import '../../../services/profile_provider.dart';
import '../../filters/application/filters_provider.dart';
import '../../filters/presentation/filters_view.dart';
import '../../settings/application/settings_provider.dart';
import '../../../shared/widgets/classy_app_bar.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  void _openFilters(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      useRootNavigator: true,
      builder: (context) => const FiltersView(),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) => Padding(
        padding: EdgeInsets.only(
          left: Responsive.scale(context, 4.0),
          bottom: Responsive.scale(context, 8.0),
          top: Responsive.scale(context, 24.0),
        ),
        child: Text(
          title.toUpperCase(),
          style: AppTypography.caption(context).copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.6,
            fontSize: Responsive.scaleText(context, 12.0),
          ),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStateProvider);
    final activeFilter = ref.watch(filtersStateProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background(context),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ClassyAppBar(title: 'Profile'),
            Expanded(
              child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(Responsive.scale(context, AppConstants.screenPadding)),
                      children: [
                        // ── Profile / Bio Header ─────────────────────────────
                        profileAsync.when(
                          data: (profile) {
                            if (profile == null) {
                              return const Center(child: Text('No profile loaded.'));
                            }
                            final name = (profile['fullName'] as String?) ?? 'Grad Intern';
                            final email = (profile['email'] as String?) ?? '';
                            final phone = (profile['phoneNumber'] as String?) ?? '';
                            final university = (profile['university'] as String?) ?? 'University';
                            final major = (profile['major'] as String?) ?? 'Major';
                            final gradDate = (profile['graduationDate'] as String?) ?? 'Grad Date';
                            final skills = List<String>.from((profile['skills'] as Iterable?) ?? const <dynamic>[]);

                            return GlassCard(
                              radius: AppConstants.radiusCard,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: Responsive.scale(context, 52.0),
                                        height: Responsive.scale(context, 52.0),
                                        decoration: BoxDecoration(
                                          color: AppColors.accent.withValues(alpha: 0.15),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: AppColors.accent, width: 1.5),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            CupertinoIcons.person_solid,
                                            size: Responsive.scale(context, 26.0),
                                            color: AppColors.accent,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: Responsive.scale(context, 14.0)),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: AppTypography.title(context).copyWith(
                                                fontSize: Responsive.scaleText(context, 18.0),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              email,
                                              style: AppTypography.caption(context).copyWith(
                                                fontSize: Responsive.scaleText(context, 12.0),
                                              ),
                                            ),
                                            if (phone.isNotEmpty) ...[
                                              const SizedBox(height: 1),
                                              Text(
                                                phone,
                                                style: AppTypography.caption(context).copyWith(
                                                  fontSize: Responsive.scaleText(context, 12.0),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Responsive.scale(context, 18.0)),
                                  Container(height: 0.5, color: AppColors.border(context)),
                                  SizedBox(height: Responsive.scale(context, 14.0)),

                                  // Academic Bio details
                                  _bioDetailRow(context, CupertinoIcons.book, 'Education', '$university — $major'),
                                  SizedBox(height: Responsive.scale(context, 8.0)),
                                  _bioDetailRow(context, CupertinoIcons.calendar, 'Graduation', gradDate),

                                  if (skills.isNotEmpty) ...[
                                    SizedBox(height: Responsive.scale(context, 14.0)),
                                    Text(
                                      'Skills',
                                      style: AppTypography.caption(context).copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Responsive.scaleText(context, 11.0),
                                      ),
                                    ),
                                    SizedBox(height: Responsive.scale(context, 6.0)),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: skills.map((s) => Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface(context),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: AppColors.border(context), width: 0.5),
                                        ),
                                        child: Text(
                                          s,
                                          style: AppTypography.micro(context).copyWith(
                                            color: AppColors.textSecondary(context),
                                            fontSize: 10.5,
                                          ),
                                        ),
                                      )).toList(),
                                    ),
                                  ],

                                  SizedBox(height: Responsive.scale(context, 20.0)),
                                  // Logout Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: Responsive.scale(context, 40.0),
                                    child: CupertinoButton(
                                      color: const Color(0x11FF3B30),
                                      borderRadius: BorderRadius.circular(Responsive.scale(context, 12.0)),
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        await ref.read(authServiceProvider).signOut();
                                        if (context.mounted) {
                                          context.go('/login');
                                        }
                                      },
                                      child: const Text(
                                        'Log Out',
                                        style: TextStyle(
                                          color: Color(0xFFFF3B30),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          loading: () => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                          error: (e, _) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text('Error loading profile: $e'),
                            ),
                          ),
                        ),

                        // ── Notifications ────────────────────────────────────
                        _sectionHeader(context, 'Notifications'),
                        GlassCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Responsive.scale(context, AppConstants.space16),
                                  vertical: Responsive.scale(context, AppConstants.space12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Real-Time Alerts',
                                            style: AppTypography.body(context).copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: Responsive.scaleText(context, 15.0),
                                            ),
                                          ),
                                          SizedBox(height: Responsive.scale(context, 2.0)),
                                          Text(
                                            'Notify on new matching roles',
                                            style: AppTypography.caption(context).copyWith(
                                              fontSize: Responsive.scaleText(context, 12.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GlassSwitch(
                                      value: settings.notificationsEnabled,
                                      activeColor: AppColors.accent,
                                      useOwnLayer: true,
                                      onChanged: (v) => ref
                                          .read(settingsStateProvider.notifier)
                                          .toggleNotifications(v),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: Responsive.scale(context, 0.5),
                                color: AppColors.border(context),
                                margin: EdgeInsets.symmetric(
                                  horizontal: Responsive.scale(context, AppConstants.space16),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Responsive.scale(context, AppConstants.space16),
                                  vertical: Responsive.scale(context, AppConstants.space16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Freshness Threshold',
                                          style: AppTypography.body(context).copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: Responsive.scaleText(context, 15.0),
                                          ),
                                        ),
                                        Text(
                                          '${settings.freshnessThresholdMinutes} mins',
                                          style: AppTypography.body(context).copyWith(
                                            color: AppColors.accent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: Responsive.scaleText(context, 15.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Responsive.scale(context, 4.0)),
                                    Text(
                                      'Only notify for roles posted within this limit',
                                      style: AppTypography.caption(context).copyWith(
                                        fontSize: Responsive.scaleText(context, 12.0),
                                      ),
                                    ),
                                    SizedBox(height: Responsive.scale(context, AppConstants.space12)),
                                    GlassSlider(
                                      value: settings.freshnessThresholdMinutes.toDouble(),
                                      min: 15,
                                      max: 180,
                                      activeColor: AppColors.accent,
                                      useOwnLayer: true,
                                      onChanged: (v) {
                                        if (settings.notificationsEnabled) {
                                          ref
                                              .read(settingsStateProvider.notifier)
                                              .updateThreshold(v.round());
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Scheduler Profile ────────────────────────────────
                        _sectionHeader(context, 'Scheduler Profile'),
                        GlassCard(
                          padding: EdgeInsets.all(Responsive.scale(context, AppConstants.space16)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Watch Engine Cycle',
                                      style: AppTypography.body(context).copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Responsive.scaleText(context, 15.0),
                                      ),
                                    ),
                                    SizedBox(height: Responsive.scale(context, 2.0)),
                                    Text(
                                      'Syncing occurs in the background',
                                      style: AppTypography.caption(context).copyWith(
                                        fontSize: Responsive.scaleText(context, 12.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Every ${settings.refreshFrequencyMinutes} min',
                                style: AppTypography.body(context).copyWith(
                                  color: AppColors.textSecondary(context),
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.scaleText(context, 15.0),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Appearance ───────────────────────────────────────
                        _sectionHeader(context, 'Appearance'),
                        GlassCard(
                          padding: EdgeInsets.all(Responsive.scale(context, AppConstants.space16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Theme',
                                style: AppTypography.body(context).copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Responsive.scaleText(context, 15.0),
                                ),
                              ),
                              SizedBox(height: Responsive.scale(context, AppConstants.space12)),
                              SizedBox(
                                width: double.infinity,
                                child: GlassSegmentedControl(
                                  segments: const ['Light', 'Dark', 'System'],
                                  selectedIndex: switch (settings.theme) {
                                    AppTheme.light => 0,
                                    AppTheme.dark => 1,
                                    AppTheme.system => 2,
                                  },
                                  onSegmentSelected: (i) {
                                    final theme = switch (i) {
                                      0 => AppTheme.light,
                                      1 => AppTheme.dark,
                                      _ => AppTheme.system,
                                    };
                                    ref.read(settingsStateProvider.notifier).updateTheme(theme);
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
                            ],
                          ),
                        ),

                        // ── Search Settings ──────────────────────────────────
                        _sectionHeader(context, 'Default Search Settings'),
                        GlassCard(
                          padding: EdgeInsets.all(Responsive.scale(context, AppConstants.space16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Active Filter Profile',
                                    style: AppTypography.body(context).copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Responsive.scaleText(context, 15.0),
                                    ),
                                  ),
                                  CNButton(
                                    label: 'Configure',
                                    onPressed: () => _openFilters(context),
                                  ),
                                ],
                              ),
                              SizedBox(height: Responsive.scale(context, AppConstants.space8)),
                              Text(
                                activeFilter.roleTypes.isEmpty
                                    ? 'Roles: All matches'
                                    : 'Roles: ${activeFilter.roleTypes.join(', ')}',
                                style: AppTypography.caption(context).copyWith(
                                  fontSize: Responsive.scaleText(context, 12.0),
                                ),
                              ),
                              SizedBox(height: Responsive.scale(context, AppConstants.space4)),
                              Text(
                                'Work Modes: ${activeFilter.remoteTypes.isEmpty ? 'All' : activeFilter.remoteTypes.map((e) => e.name).join(', ')}',
                                style: AppTypography.caption(context).copyWith(
                                  fontSize: Responsive.scaleText(context, 12.0),
                                ),
                              ),
                              SizedBox(height: Responsive.scale(context, AppConstants.space4)),
                              Text(
                                'Sponsorship: ${activeFilter.visa == VisaFilterOption.sponsorOnly ? 'Sponsor only' : 'Any'}',
                                style: AppTypography.caption(context).copyWith(
                                  fontSize: Responsive.scaleText(context, 12.0),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.paddingOf(context).bottom + Responsive.scale(context, 84.0),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bioDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: Responsive.scale(context, 14.0),
          color: AppColors.textSecondary(context),
        ),
        SizedBox(width: Responsive.scale(context, 8.0)),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: Responsive.scaleText(context, 12.5),
                color: AppColors.textPrimary(context),
              ),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(color: AppColors.textSecondary(context), fontWeight: FontWeight.w500),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
