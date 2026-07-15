import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const String tokenKey = 'token';
  static const String statusKey = 'status';
  static const String authUserKey = 'authUser';

  static Future<void> reload() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
  }

  static Future<void> saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<bool> containsData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  static Future<bool> hasSessionToken() async {
    await reload();
    final token = await getData(tokenKey);
    return token != null && token.trim().isNotEmpty;
  }

  static Future<void> clearSession() async {
    await removeData(tokenKey);
    await removeData(statusKey);
    await removeData(authUserKey);
  }
}
