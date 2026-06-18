import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/notification_item.dart';
import '../../../services/firebase_job_service.dart';

part 'notifications_provider.g.dart';

@riverpod
class NotificationsState extends _$NotificationsState {
  late Box<String> _readBox;
  late Box<String> _dismissedBox;

  @override
  Future<List<NotificationItem>> build() async {
    debugPrint('[NotificationsProvider] build: Building NotificationsState notifier...');
    _readBox = Hive.box<String>('read_notifications');
    // Ensure the dismissed box is opened safely
    await Hive.openBox<String>('dismissed_notifications');
    _dismissedBox = Hive.box<String>('dismissed_notifications');

    final firebaseService = ref.read(firebaseJobServiceProvider);
    final fetched = await firebaseService.getNotifications();

    final results = <NotificationItem>[];
    for (final item in fetched) {
      if (_dismissedBox.containsKey(item.id)) {
        continue;
      }
      final isRead = _readBox.containsKey(item.id) || item.readState == ReadState.read;
      results.add(item.copyWith(readState: isRead ? ReadState.read : ReadState.unread));
    }

    results.sort((a, b) => b.postedAt.compareTo(a.postedAt));
    debugPrint('[NotificationsProvider] build: Loaded ${results.length} active notifications.');
    return results;
  }

  Future<void> refresh() async {
    debugPrint('[NotificationsProvider] refresh: Starting refresh of notifications...');
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final firebaseService = ref.read(firebaseJobServiceProvider);
      final fetched = await firebaseService.getNotifications();

      final results = <NotificationItem>[];
      for (final item in fetched) {
        if (_dismissedBox.containsKey(item.id)) {
          continue;
        }
        final isRead = _readBox.containsKey(item.id) || item.readState == ReadState.read;
        results.add(item.copyWith(readState: isRead ? ReadState.read : ReadState.unread));
      }

      results.sort((a, b) => b.postedAt.compareTo(a.postedAt));
      debugPrint('[NotificationsProvider] refresh: Completed refresh. Fetched ${results.length} active notifications.');
      return results;
    });
  }

  Future<void> markAsRead(String notificationId) async {
    debugPrint('[NotificationsProvider] markAsRead: Marking notification $notificationId as read.');
    await _readBox.put(notificationId, 'read');
    state.whenData((list) {
      state = AsyncValue.data(
        list.map((item) {
          if (item.id == notificationId) {
            return item.copyWith(readState: ReadState.read);
          }
          return item;
        }).toList(),
      );
    });
  }

  Future<void> dismissNotification(String notificationId) async {
    debugPrint('[NotificationsProvider] dismissNotification: Dismissing/removing notification $notificationId.');
    await _dismissedBox.put(notificationId, 'dismissed');
    state.whenData((list) {
      state = AsyncValue.data(
        list.where((item) => item.id != notificationId).toList(),
      );
    });
  }

  Future<void> clearAll() async {
    debugPrint('[NotificationsProvider] clearAll: Clearing all notifications from local database and server...');
    final currentList = state.value ?? [];
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final dio = Dio();
        await dio.get<dynamic>('https://us-central1-exspends-split.cloudfunctions.net/pouncioClearNotifications');
        debugPrint('[NotificationsProvider] clearAll: Server notification clearance request completed.');
      } catch (e) {
        debugPrint('[NotificationsProvider WARNING] clearAll failed on server: $e');
      }
      
      // Mark all current notifications as dismissed in local Hive box to clear UI immediately
      for (final item in currentList) {
        await _dismissedBox.put(item.id, 'dismissed');
      }
      
      return <NotificationItem>[];
    });
  }
}
