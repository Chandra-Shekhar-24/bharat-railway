/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-02
 * Version: 2.0.0
 *
 * Description:
 * Train model updated to match backend TrainSearchResponse.
 * Includes departureTime, arrivalTime, duration, fareEstimate, availableSeats.
 */

class Train {
  final String trainNumber;
  final String trainName;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final double fareEstimate;
  final Map<String, int> availableSeats;

  Train({
    required this.trainNumber,
    required this.trainName,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.fareEstimate,
    required this.availableSeats,
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    return Train(
      trainNumber: json['trainNumber'] ?? json['trainNo'] ?? '',
      trainName: json['trainName'] ?? json['name'] ?? '',
      departureTime: json['departureTime'] ?? json['departure'] ?? '',
      arrivalTime: json['arrivalTime'] ?? json['arrival'] ?? '',
      duration: json['duration'] ?? '',
      fareEstimate: (json['fareEstimate'] ?? json['fare'] ?? 0.0).toDouble(),
      availableSeats: json['availableSeats'] != null
          ? Map<String, int>.from(json['availableSeats'])
          : {},
    );
  }

  String getSeatSummary() {
    if (availableSeats.isEmpty) return 'No seats available';
    return availableSeats.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(' | ');
  }

  Map<String, dynamic> toJson() {
    return {
      'trainNumber': trainNumber,
      'trainName': trainName,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'duration': duration,
      'fareEstimate': fareEstimate,
      'availableSeats': availableSeats,
    };
  }
}