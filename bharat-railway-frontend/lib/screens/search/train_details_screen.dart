/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Train details screen with route timeline, seat availability, and booking.
 */

import 'package:flutter/material.dart';

import '../../services/train_service.dart';
import '../../models/train.dart';
import '../../themes/app_theme.dart';

class TrainDetailsScreen extends StatefulWidget {
  final Train train;

  const TrainDetailsScreen({
    super.key,
    required this.train,
  });

  @override
  State<TrainDetailsScreen> createState() => _TrainDetailsScreenState();
}

class _TrainDetailsScreenState extends State<TrainDetailsScreen> {
  final TrainService _trainService = TrainService();

  String _selectedClass = '1A';
  final List<String> _coachClasses = ['1A', '2A', '3A', 'SL', 'CC', 'EC'];
  Map<String, int>? _seatAvailability;
  bool _isLoadingSeats = false;
  String? _seatError;

  @override
  void initState() {
    super.initState();
    _fetchSeatAvailability();
  }

  Future<void> _fetchSeatAvailability() async {
    setState(() {
      _isLoadingSeats = true;
      _seatError = null;
    });
    try {
      final availability = await _trainService.getSeatAvailability(
        widget.train.trainNumber,
        _selectedClass,
      );
      setState(() => _seatAvailability = availability);
    } catch (e) {
      setState(() => _seatError = e.toString());
    } finally {
      setState(() => _isLoadingSeats = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final train = widget.train;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        title: Text(
          train.trainName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Train Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.train, color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        '${train.trainNumber} • ${train.trainName}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            train.departureTime,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            train.origin,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      Column(
                        children: [
                          Text(
                            train.arrivalTime,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            train.destination,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Duration: ${train.duration}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Coach Class Selection
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Class',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _coachClasses.map((className) {
                      return ChoiceChip(
                        label: Text(className),
                        selected: _selectedClass == className,
                        selectedColor: const Color(0xFF1E40AF),
                        labelStyle: TextStyle(
                          color: _selectedClass == className
                              ? Colors.white
                              : Colors.grey[700],
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedClass = className;
                            });
                            _fetchSeatAvailability();
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Seat Availability
                  if (_isLoadingSeats)
                    const Center(child: CircularProgressIndicator())
                  else if (_seatError != null)
                    Text(
                      _seatError!,
                      style: TextStyle(color: Colors.grey[600]),
                    )
                  else if (_seatAvailability != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.event_seat,
                            color: Color(0xFF1E40AF),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Seat Availability',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  _seatAvailability!
                                      .entries
                                      .map((e) => '${e.key}: ${e.value}')
                                      .join(' • '),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Book Now Button (Placeholder)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Booking API coming soon!'),
                            backgroundColor: AppTheme.primaryColor,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E40AF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'BOOK NOW',
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
            // Route Timeline
            if (train.route != null && train.route!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Route & Timings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: train.route!.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 4),
                      itemBuilder: (context, index) {
                        final stop = train.route![index];
                        return Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: index == 0 || index == train.route!.length - 1
                                        ? const Color(0xFF1E40AF)
                                        : Colors.grey[400],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                if (index < train.route!.length - 1)
                                  Container(
                                    width: 2,
                                    height: 20,
                                    color: Colors.grey[300],
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        stop.stationName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF111827),
                                        ),
                                      ),
                                      Text(
                                        stop.stationCode,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      if (stop.arrivalTime != null)
                                        Text(
                                          'Arr: ${stop.arrivalTime}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      if (stop.departureTime != null)
                                        Text(
                                          'Dep: ${stop.departureTime}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      if (stop.day != null)
                                        Text(
                                          'Day ${stop.day}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}