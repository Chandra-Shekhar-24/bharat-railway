/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 2.0.0
 *
 * Description:
 * Production-ready train search screen with modern UI.
 */

import 'package:flutter/material.dart';

import '../../services/train_service.dart';
import '../../models/station.dart';
import '../../models/search_request.dart';
import '../../themes/app_theme.dart';
import 'train_results_screen.dart';

class TrainSearchScreen extends StatefulWidget {
  const TrainSearchScreen({super.key});

  @override
  State<TrainSearchScreen> createState() => _TrainSearchScreenState();
}

class _TrainSearchScreenState extends State<TrainSearchScreen> {
  final TrainService _trainService = TrainService();

  List<Station> _stations = [];
  Station? _origin;
  Station? _destination;
  DateTime _journeyDate = DateTime.now().add(const Duration(days: 1));
  bool _isLoading = false;
  bool _isLoadingStations = true;
  String? _error;

  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _loadStations() async {
    setState(() {
      _isLoadingStations = true;
      _error = null;
    });
    try {
      _stations = await _trainService.getStations();
      if (_stations.isEmpty) {
        _stations = [
          Station(code: 'NDLS', name: 'New Delhi'),
          Station(code: 'BCT', name: 'Mumbai Central'),
          Station(code: 'HWH', name: 'Kolkata Howrah'),
          Station(code: 'MAS', name: 'Chennai Central'),
          Station(code: 'SBC', name: 'Bengaluru'),
        ];
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoadingStations = false);
    }
  }

  void _showStationPicker({required bool isOrigin}) {
    final List<Station> filteredList =
        isOrigin
            ? _stations.where((s) => s.code != _destination?.code).toList()
            : _stations.where((s) => s.code != _origin?.code).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            String searchQuery = '';
            List<Station> displayList = filteredList;

            return Container(
              height: 450,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Station',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search station...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF1E40AF)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                        displayList = filteredList.where((s) {
                          return s.name.toLowerCase().contains(searchQuery) ||
                              s.code.toLowerCase().contains(searchQuery);
                        }).toList();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _isLoadingStations
                        ? const Center(child: CircularProgressIndicator())
                        : displayList.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off, size: 48, color: Colors.grey),
                                SizedBox(height: 8),
                                Text('No stations found', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: displayList.length,
                            itemBuilder: (context, index) {
                              final station = displayList[index];
                              return ListTile(
                                title: Text(
                                  station.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    if (isOrigin) {
                                      _origin = station;
                                      _originController.text = station.toString();
                                    } else {
                                      _destination = station;
                                      _destinationController.text = station.toString();
                                    }
                                  });
                                },
                                leading: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: const Color(0xFF1E40AF).withOpacity(0.1),
                                  child: const Icon(Icons.train, color: Color(0xFF1E40AF), size: 20),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _journeyDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 120)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E40AF),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _journeyDate = picked);
    }
  }

  void _searchTrains() {
    if (_origin == null || _destination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select origin and destination stations'),
          backgroundColor: Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_origin!.code == _destination!.code) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Origin and destination cannot be same'),
          backgroundColor: Color(0xFFF59E0B),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final dateStr =
        '${_journeyDate.year}-${_journeyDate.month.toString().padLeft(2, '0')}-${_journeyDate.day.toString().padLeft(2, '0')}';

    final request = SearchRequest(
      origin: _origin!.code,
      destination: _destination!.code,
      date: dateStr,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainResultsScreen(
          searchRequest: request,
          originName: _origin!.name,
          destinationName: _destination!.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        title: const Text(
          'Search Trains',
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.train, color: Color(0xFF1E40AF), size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Find Your Train',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Search by station and date',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => _showStationPicker(isOrigin: true),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _originController,
                    decoration: InputDecoration(
                      labelText: 'Source Station',
                      hintText: 'Select source station',
                      prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF1E40AF)),
                      suffixIcon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1E40AF)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF1E40AF), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.swap_vert, color: Color(0xFF1E40AF), size: 28),
                    onPressed: () {
                      final temp = _origin;
                      final tempText = _originController.text;
                      setState(() {
                        _origin = _destination;
                        _destination = temp;
                        _originController.text = _destinationController.text;
                        _destinationController.text = tempText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _showStationPicker(isOrigin: false),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _destinationController,
                    decoration: InputDecoration(
                      labelText: 'Destination Station',
                      hintText: 'Select destination station',
                      prefixIcon: const Icon(Icons.location_city_outlined, color: Color(0xFF1E40AF)),
                      suffixIcon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1E40AF)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF1E40AF), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: Color(0xFF1E40AF)),
                      const SizedBox(width: 12),
                      Text(
                        '${_journeyDate.day}/${_journeyDate.month}/${_journeyDate.year}',
                        style: const TextStyle(fontSize: 16, color: Color(0xFF111827)),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down, color: Color(0xFF1E40AF)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _searchTrains,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'SEARCH TRAINS',
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
}