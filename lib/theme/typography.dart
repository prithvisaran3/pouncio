import 'package:flutter/cupertino.dart';
import 'colors.dart';

/// AppTypography defines the type scale used in Pouncio.
///
/// Refers to: SF Pro / system:
/// - display 34/bold
/// - title 22/semibold
/// - body 16/regular
/// - caption 13/medium
/// - micro 11/medium
/// Letter-spacing tight (-0.2 to -0.4) on titles.
class AppTypography {
  AppTypography._();

  static const String fontFamily = '.SF Pro Text';

  static TextStyle display(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary(context),
        letterSpacing: -0.4,
      );

  static TextStyle title(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary(context),
        letterSpacing: -0.3,
      );

  static TextStyle body(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary(context),
      );

  static TextStyle bodySecondary(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary(context),
      );

  static TextStyle caption(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary(context),
      );

  static TextStyle micro(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary(context),
      );
}
