import 'package:flutter/cupertino.dart';

/// AppColors defines the color palette used throughout Pouncio.
///
/// Refers to the Global Design System:
/// accent #FF4D2E (pounce orange-red) · accentSoft #FFE9E4
/// Freshness: now #FF4D2E (<30m) · recent #F59E0B (<1h) · today #10B981
class AppColors {
  AppColors._();

  // Primary brand color
  static const Color accent = Color(0xFFFF4D2E);
  static const Color accentSoftLight = Color(0xFFFFE9E4);
  static const Color accentSoftDark = Color(0xFF2C1E1B);

  // Freshness indicators
  static const Color freshNow = Color(0xFFFF4D2E);      // < 30m
  static const Color freshRecent = Color(0xFFF59E0B);  // < 1h
  static const Color freshToday = Color(0xFF10B981);   // < 24h
  static const Color freshOlder = Color(0xFF6B7280);   // else

  // Light Mode Colors
  static const Color bgLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF7F8FA);
  static const Color textPrimaryLight = Color(0xFF0A0A0B);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color glassColorLight = Color(0x99FFFFFF); // 60% opacity white

  // Dark Mode Colors
  static const Color bgDark = Color(0xFF0A0A0B);
  static const Color surfaceDark = Color(0xFF161618);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color borderDark = Color(0xFF262626);
  static const Color glassColorDark = Color(0x99000000); // 60% opacity black

  /// Returns background color depending on brightness.
  static Color background(BuildContext context) {
    return CupertinoTheme.brightnessOf(context) == Brightness.dark
        ? bgDark
        : bgLight;
  }

  /// Returns surface color depending on brightness.
  static Color surface(BuildContext context) {
    return CupertinoTheme.brightnessOf(context) == Brightness.dark
        ? surfaceDark
        : surfaceLight;
  }

  /// Returns primary text color depending on brightness.
  static Color textPrimary(BuildContext context) {
    return CupertinoTheme.brightnessOf(context) == Brightness.dark
        ? textPrimaryDark
        : textPrimaryLight;
  }

  /// Returns secondary text color depending on brightness.
  static Color textSecondary(BuildContext context) {
    return CupertinoTheme.brightnessOf(context) == Brightness.dark
        ? textSecondaryDark
        : textSecondaryLight;
  }

  /// Returns border color depending on brightness.
  static Color border(BuildContext context) {
    return CupertinoTheme.brightnessOf(context) == Brightness.dark
        ? borderDark
        : borderLight;
  }

  /// Returns soft accent color depending on brightness.
  static Color accentSoft(BuildContext context) {
    return CupertinoTheme.brightnessOf(context) == Brightness.dark
        ? accentSoftDark
        : accentSoftLight;
  }

  /// Returns glass color depending on brightness.
  static Color glassColor(BuildContext context) {
    return CupertinoTheme.brightnessOf(context) == Brightness.dark
        ? glassColorDark
        : glassColorLight;
  }
}
