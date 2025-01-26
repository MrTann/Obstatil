import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart'; // Import the logging framework

class UserDetails {
  final String email;
  final String? name;
  final String? uid;

  UserDetails({
    required this.email,
    this.name,
    this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'uid': uid,
    };
  }

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      email: map['email']?.toString() ?? '',
      name: map['name']?.toString(),
      uid: map['uid']?.toString(),
    );
  }

  factory UserDetails.fromFirebaseUser(User user) {
    return UserDetails(
      email: user.email ?? '',
      name: user.displayName,
      uid: user.uid,
    );
  }

  @override
  String toString() {
    return 'UserDetails(email: $email, name: $name, uid: $uid)';
  }
}

class AuthService {
  static final AuthService instance = AuthService._init();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger(); // Initialize the logger

  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';

  AuthService._init();

  Future<bool> isSignedIn() async {
    try {
      final currentUser = _auth.currentUser;
      return currentUser != null;
    } catch (e) {
      _logger.e('Check sign in error: $e'); // Use the logger
      return false;
    }
  }

  Future<String?> getStoredEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userEmailKey);
    } catch (e) {
      _logger.e('Get stored email error: $e'); // Use the logger
      return null;
    }
  }

  Future<String?> getStoredName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userNameKey);
    } catch (e) {
      _logger.e('Get stored name error: $e'); // Use the logger
      return null;
    }
  }

  Future<UserDetails> signUpWithEmail(
      String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User registration failed');
      }

      await user.updateDisplayName(name);
      await user.reload();

      final updatedUser = _auth.currentUser;
      if (updatedUser == null) {
        throw Exception('Failed to get updated user');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userEmailKey, email);
      await prefs.setString(_userNameKey, name);

      return UserDetails.fromFirebaseUser(updatedUser);
    } catch (e) {
      _logger.e('Email registration error: $e'); // Use the logger
      rethrow;
    }
  }

  Future<UserDetails> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User sign in failed');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userEmailKey, user.email ?? '');
      await prefs.setString(_userNameKey, user.displayName ?? '');

      return UserDetails.fromFirebaseUser(user);
    } catch (e) {
      _logger.e('Email sign in error: $e'); // Use the logger
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userEmailKey);
      await prefs.remove(_userNameKey);
    } catch (e) {
      _logger.e('Sign out error: $e'); // Use the logger
      rethrow;
    }
  }

  Future<String?> getCurrentUserId() async {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<String?> getCurrentUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    _logger.d('Current Firebase User Email: ${user?.email}'); // Use the logger
    return user?.email;
  }
}
