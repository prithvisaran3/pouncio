import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';

/// ShimmerLoader displays skeleton placeholder cards that animate a shimmer sweep.
class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = CupertinoTheme.brightnessOf(context);
    final isDark = brightness == Brightness.dark;

    final baseColor = isDark
        ? const Color(0xFF262626)
        : const Color(0xFFE5E7EB);
    final highlightColor = isDark
        ? const Color(0xFF333333)
        : const Color(0xFFF5F5F7);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: Responsive.scale(context, AppConstants.screenPadding)),
        itemCount: 4,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: Responsive.scale(context, AppConstants.space16)),
          child: Container(
            height: Responsive.scale(context, 140.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(Responsive.scale(context, AppConstants.radiusCard)),
            ),
          ),
        ),
      ),
    );
  }
}
