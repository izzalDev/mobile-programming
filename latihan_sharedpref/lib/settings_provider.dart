import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isNotificationEnabled = true;
  bool _isLoading = true;

  bool get isDarkMode => _isDarkMode;
  bool get isNotificationEnabled => _isNotificationEnabled;
  bool get isLoading => _isLoading;

  static const String _darkModeKey = "dark_mode";
  static const String _notificationKey = "notification_enabled";

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    _isNotificationEnabled = prefs.getBool(_notificationKey) ?? false;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, _isDarkMode);
  }

  Future<void> toggleNotifications() async {
    _isNotificationEnabled = !_isNotificationEnabled;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationKey, _isNotificationEnabled);
  }
}
