/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Home screen – dashboard with welcome banner, quick action cards.
 * Displays logged‑in user's full name from JWT.
 * Updated Book Ticket navigation to TrainSearchScreen.
 *
 * Version History:
 * version 1.0.0: Initial file creation. Redesigned UI with smaller cards,
 *                improved spacing, and full name display.
 *                Updated Book Ticket to navigate to TrainSearchScreen.
 */

import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/sidebar_menu.dart';
import '../screens/search/train_search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _staggerController;

  final List<Map<String, dynamic>> _actions = [
    {'icon': Icons.train_outlined, 'title': 'Book Ticket', 'subtitle': 'Search & book', 'soon': false},
    {'icon': Icons.receipt_long_outlined, 'title': 'PNR Status', 'subtitle': 'Check PNR', 'soon': true},
    {'icon': Icons.schedule_outlined, 'title': 'Train Schedule', 'subtitle': 'View schedule', 'soon': true},
    {'icon': Icons.history_outlined, 'title': 'Booking History', 'subtitle': 'Past bookings', 'soon': true},
  ];

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  void _showComingSoonSnackbar(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.rocket_launch, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text('$featureName feature coming soon! 🚀', style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
        backgroundColor: Colors.grey[850],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  String _getFullNameFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return 'User';
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      // 🔍 Print decoded payload to console – copy this JSON to find your name key
      print(payload);

      // Extended list of possible name keys – add your key here as the first entry
      final nameKeys = [
        'fullName',
        'full_name',
        'displayName',
        'display_name',
        'name',
        'userFullName',
        'user_full_name',
        'preferred_username',
        'given_name',
        'family_name',
      ];

      String name = '';
      for (var key in nameKeys) {
        if (payload.containsKey(key) && payload[key] is String) {
          final value = payload[key] as String;
          if (value.trim().isNotEmpty) {
            if (value.contains(' ')) {
              name = value;
              break;
            }
            if (name.isEmpty) {
              name = value;
            }
          }
        }
      }

      if (name.isEmpty) {
        name = payload['sub'] ?? 'User';
      }

      return name;
    } catch (_) {
      return 'User';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final token = authProvider.token;
    final fullName = token != null ? _getFullNameFromToken(token) : 'User';

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(Icons.menu, color: Colors.white),
          ),
          onPressed: _openDrawer,
        ),
        title: Row(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 2 * math.pi),
              duration: const Duration(seconds: 4),
              builder: (context, angle, child) {
                return Transform.rotate(
                  angle: angle * 0.05,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.train, color: Color(0xFF1E40AF), size: 22),
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
            const Text('IRCTC', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
          ],
        ),
        actions: const [],
      ),
      drawer: SidebarMenu(onClose: () => Navigator.pop(context)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Hero Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E40AF).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fullName,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Book your train tickets in seconds',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Quick Actions
              Row(
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 3,
                    color: const Color(0xFF1E40AF),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(_actions.length, (index) {
                    final item = _actions[index];
                    final delay = index * 0.1;
                    final animation = CurvedAnimation(
                      parent: _staggerController,
                      curve: Interval(delay, 1.0, curve: Curves.easeOutBack),
                    );
                    return ScaleTransition(
                      scale: animation,
                      child: _buildQuickActionCard(
                        icon: item['icon'],
                        title: item['title'],
                        subtitle: item['subtitle'],
                        isSoon: item['soon'],
                        onTap: () {
                          if (item['soon']) {
                            _showComingSoonSnackbar(item['title']);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TrainSearchScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              // Footer
              Center(
                child: Column(
                  children: [
                    Container(width: 60, height: 2, color: const Color(0xFF4B5563).withOpacity(0.4)),
                    const SizedBox(height: 12),
                    Text('© 2024 Indian Railways. All rights reserved.', style: TextStyle(color: const Color(0xFF4B5563).withOpacity(0.7), fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('Version 1.0.0', style: TextStyle(color: const Color(0xFF4B5563).withOpacity(0.5), fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSoon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, spreadRadius: 1, offset: const Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1E40AF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF1E40AF), size: 24),
            ),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111827), letterSpacing: 0.2), textAlign: TextAlign.center),
            const SizedBox(height: 1),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF4B5563)), textAlign: TextAlign.center),
            if (isSoon)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.4)),
                  ),
                  child: const Text('SOON', style: TextStyle(color: Color(0xFFD97706), fontSize: 7, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}