/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Premium sidebar/drawer with user profile header, organized menu items.
 * Displays logged‑in user's full name and email (if available).
 * Updated Book Ticket navigation to TrainSearchScreen.
 *
 * Version History:
 * version 1.0.0: Initial file creation. Complete redesign: added profile
 *                header, user avatar with initials, email display,
 *                section dividers, improved typography and spacing.
 *                Enhanced JWT parsing to prioritize names with spaces.
 *                Updated Book Ticket to navigate to TrainSearchScreen.
 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../themes/app_theme.dart';
import '../routes/app_routes.dart';
import '../screens/search/train_search_screen.dart';

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

      // 🔍 Print decoded payload to console
      print(payload);

      // Extended list – put your key as the first one
      final nameKeys = [
        'fullName',    // <-- change this to your actual key
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
            if (name.isEmpty) name = value;
          }
        }
      }

      if (name.isEmpty) name = payload['sub'] ?? 'User';

      final email = payload['email'] ?? payload['Email'] ?? payload['mail'] ?? '';

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
      width: 280,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Text(
                          initials.isNotEmpty ? initials : 'U',
                          style: const TextStyle(
                            fontSize: 18,
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
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (email.isNotEmpty)
                              Text(
                                email,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                ),
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
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildSectionTitle('MAIN'),
                  _buildMenuItem(
                    icon: Icons.home_outlined,
                    title: 'Home',
                    onTap: () {
                      onClose();
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.confirmation_number_outlined,
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
                      _showComingSoon(context);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.schedule_outlined,
                    title: 'Train Schedule',
                    onTap: () {
                      onClose();
                      _showComingSoon(context);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.history_outlined,
                    title: 'Booking History',
                    onTap: () {
                      onClose();
                      _showComingSoon(context);
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
            // Version footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'v1.0.0',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
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

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('This feature is coming soon!'),
        backgroundColor: Colors.grey[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}