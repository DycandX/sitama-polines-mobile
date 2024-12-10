import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  bool get isAuthenticated => _token != null;

  void setToken(String token) {
    _token = token;
    notifyListeners(); // Notify listeners of token changes
  }

  void clearToken() {
    _token = null;
    notifyListeners(); // Notify listeners of token changes
  }
}

class Config {
  static const String baseUrl = 'http://192.168.1.8/sitama-new/public/api/v1/';
}
