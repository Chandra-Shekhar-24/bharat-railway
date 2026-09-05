/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Profile management screen – view and update user profile.
 * Fetches user data from JWT token and allows editing.
 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../../providers/auth_provider.dart';
import '../../themes/app_theme.dart';
import '../../widgets/auth/auth_button.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../services/api/dio_client.dart';

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
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false;
  String? _error;

  final ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.token;
    if (token != null) {
      try {
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload = jsonDecode(
            utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
          );
          _nameController.text = payload['fullName'] ?? payload['name'] ?? '';
          _emailController.text = payload['email'] ?? '';
          _usernameController.text = payload['username'] ?? payload['sub'] ?? '';
          _mobileController.text = payload['mobileNumber'] ?? payload['phone'] ?? '';
        }
      } catch (_) {
        // Ignore parse errors
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _profileService.updateProfile(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        mobileNumber: _mobileController.text.trim(),
      );

      // Update token with new data if needed
      // For now, just show success
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        setState(() => _isEditing = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_error!),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  _loadUserData();
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Avatar
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E40AF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF1E40AF),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _usernameController.text.isNotEmpty
                      ? _usernameController.text
                      : 'User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 24),

                // Full Name
                AuthTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  prefixIcon: Icons.person_outline,
                  enabled: _isEditing,
                  validator: _isEditing
                      ? (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          if (value.length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        }
                      : null,
                ),
                const SizedBox(height: 16),

                // Email
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  enabled: _isEditing,
                  keyboardType: TextInputType.emailAddress,
                  validator: _isEditing
                      ? (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        }
                      : null,
                ),
                const SizedBox(height: 16),

                // Mobile Number
                AuthTextField(
                  controller: _mobileController,
                  label: 'Mobile Number',
                  hint: 'Enter your mobile number',
                  prefixIcon: Icons.phone_outlined,
                  enabled: _isEditing,
                  keyboardType: TextInputType.phone,
                  validator: _isEditing
                      ? (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                            return 'Please enter a valid 10-digit mobile number';
                          }
                          return null;
                        }
                      : null,
                ),
                const SizedBox(height: 16),

                // Username (read-only)
                AuthTextField(
                  controller: _usernameController,
                  label: 'Username',
                  hint: 'Your username',
                  prefixIcon: Icons.account_circle_outlined,
                  enabled: false,
                ),
                const SizedBox(height: 24),

                if (_isEditing)
                  AuthButton(
                    onPressed: _saveProfile,
                    isLoading: _isLoading,
                    text: 'Save Profile',
                  ),

                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: AppTheme.errorColor,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}