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
 * API constants for the Bharat Railway Booking System frontend.
 * Contains base URLs, authentication endpoints, booking endpoints,
 * token configuration, and Tailscale IP for mobile connectivity.
 *
 * Version History:
 * version 1.0.0: Initial file creation. Added Tailscale IP for mobile.
 *                Added booking endpoints for booking flow.
 */

class ApiConstants {
  // Base URLs
  static const String baseUrlLocal = 'http://localhost:8080';
  static const String baseUrlEmulator = 'http://100.95.255.78:8080'; // Laptop Tailscale IP
  static const String baseUrlProd = '';

  // Authentication Endpoints
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String forgotPassword = '/api/v1/auth/forgot-password';
  static const String resetPassword = '/api/v1/auth/reset-password';

  // Train Master Endpoints
  static const String stations = '/api/v1/trainmaster/stations';
  static const String trainsSearch = '/api/v1/trainmaster/trains/search';
  static const String trainRoute = '/api/v1/trainmaster/routes/train';
  static const String seatAvailability = '/api/v1/trainmaster/seats/train';

  // Booking Endpoints
  static const String bookings = '/api/v1/bookings';
  static const String bookingsPnr = '/api/v1/bookings/pnr';
  static const String bookingsUser = '/api/v1/bookings/user';

  // Token Storage
  static const String tokenStorageKey = 'access_token';
  static const int tokenExpirySeconds = 3600;
}