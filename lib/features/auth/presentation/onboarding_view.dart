import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' hide GlassCard;

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../services/auth_provider.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  int _currentStep = 0; // 0 for Education, 1 for Job Preferences
  final _uniController = TextEditingController();
  final _majorController = TextEditingController();
  final _gradDateController = TextEditingController();

  bool _visaNeeded = false;
  int _remotePrefIndex = 0; // 0: Remote, 1: Hybrid, 2: Onsite
  final List<String> _selectedSkills = [];

  final List<String> _presetSkills = [
    'Flutter', 'iOS', 'Android', 'React Native', 'Swift', 'Kotlin',
    'Python', 'Node.js', 'TypeScript', 'Java', 'C++', 'AWS'
  ];

  @override
  void dispose() {
    _uniController.dispose();
    _majorController.dispose();
    _gradDateController.dispose();
    super.dispose();
  }

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
  }

  Future<void> _handleFinish() async {
    final uni = _uniController.text.trim();
    final major = _majorController.text.trim();
    final grad = _gradDateController.text.trim();

    if (uni.isEmpty || major.isEmpty || grad.isEmpty) {
      await showCupertinoDialog<void>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Required'),
          content: const Text('Please complete your education profile details.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    final remotePref = switch (_remotePrefIndex) {
      0 => 'remote',
      1 => 'hybrid',
      _ => 'onsite',
    };

    try {
      await ref.read(authServiceProvider).saveOnboardingData(
            university: uni,
            major: major,
            graduationDate: grad,
            visaNeeded: _visaNeeded,
            skills: _selectedSkills,
            remotePreference: remotePref,
          );
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (!mounted) return;
      await showCupertinoDialog<void>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Onboarding Error'),
          content: Text(e.toString()),
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background(context),
      child: Stack(
        children: [
          // Background Glows
          Positioned(
            bottom: -50,
            right: -50,
            child: IgnorePointer(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.08),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.08),
                      blurRadius: 100,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(Responsive.scale(context, AppConstants.screenPadding)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Indicator
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: _currentStep >= 1
                                ? AppColors.accent
                                : AppColors.border(context),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.scale(context, 24.0)),

                  Text(
                    _currentStep == 0 ? 'Educational Background' : 'Career Preferences',
                    style: AppTypography.display(context).copyWith(
                      fontSize: Responsive.scaleText(context, 26.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _currentStep == 0
                        ? 'Tell us about your college and major.'
                        : 'Configure your early career parameters.',
                    style: AppTypography.bodySecondary(context).copyWith(
                      fontSize: Responsive.scaleText(context, 14.0),
                    ),
                  ),
                  SizedBox(height: Responsive.scale(context, 28.0)),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: _currentStep == 0 ? _buildEducationStep() : _buildPreferencesStep(),
                    ),
                  ),

                  // Bottom Action Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                        CupertinoButton(
                          child: Text(
                            'Back',
                            style: TextStyle(
                              color: AppColors.textSecondary(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () => setState(() => _currentStep--),
                        )
                      else
                        const SizedBox.shrink(),
                      SizedBox(
                        width: Responsive.scale(context, 140.0),
                        height: Responsive.scale(context, 44.0),
                        child: CNButton(
                          label: _currentStep == 0 ? 'Next' : 'Finish Setup',
                          onPressed: () {
                            if (_currentStep == 0) {
                              setState(() => _currentStep = 1);
                            } else {
                              _handleFinish();
                            }
                          },
                          style: CNButtonStyle.filled,
                          tint: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationStep() {
    return Column(
      children: [
        GlassTextField(
          controller: _uniController,
          placeholder: 'University / College',
          prefixIcon: Icon(
            CupertinoIcons.book,
            size: Responsive.scale(context, 18.0),
            color: AppColors.textSecondary(context),
          ),
          useOwnLayer: true,
        ),
        SizedBox(height: Responsive.scale(context, 14.0)),
        GlassTextField(
          controller: _majorController,
          placeholder: 'Major (e.g. Computer Science)',
          prefixIcon: Icon(
            CupertinoIcons.device_laptop,
            size: Responsive.scale(context, 18.0),
            color: AppColors.textSecondary(context),
          ),
          useOwnLayer: true,
        ),
        SizedBox(height: Responsive.scale(context, 14.0)),
        GlassTextField(
          controller: _gradDateController,
          placeholder: 'Graduation Date (e.g. May 2026)',
          prefixIcon: Icon(
            CupertinoIcons.calendar,
            size: Responsive.scale(context, 18.0),
            color: AppColors.textSecondary(context),
          ),
          useOwnLayer: true,
        ),
      ],
    );
  }

  Widget _buildPreferencesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Work mode
        Text(
          'WORK MODE PREFERENCE',
          style: AppTypography.caption(context).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Responsive.scale(context, 8.0)),
        GlassCard(
          padding: EdgeInsets.all(Responsive.scale(context, 12.0)),
          child: SizedBox(
            width: double.infinity,
            child: GlassSegmentedControl(
              segments: const ['Remote', 'Hybrid', 'Onsite'],
              selectedIndex: _remotePrefIndex,
              onSegmentSelected: (i) => setState(() => _remotePrefIndex = i),
              useOwnLayer: true,
              indicatorColor: AppColors.accent,
              height: Responsive.scale(context, 34.0),
              borderRadius: Responsive.scale(context, 17.0),
              selectedTextStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.white,
              ),
              unselectedTextStyle: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
        ),
        SizedBox(height: Responsive.scale(context, 20.0)),

        // Visa
        Text(
          'VISA SPONSORSHIP STATUS',
          style: AppTypography.caption(context).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Responsive.scale(context, 8.0)),
        GlassCard(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.scale(context, 16.0),
            vertical: Responsive.scale(context, 12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sponsorship Required',
                      style: AppTypography.body(context).copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.scaleText(context, 14.5),
                      ),
                    ),
                    Text(
                      'Only search jobs with sponsorship support',
                      style: AppTypography.caption(context).copyWith(
                        fontSize: Responsive.scaleText(context, 11.5),
                      ),
                    ),
                  ],
                ),
              ),
              GlassSwitch(
                value: _visaNeeded,
                activeColor: AppColors.accent,
                useOwnLayer: true,
                onChanged: (v) => setState(() => _visaNeeded = v),
              ),
            ],
          ),
        ),
        SizedBox(height: Responsive.scale(context, 20.0)),

        // Skills
        Text(
          'SELECT YOUR SKILLS / FOCUS AREAS',
          style: AppTypography.caption(context).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Responsive.scale(context, 8.0)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _presetSkills.map((skill) {
            final isSelected = _selectedSkills.contains(skill);
            return GestureDetector(
              onTap: () => _toggleSkill(skill),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accent.withValues(alpha: 0.95)
                      : AppColors.glassColor(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : AppColors.border(context),
                    width: 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? CupertinoColors.white : AppColors.textSecondary(context),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: Responsive.scale(context, 24.0)),
      ],
    );
  }
}
