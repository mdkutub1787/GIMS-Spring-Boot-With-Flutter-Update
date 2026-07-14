import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsViewModelProvider = ChangeNotifierProvider<SettingsViewModel>((ref) {
  return SettingsViewModel();
});

class SettingsViewModel extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  static const String _colorKey = 'app_primary_color';
  static const String _langKey = 'app_locale';
  static const String _biometricKey = 'app_biometric_enabled';
  
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  
  // Default to Purple as requested in previous UI refactors
  Color _primaryColor = const Color(0xFF7C3AED);
  Color get primaryColor => _primaryColor;
  
  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  
  bool _isBiometricEnabled = false;
  bool get isBiometricEnabled => _isBiometricEnabled;
  
  SettingsViewModel() {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Theme Mode
    final themeStr = prefs.getString(_themeKey);
    if (themeStr == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (themeStr == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    
    // Load Color
    final colorVal = prefs.getInt(_colorKey);
    if (colorVal != null) {
      _primaryColor = Color(colorVal);
    }
    
    // Load Locale
    final langStr = prefs.getString(_langKey);
    if (langStr != null) {
      _locale = Locale(langStr);
    }
    
    // Load Biometrics
    _isBiometricEnabled = prefs.getBool(_biometricKey) ?? false;
    
    _isInitialized = true;
    notifyListeners();
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    String val = 'system';
    if (mode == ThemeMode.dark) val = 'dark';
    if (mode == ThemeMode.light) val = 'light';
    await prefs.setString(_themeKey, val);
  }
  
  Future<void> setPrimaryColor(Color color) async {
    if (_primaryColor == color) return;
    _primaryColor = color;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorKey, color.toARGB32());
  }
  
  Future<void> setLocale(Locale locale) async {
    if (_locale.languageCode == locale.languageCode) return;
    _locale = locale;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, locale.languageCode);
  }
  
  Future<void> setBiometricEnabled(bool enabled) async {
    if (_isBiometricEnabled == enabled) return;
    _isBiometricEnabled = enabled;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricKey, enabled);
  }
}
