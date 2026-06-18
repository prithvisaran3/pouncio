import 'package:flutter/cupertino.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../theme/typography.dart';

/// EmptyState displays a premium message with an icon when a list or feed is empty.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Responsive.scale(context, AppConstants.screenPadding)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: Responsive.scale(context, 64.0),
              color: CupertinoTheme.of(context).primaryColor.withValues(alpha: 0.5),
            ),
            SizedBox(height: Responsive.scale(context, AppConstants.space16)),
            Text(
              title,
              style: AppTypography.title(context).copyWith(
                fontSize: Responsive.scaleText(context, 18.0),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Responsive.scale(context, AppConstants.space8)),
            Text(
              message,
              style: AppTypography.caption(context).copyWith(
                fontSize: Responsive.scaleText(context, 14.0),
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              SizedBox(height: Responsive.scale(context, AppConstants.space24)),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
