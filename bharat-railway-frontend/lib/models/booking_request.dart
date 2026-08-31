/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Booking request model for creating a new booking.
 */

import 'passenger_request.dart';

class BookingRequest {
  final int userId;
  final String trainNumber;
  final String sourceStationCode;
  final String destinationStationCode;
  final String journeyDate;
  final List<PassengerRequest> passengers;

  BookingRequest({
    required this.userId,
    required this.trainNumber,
    required this.sourceStationCode,
    required this.destinationStationCode,
    required this.journeyDate,
    required this.passengers,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'trainNumber': trainNumber,
      'sourceStationCode': sourceStationCode,
      'destinationStationCode': destinationStationCode,
      'journeyDate': journeyDate,
      'passengers': passengers.map((p) => p.toJson()).toList(),
    };
  }
}