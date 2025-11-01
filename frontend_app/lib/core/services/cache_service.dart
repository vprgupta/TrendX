import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _trendsPrefix = 'trends_';
  static const Duration _cacheExpiry = Duration(minutes: 15);

  static Future<void> cacheTrends(String platform, String countryCode, List<Map<String, dynamic>> trends) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_trendsPrefix${platform}_$countryCode';
    final cacheData = {
      'data': trends,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString(key, jsonEncode(cacheData));
  }

  static Future<List<Map<String, dynamic>>?> getCachedTrends(String platform, String countryCode) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_trendsPrefix${platform}_$countryCode';
    final cached = prefs.getString(key);
    
    if (cached == null) return null;
    
    final cacheData = jsonDecode(cached);
    final timestamp = DateTime.fromMillisecondsSinceEpoch(cacheData['timestamp']);
    
    if (DateTime.now().difference(timestamp) > _cacheExpiry) {
      await prefs.remove(key);
      return null;
    }
    
    return List<Map<String, dynamic>>.from(cacheData['data']);
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_trendsPrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}