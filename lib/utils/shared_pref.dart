import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});


class SharedPref {
  const SharedPref(this.sharedPreferences);
  final SharedPreferences sharedPreferences;


  







  static Future<bool> isKeyExists(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  static Future<String?> read(var key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> write(String key, value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.setString(key, value);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> remove(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.remove(key);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var keys = prefs.getKeys();

      for (var key in keys) {
        prefs.remove(key);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
