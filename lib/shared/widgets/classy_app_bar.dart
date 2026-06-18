import 'dart:ui';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils.dart';
import '../../features/filters/application/filters_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

/// ClassyAppBar provides a custom, premium frosted-glass navigation header.
/// Designed to be used directly at the top of a body [Column].
class ClassyAppBar extends ConsumerWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;

  const ClassyAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPop = GoRouter.of(context).canPop();
    
    // Responsive heights and paddings
    final double appBarHeight = Responsive.scale(context, 52.0);
    final double horizontalPadding = Responsive.scale(context, 16.0);
    
    Widget? leadingWidget = leading;
    if (leadingWidget == null && showBackButton && canPop) {
      leadingWidget = CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: const Size.square(32.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CNIcon(
              symbol: CNSymbol('chevron.left', size: Responsive.scale(context, 18.0)),
              color: AppColors.accent,
            ),
            const SizedBox(width: 2),
            Text(
              'Back',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: Responsive.scaleText(context, 15.0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        onPressed: () => context.pop(),
      );
    }

    final route = ModalRoute.of(context);
    final bool isCurrent = route == null || route.isCurrent;
    final bool isFiltersOpen = ref.watch(isFiltersOpenProvider);
    final bool disableBlur = isFiltersOpen || !isCurrent;

    if (disableBlur) {
      return Container(
        height: appBarHeight,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: AppColors.glassColor(context).withValues(alpha: 0.95),
          border: Border(
            bottom: BorderSide(
              color: AppColors.border(context),
              width: 0.5,
            ),
          ),
        ),
        child: NavigationToolbar(
          leading: leadingWidget,
          middle: Text(
            title,
            style: AppTypography.title(context).copyWith(
              fontSize: Responsive.scaleText(context, 18.0),
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: actions != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                )
              : null,
          centerMiddle: true,
        ),
      );
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: appBarHeight,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          decoration: BoxDecoration(
            color: AppColors.glassColor(context),
            border: Border(
              bottom: BorderSide(
                color: AppColors.border(context),
                width: 0.5,
              ),
            ),
          ),
          child: NavigationToolbar(
            leading: leadingWidget,
            middle: Text(
              title,
              style: AppTypography.title(context).copyWith(
                fontSize: Responsive.scaleText(context, 18.0),
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: actions != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!,
                  )
                : null,
            centerMiddle: true,
          ),
        ),
      ),
    );
  }
}
