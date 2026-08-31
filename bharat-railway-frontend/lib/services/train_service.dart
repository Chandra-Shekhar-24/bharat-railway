/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Train service for station and train API calls.
 */

import 'package:dio/dio.dart';

import '../models/station.dart';
import '../models/train.dart';
import '../models/search_request.dart';
import 'api/dio_client.dart';

class TrainService {
  final Dio _dio = DioClient.instance;

  // GET /api/v1/trainmaster/stations
  Future<List<Station>> getStations() async {
    try {
      final response = await _dio.get('/api/v1/trainmaster/stations');
      if (response.data is List) {
        return (response.data as List)
            .map((e) => Station.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // GET /api/v1/trainmaster/trains/search?origin=BCT&destination=NDLS
  Future<List<Train>> searchTrains(SearchRequest request) async {
    try {
      final response = await _dio.get(
        '/api/v1/trainmaster/trains/search',
        queryParameters: request.toQueryParams(),
      );
      if (response.data is List) {
        return (response.data as List)
            .map((e) => Train.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // GET /api/v1/trainmaster/routes/train/{trainNumber}
  Future<Train> getTrainRoute(String trainNumber) async {
    try {
      final response = await _dio.get(
        '/api/v1/trainmaster/routes/train/$trainNumber',
      );
      return Train.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // GET /api/v1/trainmaster/seats/train/{trainNumber}/class/{coachClass}
  Future<Map<String, int>> getSeatAvailability(
    String trainNumber,
    String coachClass,
  ) async {
    try {
      final response = await _dio.get(
        '/api/v1/trainmaster/seats/train/$trainNumber/class/$coachClass',
      );
      return Map<String, int>.from(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.response == null) {
      return 'Network error. Please check your connection.';
    }
    try {
      final data = error.response!.data;
      if (data is String) return data;
      if (data is Map) {
        return data['message'] ?? data['error'] ?? 'Server error.';
      }
      return 'Server error (${error.response?.statusCode}).';
    } catch (_) {
      return 'An unexpected error occurred.';
    }
  }
}