/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Profile service for user profile operations.
 */

import 'package:dio/dio.dart';
import 'dio_client.dart';

class ProfileService {
  final Dio _dio = DioClient.instance;

  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String email,
    required String mobileNumber,
  }) async {
    try {
      final response = await _dio.put(
        '/api/v1/users/profile',
        data: {
          'fullName': fullName,
          'email': email,
          'mobileNumber': mobileNumber,
        },
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to update profile');
      }
      throw Exception('Network error. Please check your connection.');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get('/api/v1/users/profile');
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to fetch profile');
      }
      throw Exception('Network error. Please check your connection.');
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        '/api/v1/users/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to change password');
      }
      throw Exception('Network error. Please check your connection.');
    }
  }
}