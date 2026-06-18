import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../models/job.dart';
import '../../../models/job_filter.dart';
import '../../filters/application/filters_provider.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';

/// FiltersView — full Liquid Glass filter sheet.
class FiltersView extends ConsumerStatefulWidget {
  const FiltersView({super.key});

  @override
  ConsumerState<FiltersView> createState() => _FiltersViewState();
}

class _FiltersViewState extends ConsumerState<FiltersView> {
  late Set<String> _selectedRoles;
  late Set<EmploymentType> _selectedEmployments;
  late Set<RemoteType> _selectedRemotes;
  late VisaFilterOption _selectedVisa;
  late Set<ExperienceLevel> _selectedExperienceLevels;
  late Set<JobSource> _selectedSources;

  @override
  void initState() {
    super.initState();
    debugPrint('[FiltersView] initState: Initializing active filters...');
    try {
      final f = ref.read(filtersStateProvider);
      debugPrint('[FiltersView] Loaded filter state: $f');
      _selectedRoles = Set<String>.from(f.roleTypes);
      _selectedEmployments = Set<EmploymentType>.from(f.employmentTypes);
      _selectedRemotes = Set<RemoteType>.from(f.remoteTypes);
      _selectedVisa = f.visa;
      _selectedExperienceLevels = Set<ExperienceLevel>.from(f.experienceLevels);
      _selectedSources = Set<JobSource>.from(f.sources ?? []);
      debugPrint('[FiltersView] initState successfully loaded all selections.');
    } catch (e, stack) {
      debugPrint('[FiltersView ERROR] Failed to load active filters in initState: $e\n$stack');
      _selectedRoles = {};
      _selectedEmployments = {};
      _selectedRemotes = {};
      _selectedVisa = VisaFilterOption.any;
      _selectedExperienceLevels = {};
      _selectedSources = {};
    }
  }

  @override
  void dispose() {
    debugPrint('[FiltersView] dispose: Disposing FiltersView state notifier.');
    super.dispose();
  }

  void _resetAll() => setState(() {
    _selectedRoles.clear();
    _selectedEmployments.clear();
    _selectedRemotes.clear();
    _selectedVisa = VisaFilterOption.any;
    _selectedExperienceLevels.clear();
    _selectedSources.clear();
  });

  void _applyFilters() {
    ref.read(filtersStateProvider.notifier).updateFilter(JobFilter(
      roleTypes: _selectedRoles.toList(),
      employmentTypes: _selectedEmployments.toList(),
      remoteTypes: _selectedRemotes.toList(),
      visa: _selectedVisa,
      experienceLevels: _selectedExperienceLevels.toList(),
      sources: _selectedSources.toList(),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[FiltersView] build: Rendering filters sheet...');
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.85,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : CupertinoColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Responsive.scale(context, 24.0))),
      ),
      child: SafeArea(
        top: false,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.only(
                    top: Responsive.scale(context, 12.0),
                    bottom: Responsive.scale(context, 4.0),
                  ),
                  width: Responsive.scale(context, 40.0),
                  height: Responsive.scale(context, 4.0),
                  decoration: BoxDecoration(
                    color: AppColors.border(context),
                    borderRadius: BorderRadius.circular(Responsive.scale(context, 2.0)),
                  ),
                ),

                // Title row
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.scale(context, AppConstants.screenPadding),
                    vertical: Responsive.scale(context, 8.0),
                  ),
                  child: Row(
                    children: [
                      CNButton(
                        label: 'Reset',
                        onPressed: _resetAll,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Filters',
                            style: AppTypography.title(context).copyWith(
                              fontSize: Responsive.scaleText(context, 18.0),
                            ),
                          ),
                        ),
                      ),
                      CNButton(
                        label: 'Done',
                        onPressed: _applyFilters,
                      ),
                    ],
                  ),
                ),

                const _Divider(),

                // Scrollable content
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.scale(context, AppConstants.screenPadding),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(context, 'Work Mode'),
                        _wrapChips(
                          context,
                          RemoteType.values.map((t) {
                            final label = switch (t) {
                              RemoteType.remote => 'Remote',
                              RemoteType.hybrid => 'Hybrid',
                              RemoteType.onsite => 'Onsite',
                            };
                            return _LGChip(
                              label: label,
                              isActive: _selectedRemotes.contains(t),
                              onTap: () => setState(() {
                                _selectedRemotes.contains(t)
                                    ? _selectedRemotes.remove(t)
                                    : _selectedRemotes.add(t);
                              }),
                            );
                          }).toList(),
                        ),

                        _sectionTitle(context, 'Employment Type'),
                        _wrapChips(
                          context,
                          EmploymentType.values.map((t) {
                            final label = switch (t) {
                              EmploymentType.fullTime  => 'Full Time',
                              EmploymentType.partTime  => 'Part Time',
                              EmploymentType.internship=> 'Internship',
                              EmploymentType.freshGrad => 'Fresh Grad',
                            };
                            return _LGChip(
                              label: label,
                              isActive: _selectedEmployments.contains(t),
                              onTap: () => setState(() {
                                _selectedEmployments.contains(t)
                                    ? _selectedEmployments.remove(t)
                                    : _selectedEmployments.add(t);
                              }),
                            );
                          }).toList(),
                        ),

                        _sectionTitle(context, 'Experience Level'),
                        _wrapChips(
                          context,
                          ExperienceLevel.values.map((l) {
                            final label = switch (l) {
                              ExperienceLevel.intern    => 'Intern',
                              ExperienceLevel.entry     => 'Entry Level',
                              ExperienceLevel.associate => 'Associate',
                            };
                            return _LGChip(
                              label: label,
                              isActive: _selectedExperienceLevels.contains(l),
                              onTap: () => setState(() {
                                _selectedExperienceLevels.contains(l)
                                    ? _selectedExperienceLevels.remove(l)
                                    : _selectedExperienceLevels.add(l);
                              }),
                            );
                          }).toList(),
                        ),

                        _sectionTitle(context, 'Source'),
                        _wrapChips(
                          context,
                          JobSource.values.map((s) {
                            final label = switch (s) {
                              JobSource.simplifyJobs => 'SimplifyJobs / GitHub',
                              JobSource.greenhouse   => 'Greenhouse',
                              JobSource.lever        => 'Lever',
                              JobSource.ashby        => 'Ashby',
                              JobSource.linkedIn     => 'LinkedIn',
                              JobSource.handshake    => 'Handshake',
                              JobSource.other        => 'Other',
                            };
                            return _LGChip(
                              label: label,
                              isActive: _selectedSources.contains(s),
                              onTap: () => setState(() {
                                _selectedSources.contains(s)
                                    ? _selectedSources.remove(s)
                                    : _selectedSources.add(s);
                              }),
                            );
                          }).toList(),
                        ),

                        _sectionTitle(context, 'Visa Sponsorship'),
                        _glassRow(
                          context,
                          leading: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sponsorship Required',
                                style: AppTypography.body(context).copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Responsive.scaleText(context, 15.0),
                                ),
                              ),
                              SizedBox(height: Responsive.scale(context, 2.0)),
                              Text(
                                'Only show roles offering visa support',
                                style: AppTypography.caption(context).copyWith(
                                  fontSize: Responsive.scaleText(context, 12.0),
                                ),
                              ),
                            ],
                          ),
                          trailing: CupertinoSwitch(
                            value: _selectedVisa == VisaFilterOption.sponsorOnly,
                            activeTrackColor: AppColors.accent,
                            onChanged: (v) => setState(() {
                              _selectedVisa =
                                  v ? VisaFilterOption.sponsorOnly : VisaFilterOption.any;
                            }),
                          ),
                        ),

                        _sectionTitle(context, 'Role Keywords'),
                        _wrapChips(
                          context,
                          AppConstants.roleTypes.map((role) {
                            return _LGChip(
                              label: role,
                              isActive: _selectedRoles.contains(role),
                              onTap: () => setState(() {
                                _selectedRoles.contains(role)
                                    ? _selectedRoles.remove(role)
                                    : _selectedRoles.add(role);
                              }),
                            );
                          }).toList(),
                        ),

                        SizedBox(height: Responsive.scale(context, AppConstants.space32)),
                      ],
                    ),
                  ),
                ),

                // Apply button
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    Responsive.scale(context, AppConstants.screenPadding),
                    Responsive.scale(context, 8.0),
                    Responsive.scale(context, AppConstants.screenPadding),
                    Responsive.scale(context, AppConstants.space16),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: CNButton(
                      label: 'Apply Filters',
                      onPressed: _applyFilters,
                    ),
                  ),
                ),
              ],
            ),
          ),
      );
    }

  Widget _sectionTitle(BuildContext context, String title) => Padding(
    padding: EdgeInsets.only(
      top: Responsive.scale(context, 20.0),
      bottom: Responsive.scale(context, 10.0),
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

  Widget _wrapChips(BuildContext context, List<Widget> chips) => Wrap(
    spacing: Responsive.scale(context, AppConstants.space8),
    runSpacing: Responsive.scale(context, AppConstants.space8),
    children: chips,
  );

  Widget _glassRow(BuildContext context,
      {required Widget leading, required Widget trailing}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.scale(context, AppConstants.space16),
        vertical: Responsive.scale(context, AppConstants.space12),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface(context).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(Responsive.scale(context, 16.0)),
        border: Border.all(color: AppColors.border(context), width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(child: leading),
          trailing,
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => Container(
    height: Responsive.scale(context, 0.5),
    color: AppColors.border(context),
  );
}

/// Liquid glass chip used inside the filter sheet.
class _LGChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _LGChip({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.scale(context, 14.0),
          vertical: Responsive.scale(context, 8.0),
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.accent
              : (isDark ? const Color(0x22FFFFFF) : const Color(0x12000000)),
          borderRadius: BorderRadius.circular(Responsive.scale(context, 20.0)),
          border: Border.all(
            color: isActive
                ? AppColors.accent
                : (isDark ? const Color(0x30FFFFFF) : const Color(0x20000000)),
            width: isActive ? 1.2 : 0.8,
          ),
          boxShadow: isActive
              ? [BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.35),
                  blurRadius: Responsive.scale(context, 8.0),
                )]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: Responsive.scaleText(context, 13.5),
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? CupertinoColors.white : AppColors.textSecondary(context),
          ),
        ),
      ),
    );
  }
}
