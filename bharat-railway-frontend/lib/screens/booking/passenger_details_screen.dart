/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Passenger details screen for booking flow.
 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/passenger_request.dart';
import '../../models/booking_request.dart';
import '../../services/api/booking_service.dart';
import '../../providers/auth_provider.dart';
import '../../themes/app_theme.dart';
import 'booking_confirmation_screen.dart';

class PassengerDetailsScreen extends StatefulWidget {
  final String trainNumber;
  final String trainName;
  final String origin;
  final String destination;
  final String originCode;
  final String destinationCode;
  final String journeyDate;
  final String departureTime;
  final String arrivalTime;

  const PassengerDetailsScreen({
    super.key,
    required this.trainNumber,
    required this.trainName,
    required this.origin,
    required this.destination,
    required this.originCode,
    required this.destinationCode,
    required this.journeyDate,
    required this.departureTime,
    required this.arrivalTime,
  });

  @override
  State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  final BookingService _bookingService = BookingService();
  final List<PassengerRequest> _passengers = [];
  bool _isLoading = false;
  String? _error;

  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _ageControllers = [];
  final List<String> _genders = [];
  final List<String> _berthPreferences = [];

  final List<String> _genderOptions = ['M', 'F', 'O'];
  final List<String> _berthOptions = ['LOWER', 'MIDDLE', 'UPPER', 'SIDE_LOWER', 'SIDE_UPPER'];

  @override
  void initState() {
    super.initState();
    _addPassenger();
  }

  @override
  void dispose() {
    for (var c in _nameControllers) c.dispose();
    for (var c in _ageControllers) c.dispose();
    super.dispose();
  }

  void _addPassenger() {
    setState(() {
      _passengers.add(PassengerRequest(
        fullName: '',
        age: 0,
        gender: 'M',
        berthPreference: 'LOWER',
      ));
      _nameControllers.add(TextEditingController());
      _ageControllers.add(TextEditingController());
      _genders.add('M');
      _berthPreferences.add('LOWER');
    });
  }

  void _removePassenger(int index) {
    if (_passengers.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one passenger is required'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }
    setState(() {
      _passengers.removeAt(index);
      _nameControllers.removeAt(index);
      _ageControllers.removeAt(index);
      _genders.removeAt(index);
      _berthPreferences.removeAt(index);
    });
  }

  void _updatePassenger(int index) {
    final name = _nameControllers[index].text.trim();
    final age = int.tryParse(_ageControllers[index].text.trim()) ?? 0;
    _passengers[index] = PassengerRequest(
      fullName: name.isNotEmpty ? name : _passengers[index].fullName,
      age: age > 0 ? age : _passengers[index].age,
      gender: _genders[index],
      berthPreference: _berthPreferences[index],
    );
  }

  int _getUserIdFromToken(String? token) {
    try {
      if (token == null) return 1;
      final parts = token.split('.');
      if (parts.length != 3) return 1;
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      return payload['userId'] ?? payload['sub'] ?? 1;
    } catch (_) {
      return 1;
    }
  }

  Future<void> _proceedToBooking() async {
    for (int i = 0; i < _passengers.length; i++) {
      final name = _nameControllers[i].text.trim();
      final age = int.tryParse(_ageControllers[i].text.trim()) ?? 0;

      if (name.isEmpty) {
        _showError('Please enter name for passenger ${i + 1}');
        return;
      }
      if (age < 1 || age > 120) {
        _showError('Please enter valid age for passenger ${i + 1}');
        return;
      }
      _passengers[i] = PassengerRequest(
        fullName: name,
        age: age,
        gender: _genders[i],
        berthPreference: _berthPreferences[i],
      );
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final userId = _getUserIdFromToken(authProvider.token);

      final request = BookingRequest(
        userId: userId,
        trainNumber: widget.trainNumber,
        sourceStationCode: widget.originCode,
        destinationStationCode: widget.destinationCode,
        journeyDate: widget.journeyDate,
        passengers: _passengers,
      );

      final response = await _bookingService.createBooking(request);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingConfirmationScreen(
              bookingResponse: response,
              trainName: widget.trainName,
              origin: widget.origin,
              destination: widget.destination,
              departureTime: widget.departureTime,
              arrivalTime: widget.arrivalTime,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _error = e.toString());
      _showError(_error!);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        title: const Text(
          'Passenger Details',
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Train Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem('Train', '${widget.trainName} (${widget.trainNumber})'),
                  _buildSummaryItem('Date', widget.journeyDate),
                  _buildSummaryItem('Time', '${widget.departureTime} - ${widget.arrivalTime}'),
                ],
              ),
            ),
            // Passenger List Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Passengers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_passengers.length} passenger${_passengers.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Color(0xFF1E40AF)),
                    onPressed: _addPassenger,
                  ),
                ],
              ),
            ),
            // Passenger List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _passengers.length,
                itemBuilder: (context, index) => _buildPassengerCard(index),
              ),
            ),
            // Proceed Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _proceedToBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'PROCEED TO BOOK',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPassengerCard(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E40AF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Passenger ${index + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
                if (_passengers.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _removePassenger(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameControllers[index],
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter passenger name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              onChanged: (_) => _updatePassenger(index),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _ageControllers[index],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      hintText: 'e.g., 24',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    onChanged: (_) => _updatePassenger(index),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _genders[index],
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _genderOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (value) {
                      setState(() {
                        _genders[index] = value!;
                        _updatePassenger(index);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _berthPreferences[index],
              decoration: InputDecoration(
                labelText: 'Berth Preference',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _berthOptions.map((b) {
                return DropdownMenuItem(
                  value: b,
                  child: Text(b.replaceAll('_', ' ').toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _berthPreferences[index] = value!;
                  _updatePassenger(index);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}