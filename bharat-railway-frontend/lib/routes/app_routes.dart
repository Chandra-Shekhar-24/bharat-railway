/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Assisted by:
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Route definitions for the Bharat Railway Booking System.
 * Contains route names and route mapping for all screens.
 */

import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search/train_search_screen.dart';
import '../screens/booking/pnr_status_screen.dart';
import '../screens/booking/booking_history_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String trainSearch = '/train-search';
  static const String pnrStatus = '/pnr-status';
  static const String bookingHistory = '/booking-history';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    resetPassword: (context) => const ResetPasswordScreen(),
    home: (context) => const HomeScreen(),
    trainSearch: (context) => const TrainSearchScreen(),
    pnrStatus: (context) => const PnrStatusScreen(),
    bookingHistory: (context) => const BookingHistoryScreen(),
    profile: (context) => const ProfileScreen(),
  };
}