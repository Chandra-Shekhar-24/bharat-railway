/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Booking confirmation screen with PNR, details, payment, download, share.
 */

import 'package:flutter/material.dart';

import '../../models/booking_response.dart';
import '../../themes/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../utils/pdf_generator.dart';
import '../../services/api/payment_service.dart';

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ PDF saved at: ${file.path}'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      await PdfGenerator.shareTicket(file);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error sharing: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF059669),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                'Booking Confirmed!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your ticket has been booked successfully',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'PNR NUMBER',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bookingResponse.pnrNumber,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Status: ${bookingResponse.bookingStatus}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
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
                    if (bookingResponse.paymentStatus == 'PENDING')
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              PaymentService.openPayment(
                                amount: bookingResponse.totalFare.toInt(),
                                name: 'Bharat Railway User',
                                email: 'user@example.com',
                                contact: '9876543210',
                                description: 'Booking: ${bookingResponse.pnrNumber}',
                                onSuccess: (paymentId, signature) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('✅ Payment successful! ID: $paymentId'),
                                      backgroundColor: AppTheme.successColor,
                                    ),
                                  );
                                },
                                onError: (code, message) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('❌ Payment failed: $message'),
                                      backgroundColor: AppTheme.errorColor,
                                    ),
                                  );
                                },
                                onExternal: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('External wallet selected'),
                                      backgroundColor: Colors.grey,
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF59E0B),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Complete Payment'),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Passengers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Passenger details will be displayed here',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor ?? const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}