import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';
  static const String _baseUrl = 'http://10.22.31.214:3000/api/auth';

  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = User.fromJson(data['user']);
        await _saveToken(data['token']);
        await _saveUser(user);
        return user;
      }
    } catch (e) {
      print('Login error: $e');
    }
    return null;
  }

  Future<User?> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final user = User.fromJson(data['user']);
        await _saveToken(data['token']);
        await _saveUser(user);
        return user;
      }
    } catch (e) {
      print('Register error: $e');
    }
    return null;
  }

  Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    return email.isNotEmpty && email.contains('@');
  }

  Future<void> logout() async {
    try {
      final token = await _getToken();
      if (token != null) {
        await http.post(
          Uri.parse('$_baseUrl/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (e) {
      print('Logout error: $e');
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);
    }
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
    final token = await _getToken();
    return token != null;
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }
}