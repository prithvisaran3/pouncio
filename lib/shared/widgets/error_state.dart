import 'package:flutter/cupertino.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../theme/typography.dart';

/// ErrorState displays error details with a retry action block.
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
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
              CupertinoIcons.exclamationmark_triangle,
              size: Responsive.scale(context, 48.0),
              color: CupertinoColors.systemRed,
            ),
            SizedBox(height: Responsive.scale(context, AppConstants.space16)),
            Text(
              'Something went wrong',
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
            SizedBox(height: Responsive.scale(context, AppConstants.space24)),
            CupertinoButton.filled(
              onPressed: onRetry,
              borderRadius: BorderRadius.circular(Responsive.scale(context, AppConstants.radiusChip)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
