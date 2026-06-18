import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/job.dart';
import '../models/notification_item.dart';
import 'mock_job_service.dart' show JobService;

part 'firebase_job_service.g.dart';

/// FirebaseJobService interacts with Cloud Firestore to fetch jobs and notifications.
class FirebaseJobService implements JobService {
  final FirebaseFirestore _firestore;

  FirebaseJobService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    // Ensure offline persistence is enabled
    debugPrint('[FirebaseJobService] Initializing service with offline cache persistence enabled...');
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  /// Converts Firestore Timestamp instances into ISO 8601 strings
  /// so they can be parsed by json_serializable model parsers.
  Map<String, dynamic> _convertFirestoreMap(Map<String, dynamic> map) {
    final result = Map<String, dynamic>.from(map);
    result.forEach((key, value) {
      if (value is Timestamp) {
        result[key] = value.toDate().toUtc().toIso8601String();
      }
    });
    return result;
  }

  @override
  Future<List<Job>> getJobs() async {
    debugPrint('[FirebaseJobService] getJobs: Fetching jobs from Firestore...');
    try {
      final snapshot = await _firestore.collection('jobs').get();
      debugPrint('[FirebaseJobService] getJobs: Fetched snapshot containing ${snapshot.docs.length} documents.');
      final jobs = snapshot.docs.map((doc) {
        final data = _convertFirestoreMap(doc.data());
        return Job.fromJson(data);
      }).toList();
      debugPrint('[FirebaseJobService] getJobs: Successfully parsed ${jobs.length} Job items.');
      return jobs;
    } catch (e, stackTrace) {
      debugPrint('[FirebaseJobService ERROR] getJobs failed: $e\n$stackTrace');
      throw Exception('Failed to load jobs from Firestore: $e');
    }
  }

  @override
  Future<List<NotificationItem>> getNotifications() async {
    debugPrint('[FirebaseJobService] getNotifications: Fetching notifications from Firestore...');
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .get();
      debugPrint('[FirebaseJobService] getNotifications: Fetched snapshot containing ${snapshot.docs.length} documents.');
      
      final currentUid = FirebaseAuth.instance.currentUser?.uid;
      final notifications = snapshot.docs.where((doc) {
        final data = doc.data();
        final recipientUid = data['recipientUid'] as String?;
        return recipientUid == null || recipientUid == currentUid;
      }).map((doc) {
        final data = _convertFirestoreMap(doc.data());
        return NotificationItem.fromJson(data);
      }).toList();
      
      debugPrint('[FirebaseJobService] getNotifications: Successfully parsed ${notifications.length} NotificationItem items.');
      return notifications;
    } catch (e, stackTrace) {
      debugPrint('[FirebaseJobService ERROR] getNotifications failed: $e\n$stackTrace');
      throw Exception('Failed to load notifications from Firestore: $e');
    }
  }
}

@riverpod
FirebaseJobService firebaseJobService(FirebaseJobServiceRef ref) {
  return FirebaseJobService();
}
