import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class UserService extends ChangeNotifier {
  UserProfile? _currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProfile? get currentUser => _currentUser;

  Future<void> loadUserProfile() async {
    try {
      // Try to load from local storage first
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      
      if (userId != null) {
        // Load from Firebase
        final doc = await _firestore.collection('users').doc(userId).get();
        if (doc.exists) {
          _currentUser = UserProfile.fromMap(doc.data()!);
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> saveUserProfile(UserProfile user) async {
    try {
      // Save to Firebase
      await _firestore.collection('users').doc(user.id).set(user.toMap());
      
      // Save user ID to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.id);
      
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      print('Error saving user profile: $e');
      throw e;
    }
  }

  Future<void> updateUserProfile({
    String? firstName,
    String? lastName,
    String? location,
    String? homeLocalNumber,
    String? workId,
  }) async {
    if (_currentUser == null) return;

    final updatedUser = _currentUser!.copyWith(
      firstName: firstName,
      lastName: lastName,
      location: location,
      homeLocalNumber: homeLocalNumber,
      workId: workId,
      updatedAt: DateTime.now(),
    );

    await saveUserProfile(updatedUser);
  }

  Future<void> createNewUser({
    required String firstName,
    required String lastName,
    required String location,
    required String homeLocalNumber,
    required String workId,
  }) async {
    final now = DateTime.now();
    final user = UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: firstName,
      lastName: lastName,
      location: location,
      homeLocalNumber: homeLocalNumber,
      workId: workId,
      createdAt: now,
      updatedAt: now,
    );

    await saveUserProfile(user);
  }
}