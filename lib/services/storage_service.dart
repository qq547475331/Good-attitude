import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _gratitudeKey = 'gratitude_entries';
  static const String _moodKey = 'mood_records';
  static const String _thoughtKey = 'thought_records';
  static const String _growthKey = 'growth_goals';
  static const String _settingsKey = 'app_settings';
  
  // 获取共享偏好实例
  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();
  
  // 保存字符串列表
  Future<bool> saveStringList(String key, List<String> data) async {
    final prefs = await _prefs;
    return prefs.setStringList(key, data);
  }
  
  // 获取字符串列表
  Future<List<String>> getStringList(String key) async {
    final prefs = await _prefs;
    return prefs.getStringList(key) ?? [];
  }
  
  // 保存字符串
  Future<bool> saveString(String key, String value) async {
    final prefs = await _prefs;
    return prefs.setString(key, value);
  }
  
  // 获取字符串
  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }
  
  // 保存布尔值
  Future<bool> saveBool(String key, bool value) async {
    final prefs = await _prefs;
    return prefs.setBool(key, value);
  }
  
  // 获取布尔值
  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await _prefs;
    return prefs.getBool(key) ?? defaultValue;
  }
  
  // 保存整数
  Future<bool> saveInt(String key, int value) async {
    final prefs = await _prefs;
    return prefs.setInt(key, value);
  }
  
  // 获取整数
  Future<int> getInt(String key, {int defaultValue = 0}) async {
    final prefs = await _prefs;
    return prefs.getInt(key) ?? defaultValue;
  }
  
  // 保存JSON数据
  Future<bool> saveJson(String key, Map<String, dynamic> json) async {
    final prefs = await _prefs;
    return prefs.setString(key, jsonEncode(json));
  }
  
  // 获取JSON数据
  Future<Map<String, dynamic>?> getJson(String key) async {
    final prefs = await _prefs;
    String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }
  
  // 保存感恩记录列表
  Future<bool> saveGratitudeEntries(List<Map<String, dynamic>> entries) async {
    return saveString(_gratitudeKey, jsonEncode(entries));
  }
  
  // 获取感恩记录列表
  Future<List<Map<String, dynamic>>> getGratitudeEntries() async {
    String? jsonString = await getString(_gratitudeKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }
  
  // 保存情绪记录列表
  Future<bool> saveMoodRecords(List<Map<String, dynamic>> records) async {
    return saveString(_moodKey, jsonEncode(records));
  }
  
  // 获取情绪记录列表
  Future<List<Map<String, dynamic>>> getMoodRecords() async {
    String? jsonString = await getString(_moodKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }
  
  // 保存思想记录列表
  Future<bool> saveThoughtRecords(List<Map<String, dynamic>> records) async {
    return saveString(_thoughtKey, jsonEncode(records));
  }
  
  // 获取思想记录列表
  Future<List<Map<String, dynamic>>> getThoughtRecords() async {
    String? jsonString = await getString(_thoughtKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }
  
  // 保存成长目标列表
  Future<bool> saveGrowthGoals(List<Map<String, dynamic>> goals) async {
    return saveString(_growthKey, jsonEncode(goals));
  }
  
  // 获取成长目标列表
  Future<List<Map<String, dynamic>>> getGrowthGoals() async {
    String? jsonString = await getString(_growthKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }
  
  // 保存应用设置
  Future<bool> saveSettings(Map<String, dynamic> settings) async {
    return saveJson(_settingsKey, settings);
  }
  
  // 获取应用设置
  Future<Map<String, dynamic>> getSettings() async {
    Map<String, dynamic>? settings = await getJson(_settingsKey);
    return settings ?? {};
  }
  
  // 清除所有数据
  Future<bool> clearAll() async {
    final prefs = await _prefs;
    return prefs.clear();
  }
} 