import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save user profile information (name, phone number, etc.)
  Future<void> saveUserProfile({
    required String name,
    required String phoneNumber,
    required Map<String, dynamic> preferences,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _db.collection('users').doc(userId).set({
        'name': name,
        'phoneNumber': phoneNumber,
        'preferences': preferences,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  /// Save notification preferences to Firestore
  Future<void> saveNotificationPreferences({
    required String preference,
    required bool allowSMS,
    required bool allowLocationTracking,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _db.collection('users').doc(userId).update({
        'preferences.notificationPreference': preference,
        'preferences.allowSMS': allowSMS,
        'preferences.allowLocationTracking': allowLocationTracking,
        'preferences.updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Save location privacy preference
  Future<void> saveLocationPrivacy(bool allowTracking) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _db.collection('users').doc(userId).update({
        'preferences.allowLocationTracking': allowTracking,
        'preferences.locationUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final doc = await _db.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      rethrow;
    }
  }

  /// Request SMS verification
  Future<void> requestSMSVerification(String phoneNumber) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Call Cloud Function to send SMS
      await _db.collection('users').doc(userId).update({
        'smsVerification.phoneNumber': phoneNumber,
        'smsVerification.requestedAt': FieldValue.serverTimestamp(),
        'smsVerification.verified': false,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Verify SMS code
  Future<bool> verifySMSCode(String code) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final doc = await _db.collection('users').doc(userId).get();
      final storedCode = doc.get('smsVerification.code');

      if (storedCode == code) {
        await _db.collection('users').doc(userId).update({
          'smsVerification.verified': true,
          'smsVerification.verifiedAt': FieldValue.serverTimestamp(),
        });
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete user account and all associated data
  Future<void> deleteUserAccount() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Delete user data from Firestore
      await _db.collection('users').doc(userId).delete();

      // Delete Firebase Auth user
      await _auth.currentUser?.delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Update user location (if allowed)
  Future<void> updateUserLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _db.collection('users').doc(userId).update({
        'location': GeoPoint(latitude, longitude),
        'locationUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }
}
