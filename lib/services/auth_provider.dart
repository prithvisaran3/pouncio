import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) => FirebaseAuth.instance;

@riverpod
FirebaseFirestore firestore(FirestoreRef ref) => FirebaseFirestore.instance;

@riverpod
Stream<User?> authState(AuthStateRef ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
}

@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService(
    auth: ref.watch(firebaseAuthProvider),
    db: ref.watch(firestoreProvider),
  );
}

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  AuthService({
    required FirebaseAuth auth,
    required FirebaseFirestore db,
  })  : _auth = auth,
        _db = db;

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user != null) {
      try {
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'fullName': name,
          'phoneNumber': phoneNumber,
          'isOnboardingComplete': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        // Clean up the created auth user if writing profile to database fails
        try {
          await user.delete();
        } catch (deleteError) {
          debugPrint('[Auth Service ERROR] Failed to delete orphaned user after Firestore failure: $deleteError');
        }
        rethrow;
      }
    }
    return credential;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final authProvider = GoogleAuthProvider();
        return await _auth.signInWithPopup(authProvider);
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();

        final GoogleSignInAuthentication googleAuth = googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );
        
        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;
        if (user != null) {
          final doc = await _db.collection('users').doc(user.uid).get();
          if (!doc.exists) {
            await _db.collection('users').doc(user.uid).set({
              'uid': user.uid,
              'email': user.email ?? '',
              'fullName': user.displayName ?? '',
              'phoneNumber': user.phoneNumber ?? '',
              'isOnboardingComplete': false,
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
        }
        return userCredential;
      }
    } catch (e) {
      debugPrint('Error during Google Sign-In: $e');
      return null;
    }
  }

  Future<void> saveOnboardingData({
    required String university,
    required String major,
    required String graduationDate,
    required bool visaNeeded,
    required List<String> skills,
    required String remotePreference,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found.');

    final docRef = _db.collection('users').doc(user.uid);
    final doc = await docRef.get();

    final Map<String, dynamic> data = {
      'university': university,
      'major': major,
      'graduationDate': graduationDate,
      'visaNeeded': visaNeeded,
      'skills': skills,
      'remotePreference': remotePreference,
      'isOnboardingComplete': true,
      'onboardedAt': FieldValue.serverTimestamp(),
    };

    if (!doc.exists) {
      data['uid'] = user.uid;
      data['email'] = user.email ?? '';
      data['fullName'] = user.displayName ?? '';
      data['phoneNumber'] = user.phoneNumber ?? '';
      data['createdAt'] = FieldValue.serverTimestamp();
      await docRef.set(data);
    } else {
      await docRef.update(data);
    }
  }

  Future<void> signOut() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _db.collection('users').doc(user.uid).update({
          'fcmToken': FieldValue.delete(),
        });
        debugPrint('[Auth] Deleted FCM token on logout for user: ${user.uid}');
      } catch (e) {
        debugPrint('[Auth WARNING] Failed to delete FCM token on logout: $e');
      }
    }
    if (!kIsWeb) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}
    }
    await _auth.signOut();
  }
}
