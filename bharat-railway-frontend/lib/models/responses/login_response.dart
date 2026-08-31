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
 * Login response DTO for the authentication API.
 * Maps to backend LoginResponse.java.
 * Contains accessToken, tokenType, expiresIn, and sessionId.
 * Used after successful POST /api/v1/auth/login.
 */

class LoginResponse {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final String sessionId;

  LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.sessionId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] as String,
      tokenType: json['tokenType'] as String,
      expiresIn: json['expiresIn'] as int,
      sessionId: json['sessionId'] as String,
    );
  }
}