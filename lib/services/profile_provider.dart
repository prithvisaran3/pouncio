import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_provider.dart';

part 'profile_provider.g.dart';

@riverpod
Stream<Map<String, dynamic>?> userProfile(UserProfileRef ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);
  
  return ref.watch(firestoreProvider)
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((DocumentSnapshot<Map<String, dynamic>> doc) => doc.data());
}

