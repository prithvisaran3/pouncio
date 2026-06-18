import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'notification_item.freezed.dart';
part 'notification_item.g.dart';

@HiveType(typeId: 9)
enum FreshnessTier {
  @HiveField(0)
  now,      // <30m
  @HiveField(1)
  recent,   // <1h
  @HiveField(2)
  today,    // <24h
  @HiveField(3)
  older,    // else
}

@HiveType(typeId: 10)
enum ReadState {
  @HiveField(0)
  unread,
  @HiveField(1)
  read,
}

@freezed
class NotificationItem with _$NotificationItem {
  @HiveType(typeId: 8)
  const factory NotificationItem({
    @HiveField(0) required String id,
    @HiveField(1) String? jobId,
    @HiveField(2) required String title,
    @HiveField(3) required String body,
    @HiveField(4) required DateTime postedAt,
    @HiveField(5) required FreshnessTier freshnessTier,
    @HiveField(6) required ReadState readState,
    @HiveField(7) required DateTime createdAt,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);

  const NotificationItem._();

  /// Static helper to compute the freshness tier from the posted timestamp.
  static FreshnessTier computeFreshnessTier(DateTime postedAt, DateTime relativeTo) {
    final difference = relativeTo.difference(postedAt);
    if (difference.inMinutes < 30) {
      return FreshnessTier.now;
    } else if (difference.inHours < 1) {
      return FreshnessTier.recent;
    } else if (difference.inHours < 24) {
      return FreshnessTier.today;
    } else {
      return FreshnessTier.older;
    }
  }
}
