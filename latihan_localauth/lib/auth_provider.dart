import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _username;
  bool _isLoading = true;

  bool get isAuthenticated => _isAuthenticated;
  String? get username => _username;
  bool get isLoading => _isLoading;

  static const String _isAuthKey = 'is_authenticated';
  static const String _usernameKey = 'username';

  static const String _validUsername = 'admin';
  static const String _validPassword = 'password123';

  Future<void> checkSession() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool(_isAuthKey) ?? false;
    _username = prefs.getString(_usernameKey);

    _isLoading = false;
    notifyListeners();
  }

  Future<LoginResult> login(String username, String password) async {
    await Future.delayed(Duration(seconds: 1));

    if (username == _validUsername && password == _validPassword) {
      _isAuthenticated = true;
      _username = username;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isAuthKey, true);
      await prefs.setString(_usernameKey, username);

      return LoginResult.success();
    } else {
      return LoginResult.error('Username atau password salah');
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _username = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isAuthKey);
    await prefs.remove(_usernameKey);
  }
}

class LoginResult {
  final bool isSuccess;
  final String? errorMessage;

  LoginResult.success() : isSuccess = true, errorMessage = null;
  LoginResult.error(this.errorMessage) : isSuccess = false;
}
