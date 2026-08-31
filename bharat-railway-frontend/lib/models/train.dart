/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Train model for search results and details.
 */

class Train {
  final String trainNumber;
  final String trainName;
  final String origin;
  final String destination;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String? runningDays;
  final List<RouteStop>? route;
  final Map<String, int>? seatAvailability;

  Train({
    required this.trainNumber,
    required this.trainName,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    this.runningDays,
    this.route,
    this.seatAvailability,
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    return Train(
      trainNumber: json['trainNumber'] ?? json['trainNo'] ?? '',
      trainName: json['trainName'] ?? json['name'] ?? '',
      origin: json['origin'] ?? json['source'] ?? '',
      destination: json['destination'] ?? json['dest'] ?? '',
      departureTime: json['departureTime'] ?? json['departure'] ?? '',
      arrivalTime: json['arrivalTime'] ?? json['arrival'] ?? '',
      duration: json['duration'] ?? '',
      runningDays: json['runningDays'],
      route: json['route'] != null
          ? (json['route'] as List).map((e) => RouteStop.fromJson(e)).toList()
          : null,
      seatAvailability: json['seatAvailability'] != null
          ? Map<String, int>.from(json['seatAvailability'])
          : null,
    );
  }
}

class RouteStop {
  final String stationCode;
  final String stationName;
  final String? arrivalTime;
  final String? departureTime;
  final int? distance;
  final int? day;

  RouteStop({
    required this.stationCode,
    required this.stationName,
    this.arrivalTime,
    this.departureTime,
    this.distance,
    this.day,
  });

  factory RouteStop.fromJson(Map<String, dynamic> json) {
    return RouteStop(
      stationCode: json['stationCode'] ?? json['code'] ?? '',
      stationName: json['stationName'] ?? json['name'] ?? '',
      arrivalTime: json['arrivalTime'] ?? json['arrival'],
      departureTime: json['departureTime'] ?? json['departure'],
      distance: json['distance'],
      day: json['day'],
    );
  }
}