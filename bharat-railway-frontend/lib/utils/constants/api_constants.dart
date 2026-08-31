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
 * API constants for the Bharat Railway Booking System frontend.
 * Contains base URLs, authentication endpoints, and token configuration.
 * Base URLs support local development, Android emulator, and production.
 * Token expiry is set to 3600 seconds matching backend configuration.
 */

class ApiConstants {
  // Base URLs
  static const String baseUrlLocal = 'http://localhost:8080';
static const String baseUrlEmulator = 'http://100.95.255.78:8080';
  static const String baseUrlProd = '';

  // Authentication Endpoints
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String forgotPassword = '/api/v1/auth/forgot-password';
  static const String resetPassword = '/api/v1/auth/reset-password';

  // Token Storage
  static const String tokenStorageKey = 'access_token';
  static const int tokenExpirySeconds = 3600;
}