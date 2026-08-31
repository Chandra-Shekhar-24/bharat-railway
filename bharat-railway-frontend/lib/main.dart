/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Assisted by:
 * Date: 2026-07-06
 * Version: 2.0.0
 *
 * Description:
 * Entry point of the Bharat Railway Booking System Flutter app.
 * Configures MultiProvider for state management.
 * Sets up MaterialApp with theme and routing.
 * Includes navigator key for global navigation.
 *
 * Version History:
 * version 2.0.0: Integrated AuthProvider, AppTheme, and AppRoutes.
 *                Added navigator key for DioClient.
 * version 1.0.0: Initial file creation with basic app structure.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'themes/app_theme.dart';
import 'routes/app_routes.dart';
import 'services/api/dio_client.dart';

void main() {
  runApp(const BharatRailwayApp());
}

class BharatRailwayApp extends StatelessWidget {
  const BharatRailwayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Bharat Railway Booking System',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}



