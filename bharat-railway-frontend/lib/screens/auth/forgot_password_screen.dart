/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-07-12
 * Version: 1.1.2
 *
 * Description:
 * Updated background illustration alignment to match the unified design 
 * system used in Login and Registration screens. Images are now handled
 * via responsive Positioned wrappers with standard scaling for consistency.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../themes/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/auth_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String _selectedChannel = 'email';
  final List<String> _channels = ['email', 'sms'];
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.forgotPassword(
      _emailController.text.trim(),
      _selectedChannel,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Reset token sent. Please check your email and enter token below.'),
        backgroundColor: AppTheme.successColor,
      ));
      Navigator.pushReplacementNamed(context, AppRoutes.resetPassword);
    } else if (mounted && authProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authProvider.error!)));
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider = context.watch<AuthProvider>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
            onPressed: _navigateToLogin,
          ),
        ),
        body: Stack(
          children: [
            // Base Gradient
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
            
            // Background Illustration - Top
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
                  child: Opacity(opacity: 0.70, child: Image.asset('assets/images/upperimage2.png', fit: BoxFit.cover, alignment: Alignment.center)),
                ),
              ),
            ),
            
            // Background Illustration - Bottom
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
                  child: Opacity(opacity: 0.70, child: Image.asset('assets/images/lowerimage2.png', fit: BoxFit.cover, alignment: Alignment.center)),
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            spreadRadius: 5,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.lock_reset_rounded, size: 56, color: AppTheme.primaryColor),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Reset Password', 
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: Colors.black87),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Please enter your email to receive a secure password reset link.', 
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
                            ),
                            const SizedBox(height: 32),
                            AuthTextField(
                              controller: _emailController,
                              label: 'Email Address',
                              hint: 'example@domain.com',
                              prefixIcon: Icons.email_rounded,
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              value: _selectedChannel,
                              decoration: InputDecoration(
                                labelText: 'Reset Method',
                                prefixIcon: const Icon(Icons.send_rounded),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                              ),
                              items: _channels.map((c) => DropdownMenuItem(value: c, child: Text(c.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600)))).toList(),
                              onChanged: (v) => setState(() => _selectedChannel = v!),
                            ),
                            const SizedBox(height: 40),
                            AuthButton(
                              onPressed: _handleForgotPassword,
                              isLoading: authProvider.isLoading,
                              text: 'Send Reset Link',
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: _navigateToLogin, 
                              child: const Text('Back to Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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