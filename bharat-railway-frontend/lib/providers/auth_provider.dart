/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Assisted by:
 * Date: 2026-07-06
 * Version: 1.0.0
 *
 * Description:
 * AuthProvider for state management of authentication.
 * Handles login, registration, forgot password, reset password.
 * Stores JWT token using shared_preferences.
 * Provides loading state and error handling for UI.
 */

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/requests/login_request.dart';
import '../models/requests/registration_request.dart';
import '../models/requests/forgot_password_request.dart';
import '../models/requests/reset_password_request.dart';
import '../models/responses/login_response.dart';
import '../services/api/auth_service.dart';
import '../utils/constants/api_constants.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _error;
  String? _token;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(ApiConstants.tokenStorageKey);
    _isAuthenticated = _token != null;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final request = LoginRequest(username: username, password: password);
      final response = await _authService.login(request);
      
      await _saveToken(response.accessToken);
      _isAuthenticated = true;
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(RegistrationRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.register(request);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> forgotPassword(String email, String channel) async {
    _setLoading(true);
    _clearError();

    try {
      final request = ForgotPasswordRequest(email: email, channel: channel);
      await _authService.forgotPassword(request);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    _setLoading(true);
    _clearError();

    try {
      final request = ResetPasswordRequest(token: token, newPassword: newPassword);
      await _authService.resetPassword(request);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConstants.tokenStorageKey);
    _token = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConstants.tokenStorageKey, token);
    _token = token;
    // 🔑 Print token to console so you can decode it on jwt.io
    print('🔑 JWT Token: $token');
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}