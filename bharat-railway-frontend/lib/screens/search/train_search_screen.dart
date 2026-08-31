/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Train search screen with station dropdowns, date picker, and search button.
 * Fetches stations from backend and displays search results.
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
  String? _error;

  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  Future<void> _loadStations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      _stations = await _trainService.getStations();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showStationPicker({required bool isOrigin}) {
    final List<Station> filteredList =
        isOrigin
            ? _stations.where((s) => s.code != _destination?.code).toList()
            : _stations.where((s) => s.code != _origin?.code).toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            String searchQuery = '';
            List<Station> displayList = filteredList;

            return Container(
              height: 400,
              padding: const EdgeInsets.all(16),
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
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search station...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
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
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : displayList.isEmpty
                        ? const Center(
                            child: Text('No stations found'),
                          )
                        : ListView.builder(
                            itemCount: displayList.length,
                            itemBuilder: (context, index) {
                              final station = displayList[index];
                              return ListTile(
                                title: Text(station.toString()),
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    if (isOrigin) {
                                      _origin = station;
                                      _originController.text =
                                          station.toString();
                                    } else {
                                      _destination = station;
                                      _destinationController.text =
                                          station.toString();
                                    }
                                  });
                                },
                                leading: const Icon(
                                  Icons.train,
                                  color: AppTheme.primaryColor,
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
              primary: AppTheme.primaryColor,
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
          content: Text('Please select origin and destination'),
          backgroundColor: AppTheme.errorColor,
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
      backgroundColor: Colors.white,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.train,
                        color: Color(0xFF1E40AF),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Find Your Train',
                            style: TextStyle(
                              fontSize: 18,
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
              // Origin Field
              GestureDetector(
                onTap: () => _showStationPicker(isOrigin: true),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _originController,
                    decoration: InputDecoration(
                      labelText: 'Source Station',
                      hintText: 'Select source',
                      prefixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF1E40AF),
                      ),
                      suffixIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF1E40AF),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF1E40AF),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Swap Button
              Center(
                child: IconButton(
                  icon: const Icon(Icons.swap_vert, color: Color(0xFF1E40AF)),
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
              const SizedBox(height: 16),
              // Destination Field
              GestureDetector(
                onTap: () => _showStationPicker(isOrigin: false),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _destinationController,
                    decoration: InputDecoration(
                      labelText: 'Destination Station',
                      hintText: 'Select destination',
                      prefixIcon: const Icon(
                        Icons.location_city_outlined,
                        color: Color(0xFF1E40AF),
                      ),
                      suffixIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF1E40AF),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF1E40AF),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Date Picker
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0xFF1E40AF),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${_journeyDate.day}/${_journeyDate.month}/${_journeyDate.year}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF1E40AF),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Search Button
              SizedBox(
                width: double.infinity,
                height: 54,
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