/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Booking response model from backend API.
 */

class BookingResponse {
  final int bookingId;
  final String pnrNumber;
  final int userId;
  final String trainNumber;
  final String sourceStationCode;
  final String destinationStationCode;
  final String journeyDate;
  final double totalFare;
  final String bookingStatus;
  final String paymentStatus;

  BookingResponse({
    required this.bookingId,
    required this.pnrNumber,
    required this.userId,
    required this.trainNumber,
    required this.sourceStationCode,
    required this.destinationStationCode,
    required this.journeyDate,
    required this.totalFare,
    required this.bookingStatus,
    required this.paymentStatus,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      bookingId: json['bookingId'] as int,
      pnrNumber: json['pnrNumber'] as String,
      userId: json['userId'] as int,
      trainNumber: json['trainNumber'] as String,
      sourceStationCode: json['sourceStationCode'] as String,
      destinationStationCode: json['destinationStationCode'] as String,
      journeyDate: json['journeyDate'] as String,
      totalFare: (json['totalFare'] as num).toDouble(),
      bookingStatus: json['bookingStatus'] as String,
      paymentStatus: json['paymentStatus'] as String,
    );
  }
}