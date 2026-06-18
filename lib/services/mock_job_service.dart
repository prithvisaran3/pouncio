import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/job.dart';
import '../models/notification_item.dart';

part 'mock_job_service.g.dart';

/// JobService defines the data fetching interface for Pouncio.
abstract class JobService {
  Future<List<Job>> getJobs();
  Future<List<NotificationItem>> getNotifications();
}

/// Helper utility to parse relative mock date strings (e.g., "-10m", "-2h 15m", "-3d")
/// into real DateTime objects relative to DateTime.now().
DateTime parseRelativeDate(String relative) {
  final now = DateTime.now().toUtc();
  if (relative.startsWith('-')) {
    final value = relative.substring(1);
    final parts = value.split(' ');
    var duration = Duration.zero;
    for (final part in parts) {
      if (part.endsWith('m')) {
        final minutes = int.tryParse(part.substring(0, part.length - 1)) ?? 0;
        duration += Duration(minutes: minutes);
      } else if (part.endsWith('h')) {
        final hours = int.tryParse(part.substring(0, part.length - 1)) ?? 0;
        duration += Duration(hours: hours);
      } else if (part.endsWith('d')) {
        final days = int.tryParse(part.substring(0, part.length - 1)) ?? 0;
        duration += Duration(days: days);
      }
    }
    return now.subtract(duration);
  }
  return now;
}

@riverpod
class MockJobService extends _$MockJobService implements JobService {
  @override
  void build() {}

  @override
  Future<List<Job>> getJobs() async {
    // Simulate network lag
    await Future<void>.delayed(const Duration(milliseconds: 600));

    try {
      final jsonString = await rootBundle.loadString('assets/mock/jobs.json');
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      return jsonList.map((dynamic item) {
        final map = Map<String, dynamic>.from(item as Map);
        final relativeString = map['postedAt'] as String;
        // Parse the relative offset to actual UTC time
        map['postedAt'] = parseRelativeDate(relativeString).toIso8601String();
        return Job.fromJson(map);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load mock jobs: $e');
    }
  }

  @override
  Future<List<NotificationItem>> getNotifications() async {
    // Simulate network lag
    await Future<void>.delayed(const Duration(milliseconds: 400));

    try {
      final jsonString = await rootBundle.loadString('assets/mock/notifications.json');
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      return jsonList.map((dynamic item) {
        final map = Map<String, dynamic>.from(item as Map);
        
        final postedRelative = map['postedAt'] as String;
        map['postedAt'] = parseRelativeDate(postedRelative).toIso8601String();
        
        final createdRelative = map['createdAt'] as String;
        map['createdAt'] = parseRelativeDate(createdRelative).toIso8601String();

        return NotificationItem.fromJson(map);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load mock notifications: $e');
    }
  }
}
