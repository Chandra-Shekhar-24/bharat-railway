/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-07-07
 * Version: 1.1.0
 *
 * Description:
 * Redesigned Reset Password Screen with responsive background graphics
 * and improved visual hierarchy, matching the Auth suite premium theme.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../themes/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/auth_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match'), backgroundColor: AppTheme.errorColor));
      return;
    }

    final auth = context.read<AuthProvider>();
    final ok = await auth.resetPassword(_otpController.text.trim(), _passwordController.text.trim());
    
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset successful!'), backgroundColor: AppTheme.successColor));
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.error ?? 'Reset failed'), backgroundColor: AppTheme.errorColor));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black87)),
        body: Stack(
          children: [
            // Base Gradient Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF37B21), Colors.white, Color(0xFF007A33)],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
            
            // Background Saffron Graphic - Optimized for responsiveness
            Positioned(
              top: -15, left: 0, right: 0, height: size.height * 0.50,
              child: ShaderMask(
                shaderCallback: (rect) => const LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent], stops: [0.65, 1.0],
                ).createShader(rect),
                blendMode: BlendMode.dstIn,
                child: Transform.scale(
                  scale: 1.8,
                  child: Opacity(opacity: 0.70, child: Image.asset('assets/images/upperimage2.png', fit: BoxFit.cover)),
                ),
              ),
            ),
            
            // Background Green Graphic - Optimized for responsiveness
            Positioned(
              bottom: 0, left: 0, right: 0, height: size.height * 0.50,
              child: ShaderMask(
                shaderCallback: (rect) => const LinearGradient(
                  begin: Alignment.bottomCenter, end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent], stops: [0.65, 1.0],
                ).createShader(rect),
                blendMode: BlendMode.dstIn,
                child: Transform.scale(
                  scale: 1.3,
                  child: Opacity(opacity: 0.70, child: Image.asset('assets/images/lowerimage2.png', fit: BoxFit.cover)),
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 30, spreadRadius: 5, offset: const Offset(0, 15))],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.08), shape: BoxShape.circle),
                              child: const Icon(Icons.key_rounded, size: 56, color: AppTheme.primaryColor),
                            ),
                            const SizedBox(height: 24),
                            const Text('Set New Password', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.black87)),
                            const SizedBox(height: 32),
                            AuthTextField(
                              controller: _otpController,
                              label: '6-Digit OTP',
                              hint: 'Enter code sent to email',
                              prefixIcon: Icons.pin_rounded,
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              controller: _passwordController,
                              label: 'New Password',
                              hint: 'Min 8 characters',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: true,
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              controller: _confirmController,
                              label: 'Confirm Password',
                              hint: 'Repeat new password',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: true,
                            ),
                            const SizedBox(height: 40),
                            AuthButton(
                              onPressed: _handleReset,
                              isLoading: context.watch<AuthProvider>().isLoading,
                              text: 'Update Password',
                            ),
                          ],
                        ),
                      ),
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
}