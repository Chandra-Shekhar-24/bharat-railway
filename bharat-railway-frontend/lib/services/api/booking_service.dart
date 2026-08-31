/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Complete booking service with all CRUD operations.
 */

import 'package:dio/dio.dart';

import '../../models/booking_request.dart';
import '../../models/booking_response.dart';
import '../../models/passenger_request.dart';
import 'dio_client.dart';

class BookingService {
  final Dio _dio = DioClient.instance;

  // POST /api/v1/bookings
  Future<BookingResponse> createBooking(BookingRequest request) async {
    try {
      final response = await _dio.post(
        '/api/v1/bookings',
        data: request.toJson(),
      );
      return BookingResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // GET /api/v1/bookings/pnr/{pnr}
  Future<BookingResponse> getBookingByPnr(String pnr) async {
    try {
      final response = await _dio.get(
        '/api/v1/bookings/pnr/$pnr',
      );
      return BookingResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // GET /api/v1/bookings/user/{userId}
  Future<List<BookingResponse>> getBookingsByUser(int userId) async {
    try {
      final response = await _dio.get(
        '/api/v1/bookings/user/$userId',
      );
      if (response.data is List) {
        return (response.data as List)
            .map((e) => BookingResponse.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // GET /api/v1/bookings/{bookingId}/passengers
  Future<List<PassengerRequest>> getPassengersByBooking(int bookingId) async {
    try {
      final response = await _dio.get(
        '/api/v1/bookings/$bookingId/passengers',
      );
      if (response.data is List) {
        return (response.data as List)
            .map((e) => PassengerRequest.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE /api/v1/bookings/{bookingId}
  Future<void> cancelBooking(int bookingId) async {
    try {
      await _dio.delete(
        '/api/v1/bookings/$bookingId',
      );
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