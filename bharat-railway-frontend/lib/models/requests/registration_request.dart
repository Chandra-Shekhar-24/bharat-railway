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
 * Registration request DTO for the authentication API.
 * Contains all fields required for user registration.
 * Maps to backend RegistrationRequest.java.
 * Field names and validation rules match backend exactly.
 */

class RegistrationRequest {
  final String fullName;
  final String username;
  final String email;
  final String mobileNumber;
  final String password;
  final String dateOfBirth;
  final String gender;

  RegistrationRequest({
    required this.fullName,
    required this.username,
    required this.email,
    required this.mobileNumber,
    required this.password,
    required this.dateOfBirth,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'mobileNumber': mobileNumber,
      'password': password,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
    };
  }
}