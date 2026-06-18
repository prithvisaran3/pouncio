import 'package:flutter/cupertino.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../models/notification_item.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

/// FreshnessBadge displays a colored pill badge based on when a job was posted.
class FreshnessBadge extends StatelessWidget {
  final DateTime postedAt;

  const FreshnessBadge({
    super.key,
    required this.postedAt,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toUtc();
    final tier = NotificationItem.computeFreshnessTier(postedAt, now);

    Color badgeColor;
    String label;

    switch (tier) {
      case FreshnessTier.now:
        badgeColor = AppColors.freshNow;
        label = 'Posted Now';
        break;
      case FreshnessTier.recent:
        badgeColor = AppColors.freshRecent;
        label = 'Recent';
        break;
      case FreshnessTier.today:
        badgeColor = AppColors.freshToday;
        label = 'Today';
        break;
      case FreshnessTier.older:
        badgeColor = AppColors.freshOlder;
        label = 'Earlier';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.scale(context, AppConstants.space8),
        vertical: Responsive.scale(context, AppConstants.space4),
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Responsive.scale(context, AppConstants.radiusChip)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Responsive.scale(context, 6.0),
            height: Responsive.scale(context, 6.0),
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: Responsive.scale(context, AppConstants.space4)),
          Text(
            label,
            style: AppTypography.micro(context).copyWith(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: Responsive.scaleText(context, 10.0),
            ),
          ),
        ],
      ),
    );
  }
}
