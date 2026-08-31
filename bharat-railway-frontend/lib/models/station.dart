/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Station model for train search.
 * Maps to backend station response.
 */

class Station {
  final String code;
  final String name;
  final String? state;

  Station({
    required this.code,
    required this.name,
    this.state,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      code: json['code'] ?? json['stationCode'] ?? '',
      name: json['name'] ?? json['stationName'] ?? '',
      state: json['state'],
    );
  }

  @override
  String toString() => '$name ($code)';
}