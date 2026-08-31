/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Assisted by:
 * Date: 2026-07-24
 * Version: 1.0.0
 *
 * Description:
 * Authentication service for API calls.
 * Handles login, registration, forgot password, and reset password.
 * Uses DioClient with robust error handling for all responses.
 */

import 'package:dio/dio.dart';

import '../../models/requests/login_request.dart';
import '../../models/requests/registration_request.dart';
import '../../models/requests/forgot_password_request.dart';
import '../../models/requests/reset_password_request.dart';
import '../../models/responses/login_response.dart';
import '../../models/responses/error_response.dart';
import 'dio_client.dart';

class AuthService {
  final Dio _dio = DioClient.instance;

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/login',
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> register(RegistrationRequest request) async {
    try {
      await _dio.post(
        '/api/v1/auth/register',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    try {
      print('🔍 Forgot Password Request: ${request.toJson()}');
      final response = await _dio.post(
        '/api/v1/auth/forgot-password',
        data: request.toJson(),
      );
      print('✅ Forgot Password Response: ${response.data}');
    } on DioException catch (e) {
      print('❌ Forgot Password Error: ${e.toString()}');
      print('📦 Response Data: ${e.response?.data}');
      print('📊 Status Code: ${e.response?.statusCode}');
      // Throw the error message from our handler
      throw _handleError(e);
    }
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    try {
      await _dio.post(
        '/api/v1/auth/reset-password',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    // Full debug – prints in terminal
    print('❌ DioException: ${error.toString()}');
    print('📦 Response Data: ${error.response?.data}');
    print('📊 Status Code: ${error.response?.statusCode}');
    print('🔍 Error Type: ${error.type}');

    // 1) No response – network / connection error
    if (error.response == null) {
      return 'Network error. Please check your internet connection or Tailscale.';
    }

    // 2) We have a response – try to extract message
    try {
      final data = error.response!.data;

      // Case A: Backend returns plain string (e.g., "Email not found")
      if (data is String) {
        return data.isNotEmpty ? data : 'Server error occurred.';
      }

      // Case B: Backend returns a Map (JSON)
      if (data is Map) {
        // Try to parse as our standard ErrorResponse
        try {
          final errorResponse = ErrorResponse.fromJson(
            Map<String, dynamic>.from(data),
          );
          return errorResponse.message;
        } catch (_) {
          // If that fails, try to get 'message' or 'error' field
          final message = data['message'] ?? data['error'] ?? data['Message'];
          if (message != null && message is String && message.isNotEmpty) {
            return message;
          }
          // Fallback: use status code and status message
          return 'Error ${error.response?.statusCode}: ${error.response?.statusMessage ?? 'Unexpected error'}';
        }
      }

      // Case C: Something else (List, null, etc.)
      return 'Server error (${error.response?.statusCode}). Please try again.';
    } catch (e) {
      // Ultimate catch – should never happen, but prevents crash
      print('❌ Unhandled parse error: $e');
      return 'An unexpected error occurred. Please check backend logs.';
    }
  }
}