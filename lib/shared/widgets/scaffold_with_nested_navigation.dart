import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../../core/utils.dart';
import '../../theme/colors.dart';

/// ScaffoldWithNestedNavigation wraps GoRouter's branches inside a Stack layout
/// with a floating GlassBottomBar from the liquid_glass_widgets package.
class ScaffoldWithNestedNavigation extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNestedNavigation({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double bottomMargin = MediaQuery.paddingOf(context).bottom + Responsive.scale(context, 4.0);
    final double horizontalMargin = Responsive.scale(context, 24.0);
    final double barHeight = Responsive.scale(context, 58.0);

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Stack(
        children: [
          // Current branch view
          Positioned.fill(
            child: navigationShell,
          ),

          // Floating GlassBottomBar from liquid_glass_widgets package
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlassBottomBar(
              indicatorColor: AppColors.accent,
              selectedIconColor: CupertinoColors.white,
              unselectedIconColor: AppColors.textSecondary(context),
              settings: LiquidGlassSettings(
                thickness: 30,
                blur: 3,
                chromaticAberration: 0.3,
                lightIntensity: 0.6,
                refractiveIndex: 1.59,
                saturation: 0.7,
                ambientStrength: 1,
                glassColor: AppColors.glassColor(context).withValues(alpha: 0.85),
              ),
              tabs: const [
                GlassBottomBarTab(
                  label: 'Home',
                  icon: Icon(CupertinoIcons.house),
                  activeIcon: Icon(CupertinoIcons.house_fill),
                  glowColor: AppColors.accent,
                ),
                GlassBottomBarTab(
                  label: 'Saved',
                  icon: Icon(CupertinoIcons.bookmark),
                  activeIcon: Icon(CupertinoIcons.bookmark_fill),
                  glowColor: AppColors.accent,
                ),
                GlassBottomBarTab(
                  label: 'Notifications',
                  icon: Icon(CupertinoIcons.bell),
                  activeIcon: Icon(CupertinoIcons.bell_fill),
                  glowColor: AppColors.accent,
                ),
                GlassBottomBarTab(
                  label: 'Profile',
                  icon: Icon(CupertinoIcons.person),
                  activeIcon: Icon(CupertinoIcons.person_fill),
                  glowColor: AppColors.accent,
                ),
              ],
              selectedIndex: navigationShell.currentIndex,
              onTabSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              barHeight: barHeight,
              barBorderRadius: Responsive.scale(context, 32.0),
              horizontalPadding: horizontalMargin,
              verticalPadding: bottomMargin,
            ),
          ),
        ],
      ),
    );
  }
}
