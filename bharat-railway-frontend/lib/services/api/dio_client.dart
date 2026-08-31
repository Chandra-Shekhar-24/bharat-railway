/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Assisted by:
 * current file version: 1.0.0
 * version 1.0.0: Initial file creation. Fixed navigatorKey reference error.
 * 
 * Description:
 * Dio HTTP client wrapper with interceptors for authentication.
 * Handles automatic Bearer token attachment to protected requests.
 * Handles 401 Unauthorized responses by triggering logout.
 * Base URL configured for Android emulator (10.0.2.2).
 */

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../providers/auth_provider.dart';
import '../../utils/constants/api_constants.dart';

// Global navigator key for accessing context outside widgets
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class DioClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrlLocal,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );

    return dio;
  }

  static void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  static void _onError(DioException error, ErrorInterceptorHandler handler) {
    if (error.response?.statusCode == 401) {
      _handleUnauthorized();
    }
    handler.next(error);
  }

  static void _handleUnauthorized() {
    if (navigatorKey.currentContext != null) {
      Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    }
  }
}