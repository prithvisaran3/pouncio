import 'package:flutter/cupertino.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

/// AppFilterChip provides a Cupertino styled filter chip.
/// Supports selection status, tap animations, and customized selected/unselected theme styling.
class AppFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final Color selectedBg = AppColors.accentSoft(context);
    const Color selectedText = AppColors.accent;

    final Color unselectedBg = AppColors.surface(context);
    final Color unselectedText = AppColors.textPrimary(context);
    final Color unselectedBorder = AppColors.border(context);

    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: AnimatedContainer(
        duration: AppConstants.animationDurationFast,
        curve: AppConstants.springCurve,
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.scale(context, AppConstants.space12),
          vertical: Responsive.scale(context, AppConstants.space8),
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : unselectedBg,
          borderRadius: BorderRadius.circular(Responsive.scale(context, AppConstants.radiusChip)),
          border: Border.all(
            color: isSelected ? selectedText.withValues(alpha: 0.3) : unselectedBorder,
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.caption(context).copyWith(
            color: isSelected ? selectedText : unselectedText,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: Responsive.scaleText(context, 12.0),
          ),
        ),
      ),
    );
  }
}
