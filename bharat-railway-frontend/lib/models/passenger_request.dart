/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Passenger request model for booking API.
 */

class PassengerRequest {
  final String fullName;
  final int age;
  final String gender;
  final String berthPreference;

  PassengerRequest({
    required this.fullName,
    required this.age,
    required this.gender,
    required this.berthPreference,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'age': age,
      'gender': gender,
      'berthPreference': berthPreference,
    };
  }

  factory PassengerRequest.fromJson(Map<String, dynamic> json) {
    return PassengerRequest(
      fullName: json['fullName'] ?? json['full_name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      berthPreference: json['berthPreference'] ?? json['berth_preference'] ?? '',
    );
  }
}