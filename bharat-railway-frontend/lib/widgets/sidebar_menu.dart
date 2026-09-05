/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 2.0.0
 *
 * Description:
 * Production-ready sidebar menu with profile header and all navigation.
 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';
import '../screens/search/train_search_screen.dart';
import '../screens/booking/pnr_status_screen.dart';
import '../screens/booking/booking_history_screen.dart';
import '../screens/profile/profile_screen.dart';

class SidebarMenu extends StatelessWidget {
  final VoidCallback onClose;

  const SidebarMenu({
    super.key,
    required this.onClose,
  });

  Map<String, String> _getUserDetails(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return {'name': 'User', 'email': ''};
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final name = payload['fullName'] ??
                     payload['full_name'] ??
                     payload['name'] ??
                     payload['preferred_username'] ??
                     payload['username'] ??
                     'User';
      final email = payload['email'] ?? '';
      return {'name': name, 'email': email};
    } catch (_) {
      return {'name': 'User', 'email': ''};
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final token = authProvider.token;
    final userData = token != null ? _getUserDetails(token) : {'name': 'User', 'email': ''};
    final fullName = userData['name']!;
    final email = userData['email']!;
    final initials = fullName
        .split(' ')
        .where((s) => s.isNotEmpty)
        .map((s) => s[0].toUpperCase())
        .take(2)
        .join();

    return Drawer(
      width: 290,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Text(
                        initials.isNotEmpty ? initials : 'U',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E40AF),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (email.isNotEmpty)
                            Text(
                              email,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: onClose,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  icon: Icons.home_outlined,
                  title: 'Home',
                  onTap: () {
                    onClose();
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.train_outlined,
                  title: 'Book Ticket',
                  onTap: () {
                    onClose();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TrainSearchScreen(),
                      ),
                    );
                  },
                  isActive: true,
                ),
                const Divider(height: 24, thickness: 1, indent: 16, endIndent: 16),
                _buildSectionTitle('SERVICES'),
                _buildMenuItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'PNR Status',
                  onTap: () {
                    onClose();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PnrStatusScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.history_outlined,
                  title: 'Booking History',
                  onTap: () {
                    onClose();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookingHistoryScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'My Profile',
                  onTap: () {
                    onClose();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 24, thickness: 1, indent: 16, endIndent: 16),
                _buildMenuItem(
                  icon: Icons.logout_outlined,
                  title: 'Logout',
                  color: Colors.red,
                  onTap: () async {
                    onClose();
                    final authProvider = context.read<AuthProvider>();
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    }
                  },
                ),
              ],
            ),
          ),
          // Version
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'v2.0.0',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Production',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey[500],
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isActive = false,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? const Color(0xFF1E40AF) : (color ?? Colors.grey[600]),
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          color: isActive ? const Color(0xFF1E40AF) : (color ?? Colors.grey[800]),
        ),
      ),
      trailing: isActive
          ? Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF1E40AF),
                borderRadius: BorderRadius.circular(2),
              ),
            )
          : null,
      onTap: onTap,
      tileColor: isActive ? const Color(0xFF1E40AF).withOpacity(0.05) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}