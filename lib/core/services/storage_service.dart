import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Future<bool> saveMap(String key, Map<String, dynamic> value) async {
    return await _prefs.setString(key, json.encode(value));
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Map<String, dynamic>? getMap(String key) {
    final String? jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    return json.decode(jsonString);
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs.clear();
  }
}
