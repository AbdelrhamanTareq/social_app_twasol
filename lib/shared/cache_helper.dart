import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _sharedPref;
  static init() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  // static Future<void> setValue(
  //     {required String key, required String value}) async {
  //   await _sharedPref.setString(key, value);
  // }

  static String? getValue({required String key}) {
    final data = _sharedPref.getString(key);
    return data;
  }

  static bool? getBool({required String key}) {
    final data = _sharedPref.getBool(key);
    return data;
  }

  static setValue({required String key, required var value}) async {
    if (value is String) {
      return await _sharedPref.setString(key, value);
    } else {
      return await _sharedPref.setBool(key, value);
    }
  }
}
