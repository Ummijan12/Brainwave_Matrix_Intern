// import 'package:flutter/material.dart';
//
// class ThemeProvider with ChangeNotifier {
//   ThemeMode _themeMode = ThemeMode.system;
//   bool _useSystemTheme = true;
//
//   ThemeMode get themeMode => _themeMode;
//   bool get useSystemTheme => _useSystemTheme;
//
//   void toggleTheme(bool isDarkMode) {
//     if (_useSystemTheme) {
//       _themeMode = ThemeMode.system;
//     } else {
//       _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
//     }
//     notifyListeners();
//   }
//
//   void setUseSystemTheme(bool value) {
//     _useSystemTheme = value;
//     if (value) {
//       _themeMode = ThemeMode.system;
//     }
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_internship/widgets/toast_utils.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _useSystemTheme = true;
  bool _enableNotifications = true;
  double _fontSize = 16.0;

  ThemeProvider() {
    _loadPreferences();
  }

  ThemeMode get themeMode => _themeMode;
  bool get useSystemTheme => _useSystemTheme;
  bool get enableNotifications => _enableNotifications;
  double get fontSize => _fontSize;

  Future<void> toggleTheme(bool isDarkMode) async {
    if (!_useSystemTheme) {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      await _savePreferences();
    }else{
      AppToast.info(
        message: "System theme is enabled. Disable it to toggle the theme.",
      );
    }
    notifyListeners();
  }

  Future<void> setUseSystemTheme(bool value) async {
    _useSystemTheme = value;
    _themeMode = value ? ThemeMode.system : _themeMode;
    await _savePreferences();
    _loadPreferences();
    notifyListeners();
  }

  Future<void> setEnableNotifications(bool value) async {
    _enableNotifications = value;
    await _savePreferences();
    notifyListeners();
  }

  Future<void> setFontSize(double value) async {
    _fontSize = value;
    await _savePreferences();
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _useSystemTheme = prefs.getBool('useSystemTheme') ?? true;
    _themeMode = _useSystemTheme
        ? ThemeMode.system
        : (prefs.getBool('isDarkMode') ?? false ? ThemeMode.dark : ThemeMode.light);
    _enableNotifications = prefs.getBool('enableNotifications') ?? true;
    _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useSystemTheme', _useSystemTheme);
    if (!_useSystemTheme) {
      await prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
    }
    await prefs.setBool('enableNotifications', _enableNotifications);
    await prefs.setDouble('fontSize', _fontSize);
  }
}
