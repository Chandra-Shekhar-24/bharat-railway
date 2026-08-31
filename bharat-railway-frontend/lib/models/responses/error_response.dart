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
 * Error response DTO for the authentication API.
 * Maps to backend ErrorResponse.java record.
 * Used globally for all API error responses.
 * Fields: timestamp, status, error, message, path.
 */

class ErrorResponse {
  final String timestamp;
  final int status;
  final String error;
  final String message;
  final String path;

  ErrorResponse({
    required this.timestamp,
    required this.status,
    required this.error,
    required this.message,
    required this.path,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      timestamp: json['timestamp'] as String,
      status: json['status'] as int,
      error: json['error'] as String,
      message: json['message'] as String,
      path: json['path'] as String,
    );
  }
}