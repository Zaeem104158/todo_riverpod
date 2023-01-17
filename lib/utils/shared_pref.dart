import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_riverpod/utils/const.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final sharedUtilityProvider = Provider<SharedPref>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return SharedPref(sharedPreferences: sharedPrefs);
});

class SharedPref {
  SharedPref({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  bool iskeyExists(
    String key,
  ) {
    try {
      return sharedPreferences.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  Future<String?> read(var key) async {
    try {
      return sharedPreferences.getString(key);
    } catch (e) {
      return null;
    }
  }

  Future<bool> write(String key, value) async {
    try {
      return sharedPreferences.setString(key, value);
    } catch (e) {
      return false;
    }
  }

  Future<bool> remove(String key) async {
    try {
      return sharedPreferences.remove(key);
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeAll() async {
    try {
      var keys = sharedPreferences.getKeys();
      for (var key in keys) {
        sharedPreferences.remove(key);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
  
   bool isDarkModeEnabled() {
    return sharedPreferences.getBool(sharedDarkModeKey) ?? false;
  }

  void setDarkModeEnabled({required bool isdark}) {
    sharedPreferences.setBool(sharedDarkModeKey, isdark);
  }
}
