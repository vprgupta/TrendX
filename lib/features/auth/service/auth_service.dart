import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    
    // Mock validation
    if (email.isNotEmpty && password.length >= 6) {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: email.split('@')[0],
        createdAt: DateTime.now(),
        isEmailVerified: true,
      );
      
      await _saveUser(user);
      return user;
    }
    return null;
  }

  Future<User?> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    
    if (name.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        createdAt: DateTime.now(),
        isEmailVerified: false,
      );
      
      await _saveUser(user);
      return user;
    }
    return null;
  }

  Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    return email.isNotEmpty && email.contains('@');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);
  }
}