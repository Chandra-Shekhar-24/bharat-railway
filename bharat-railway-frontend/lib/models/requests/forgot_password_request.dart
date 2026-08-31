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
 * Forgot password request DTO for the authentication API.
 * Contains email and channel fields.
 * Maps to backend ForgotPasswordRequest.java.
 * Channel can be 'email' or 'sms'.
 */

class ForgotPasswordRequest {
  final String email;
  final String channel;

  ForgotPasswordRequest({
    required this.email,
    required this.channel,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'channel': channel,
    };
  }
}