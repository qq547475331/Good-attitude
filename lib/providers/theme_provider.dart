import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme';
  
  bool _isDarkMode = false;
  
  ThemeProvider() {
    _loadThemePreference();
  }
  
  // 获取当前是否为深色模式
  bool get isDarkMode => _isDarkMode;
  
  // 获取当前主题数据
  ThemeData get themeData => _isDarkMode ? AppTheme.darkTheme() : AppTheme.lightTheme();
  
  // 切换主题
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _saveThemePreference();
    notifyListeners();
  }
  
  // 设置特定主题
  Future<void> setTheme(bool darkMode) async {
    if (_isDarkMode != darkMode) {
      _isDarkMode = darkMode;
      await _saveThemePreference();
      notifyListeners();
    }
  }
  
  // 加载保存的主题偏好
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }
  
  // 保存主题偏好
  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
  }
} 