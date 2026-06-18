import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../features/filters/application/filters_provider.dart';
import '../../theme/colors.dart';

/// GlassCard provides a premium frosted-glass styled card.
/// Utilizes BackdropFilter for live background blur, borders, and soft shadows.
class GlassCard extends ConsumerWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = AppConstants.radiusCard,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double scaledRadius = Responsive.scale(context, radius);
    final route = ModalRoute.of(context);
    final bool isCurrent = route == null || route.isCurrent;
    final bool isFiltersOpen = ref.watch(isFiltersOpenProvider);
    final bool disableBlur = isFiltersOpen || !isCurrent;

    final Widget cardBody = Container(
      decoration: BoxDecoration(
        color: AppColors.glassColor(context),
        borderRadius: BorderRadius.circular(scaledRadius),
        border: Border.all(
          color: AppColors.border(context),
          width: 1.0,
        ),
        boxShadow: AppConstants.softShadow(context),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(scaledRadius),
        child: !disableBlur
            ? BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: AppConstants.glassBlurSigma,
                  sigmaY: AppConstants.glassBlurSigma,
                ),
                child: Padding(
                  padding: padding ?? EdgeInsets.all(Responsive.scale(context, AppConstants.space16)),
                  child: child,
                ),
              )
            : Padding(
                padding: padding ?? EdgeInsets.all(Responsive.scale(context, AppConstants.space16)),
                child: child,
              ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: cardBody,
      );
    }

    return cardBody;
  }
}

/// FrostedGlassHeader provides a sticky header background with glassmorphism.
class FrostedGlassHeader extends ConsumerWidget {
  final Widget child;

  const FrostedGlassHeader({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ModalRoute.of(context);
    final bool isCurrent = route == null || route.isCurrent;
    final bool isFiltersOpen = ref.watch(isFiltersOpenProvider);
    final bool disableBlur = isFiltersOpen || !isCurrent;

    if (disableBlur) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.glassColor(context).withValues(alpha: 0.95),
          border: Border(
            bottom: BorderSide(
              color: AppColors.border(context),
              width: Responsive.scale(context, 0.5),
            ),
          ),
        ),
        child: child,
      );
    }

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppConstants.glassBlurSigma,
          sigmaY: AppConstants.glassBlurSigma,
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.glassColor(context),
            border: Border(
              bottom: BorderSide(
                color: AppColors.border(context),
                width: Responsive.scale(context, 0.5),
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
