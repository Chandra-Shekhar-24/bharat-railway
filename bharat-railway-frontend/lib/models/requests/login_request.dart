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
 * Login request DTO for the authentication API.
 * Contains username and password fields.
 * Used in POST /api/v1/auth/login endpoint.
 * Field names match the backend LoginRequest.java DTO.
 */

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}