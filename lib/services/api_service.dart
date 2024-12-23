import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userName;

  String? get token => _token;
  String? get userName => _userName;

  bool get isAuthenticated => _token != null;

  void setToken(String token) {
    _token = token;
    notifyListeners(); // Notify listeners of token changes
  }

  void setUser(String userName) {
    _userName = userName;
    notifyListeners();
  }

  void clearToken() {
    _token = null;
    notifyListeners(); // Notify listeners of token changes
  }
}

class Config {
  static const String baseUrl = 'http://192.168.1.21/sitama-new/public/api/v1/';
}
