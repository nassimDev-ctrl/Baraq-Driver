 
 
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {

  
  static Future<void> saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future<bool> containsData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
