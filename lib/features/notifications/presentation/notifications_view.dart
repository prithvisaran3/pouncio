import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../models/notification_item.dart';
import '../application/notifications_provider.dart';
import '../../../shared/widgets/classy_app_bar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';

/// NotificationsView renders chronological push-triggered items with read states and swipe-to-dismiss.
class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsStateProvider);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background(context),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ClassyAppBar(
              title: 'Notifications',
              actions: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text(
                    'Clear',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.scaleText(context, 15.0),
                    ),
                  ),
                  onPressed: () {
                    showCupertinoDialog<void>(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text('Clear Notifications'),
                        content: const Text('Are you sure you want to clear all notifications?'),
                        actions: [
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            onPressed: () {
                              ref.read(notificationsStateProvider.notifier).clearAll();
                              Navigator.pop(context);
                            },
                            child: const Text('Clear All'),
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: notificationsAsync.when(
                data: (list) {
                  if (list.isEmpty) {
                    return const Center(
                      child: EmptyState(
                        icon: CupertinoIcons.bell_slash,
                        title: 'All Caught Up!',
                        message: 'We will notify you the moment matching jobs are published.',
                      ),
                    );
                  }
                  return _buildNotificationList(context, ref, list);
                },
                loading: () => Padding(
                  padding: EdgeInsets.only(top: Responsive.scale(context, AppConstants.space16)),
                  child: const ShimmerLoader(),
                ),
                error: (err, _) => Center(
                  child: ErrorState(
                    message: err.toString(),
                    onRetry: () => ref.read(notificationsStateProvider.notifier).refresh(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(
    BuildContext context,
    WidgetRef ref,
    List<NotificationItem> list,
  ) {
    return CupertinoScrollbar(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          Responsive.scale(context, AppConstants.screenPadding),
          Responsive.scale(context, AppConstants.screenPadding),
          Responsive.scale(context, AppConstants.screenPadding),
          MediaQuery.paddingOf(context).bottom + Responsive.scale(context, 84.0),
        ),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          final isUnread = item.readState == ReadState.unread;
          final isMatch = item.title.contains('🎯') || item.title.toLowerCase().contains('match');

          return Padding(
            padding: EdgeInsets.only(bottom: Responsive.scale(context, AppConstants.space12)),
            child: Dismissible(
              key: Key('notif_dismiss_${item.id}'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: Responsive.scale(context, AppConstants.space24)),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemRed,
                  borderRadius: BorderRadius.circular(Responsive.scale(context, AppConstants.radiusCard)),
                ),
                child: Icon(
                  CupertinoIcons.delete_solid,
                  color: CupertinoColors.white,
                  size: Responsive.scale(context, 24.0),
                ),
              ),
              onDismissed: (_) {
                ref.read(notificationsStateProvider.notifier).dismissNotification(item.id);
              },
              child: GlassCard(
                onTap: () {
                  ref.read(notificationsStateProvider.notifier).markAsRead(item.id);
                  if (item.jobId != null && item.jobId!.isNotEmpty) {
                    context.push('/job/${item.jobId}');
                  }
                },
                child: Container(
                  decoration: isMatch
                      ? BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: AppColors.accent.withValues(alpha: 0.6),
                              width: 3.0,
                            ),
                          ),
                        )
                      : null,
                  padding: isMatch ? const EdgeInsets.only(left: 8.0) : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Read / Unread Indicator Dot / Match Target Icon
                      SizedBox(
                        width: Responsive.scale(context, 18.0),
                        height: Responsive.scale(context, 18.0),
                        child: Center(
                          child: isMatch
                              ? Icon(
                                  CupertinoIcons.sparkles,
                                  size: Responsive.scale(context, 16.0),
                                  color: isUnread ? AppColors.accent : AppColors.textSecondary(context),
                                )
                              : Container(
                                  width: Responsive.scale(context, 8.0),
                                  height: Responsive.scale(context, 8.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isUnread ? AppColors.accent : CupertinoColors.transparent,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(width: Responsive.scale(context, AppConstants.space12)),

                      // Notification details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: AppTypography.body(context).copyWith(
                                      fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                                      fontSize: Responsive.scaleText(context, 15.0),
                                      color: isUnread
                                          ? AppColors.textPrimary(context)
                                          : AppColors.textSecondary(context),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Responsive.scale(context, AppConstants.space8)),
                                Text(
                                  timeAgo(item.postedAt),
                                  style: AppTypography.micro(context).copyWith(
                                    fontSize: Responsive.scaleText(context, 10.0),
                                  ),
                                ),
                              ],
                            ),
                            if (isMatch) ...[
                              const SizedBox(height: 4.0),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.3), width: 0.5),
                                ),
                                child: Text(
                                  '🎯 PROFILE MATCH',
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(height: Responsive.scale(context, AppConstants.space4)),
                            Text(
                              item.body,
                              style: AppTypography.caption(context).copyWith(
                                fontSize: Responsive.scaleText(context, 12.0),
                                color: isUnread
                                    ? AppColors.textPrimary(context)
                                    : AppColors.textSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
