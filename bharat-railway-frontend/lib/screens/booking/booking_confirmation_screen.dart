/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 2.0.0
 *
 * Description:
 * Production-ready booking confirmation screen.
 */

import 'package:flutter/material.dart';

import '../../models/booking_response.dart';
import '../../themes/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../utils/pdf_generator.dart';
import 'payment_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final BookingResponse bookingResponse;
  final String trainName;
  final String origin;
  final String destination;
  final String departureTime;
  final String arrivalTime;

  const BookingConfirmationScreen({
    super.key,
    required this.bookingResponse,
    required this.trainName,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
  });

  void _showSnackBar(BuildContext context, String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isSuccess ? Icons.check_circle : Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isSuccess ? const Color(0xFF059669) : const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _downloadTicket(BuildContext context) async {
    try {
      final file = await PdfGenerator.generateTicket(
        pnrNumber: bookingResponse.pnrNumber,
        trainName: trainName,
        trainNumber: bookingResponse.trainNumber,
        origin: origin,
        destination: destination,
        journeyDate: bookingResponse.journeyDate,
        departureTime: departureTime,
        arrivalTime: arrivalTime,
        passengerName: 'Chandra Bansal',
        passengerAge: 24,
        passengerGender: 'M',
        berthPreference: 'LOWER',
        bookingStatus: bookingResponse.bookingStatus,
        totalFare: bookingResponse.totalFare,
      );
      _showSnackBar(context, '✅ Ticket downloaded: ${file.path}');
      await PdfGenerator.shareTicket(file);
    } catch (e) {
      _showSnackBar(context, '❌ Error: $e', isSuccess: false);
    }
  }

  void _shareTicket(BuildContext context) async {
    try {
      final file = await PdfGenerator.generateTicket(
        pnrNumber: bookingResponse.pnrNumber,
        trainName: trainName,
        trainNumber: bookingResponse.trainNumber,
        origin: origin,
        destination: destination,
        journeyDate: bookingResponse.journeyDate,
        departureTime: departureTime,
        arrivalTime: arrivalTime,
        passengerName: 'Chandra Bansal',
        passengerAge: 24,
        passengerGender: 'M',
        berthPreference: 'LOWER',
        bookingStatus: bookingResponse.bookingStatus,
        totalFare: bookingResponse.totalFare,
      );
      await PdfGenerator.shareTicket(file);
      _showSnackBar(context, '✅ Ticket shared successfully!');
    } catch (e) {
      _showSnackBar(context, '❌ Error sharing: $e', isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConfirmed = bookingResponse.bookingStatus == 'CONFIRMED';
    final isPending = bookingResponse.bookingStatus == 'PENDING';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        title: const Text(
          'Booking Confirmation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Success Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF059669), Color(0xFF34D399)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 64),
                    const SizedBox(height: 8),
                    const Text(
                      'Booking Confirmed!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PNR: ${bookingResponse.pnrNumber}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        bookingResponse.bookingStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Booking Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Train', '$trainName (${bookingResponse.trainNumber})'),
                    _buildDetailRow('Journey Date', bookingResponse.journeyDate),
                    _buildDetailRow('From', origin),
                    _buildDetailRow('To', destination),
                    _buildDetailRow('Departure', departureTime),
                    _buildDetailRow('Arrival', arrivalTime),
                    _buildDetailRow('Total Fare', '₹${bookingResponse.totalFare.toStringAsFixed(2)}'),
                    _buildDetailRow(
                      'Payment Status',
                      bookingResponse.paymentStatus,
                      valueColor: bookingResponse.paymentStatus == 'COMPLETED'
                          ? const Color(0xFF059669)
                          : const Color(0xFFF59E0B),
                    ),
                    if (isPending)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                    bookingId: bookingResponse.bookingId,
                                    amount: bookingResponse.totalFare,
                                    pnrNumber: bookingResponse.pnrNumber,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF59E0B),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.payment, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Complete Payment'),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _downloadTicket(context),
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Download'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1E40AF),
                        side: const BorderSide(color: Color(0xFF1E40AF)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _shareTicket(context),
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('Share'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1E40AF),
                        side: const BorderSide(color: Color(0xFF1E40AF)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'GO TO HOME',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}