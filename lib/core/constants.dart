import 'package:flutter/cupertino.dart';

/// AppConstants defines spacing, layout, shadows, animation durations, and static strings.
class AppConstants {
  AppConstants._();

  // Spacing Scale
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;

  // Screen layout defaults
  static const double screenPadding = 20.0;

  // Radius values
  static const double radiusCard = 20.0;
  static const double radiusChip = 12.0;
  static const double radiusSheet = 28.0;

  // Shadows
  static List<BoxShadow> softShadow(BuildContext context) {
    final Brightness brightness = CupertinoTheme.brightnessOf(context);
    if (brightness == Brightness.dark) {
      return [
        const BoxShadow(
          color: Color(0x33000000),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ];
    } else {
      return [
        const BoxShadow(
          color: Color(0x0F000000), // rgba(0,0,0,0.06)
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ];
    }
  }

  // Blur values
  static const double glassBlurSigma = 20.0;

  // Animation values
  static const Duration animationDurationFast = Duration(milliseconds: 250);
  static const Duration animationDurationMedium = Duration(milliseconds: 350);
  static const Curve springCurve = Curves.easeOutCubic;

  // Role Types multi-select values
  static const List<String> roleTypes = [
    'Software Engineer',
    'Mobile App Developer',
    'Flutter Developer',
    'Cloud Engineer',
    'Performance Engineer',
    'Software Developer',
    'iOS Developer',
    'Frontend Developer',
    'Backend Developer',
    'Full Stack Developer',
    'Product Engineer',
    'Web Developer',
    'Web Designer',
    'UI/UX Developer',
    'Systems Engineer',
    'DevOps Engineer',
    'Data Analyst',
  ];
}
