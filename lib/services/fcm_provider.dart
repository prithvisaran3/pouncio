import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_provider.dart';

part 'fcm_provider.g.dart';

@riverpod
Future<void> fcmTokenInitializer(FcmTokenInitializerRef ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.value;
  if (user != null) {
    try {
      debugPrint('[FCM Token Init] Starting sync for user ${user.uid}...');
      final messaging = FirebaseMessaging.instance;
      
      final token = await messaging.getToken();
      if (token != null) {
        await ref.read(firestoreProvider).collection('users').doc(user.uid).set({
          'fcmToken': token,
        }, SetOptions(merge: true));
        debugPrint('[FCM Token Init] Successfully synchronized FCM token.');
      } else {
        debugPrint('[FCM Token Init WARNING] FCM token is null.');
      }

      messaging.onTokenRefresh.listen((newToken) async {
        try {
          await ref.read(firestoreProvider).collection('users').doc(user.uid).set({
            'fcmToken': newToken,
          }, SetOptions(merge: true));
          debugPrint('[FCM Token Refreshed] Successfully synchronized refreshed FCM token.');
        } catch (e) {
          debugPrint('[FCM Token Refresh ERROR] Failed to sync refreshed token: $e');
        }
      });
    } catch (e) {
      debugPrint('[FCM Token Init ERROR] Failed to sync token: $e');
    }
  } else {
    debugPrint('[FCM Token Init] No authenticated user. Skipping token sync.');
  }
}
