/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-07-19
 * Version: 1.0.0
 *
 * Description:
 * Booking screen – contains search fields (Source, Destination, Date, Class)
 * and a train list that will display results from backend.
 * Dummy data removed; page ready to integrate with real API.
 *
 * Version History:
 * version 1.0.0: Initial file creation. Replaced dummy train list with
 *                search input fields at top; removed hardcoded data;
 *                kept empty list view with placeholder message.
 */

import 'package:flutter/material.dart';

class BookTicketScreen extends StatefulWidget {
  const BookTicketScreen({super.key});

  @override
  State<BookTicketScreen> createState() => _BookTicketScreenState();
}

class _BookTicketScreenState extends State<BookTicketScreen> {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedClass = 'All Classes';

  final List<String> _classOptions = [
    'All Classes',
    'Sleeper',
    'AC 3 Tier',
    'AC 2 Tier',
    'AC 1st Class',
    'General'
  ];

  // This will be replaced by real data from API
  final List<Map<String, dynamic>> _trains = [];

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _searchTrains() {
    // Placeholder for API call – will be implemented later
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Search functionality coming soon – will fetch trains from backend'),
        backgroundColor: Color(0xFF1E40AF),
      ),
    );
    // In future, this will call a service and update _trains list.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        title: const Text(
          'Book Ticket',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Fields
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _sourceController,
                    decoration: InputDecoration(
                      labelText: 'Source',
                      labelStyle: const TextStyle(color: Color(0xFF4B5563), fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF1E40AF), width: 2),
                      ),
                      prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF1E40AF)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(color: Color(0xFF111827), fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _destinationController,
                    decoration: InputDecoration(
                      labelText: 'Destination',
                      labelStyle: const TextStyle(color: Color(0xFF4B5563), fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF1E40AF), width: 2),
                      ),
                      prefixIcon: const Icon(Icons.location_city_outlined, color: Color(0xFF1E40AF)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(color: Color(0xFF111827), fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, color: Color(0xFF1E40AF), size: 20),
                          const SizedBox(width: 10),
                          Text(_formatDate(_selectedDate), style: const TextStyle(color: Color(0xFF111827), fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedClass,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1E40AF)),
                        style: const TextStyle(color: Color(0xFF111827), fontSize: 16),
                        items: _classOptions.map((value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                        onChanged: (newValue) => setState(() => _selectedClass = newValue!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _searchTrains,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E40AF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                child: const Text('Search Trains', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ),
            ),
            const SizedBox(height: 20),
            // Train List
            Expanded(
              child: _trains.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.train_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No trains found',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Search for trains to see them here',
                            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _trains.length,
                      itemBuilder: (context, index) {
                        final train = _trains[index];
                        // This will be built with real data in future.
                        return const Card(child: ListTile(title: Text('Train')));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}