/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Assisted by:
 * Date: 2026-07-07
 * Version: 1.0.0
 *
 * Description:
 * Registration screen for the Bharat Railway Booking System.
 * Allows new users to create an account with all required fields.
 * Uses AuthProvider for state management.
 * Navigates to login screen on successful registration.
 * [Update]: Applied professional UI/UX fixes. Compacted form fields by
 * removing redundant external labels and relying on clean inline hints.
 * Standardized font sizes to 14-16sp for a premium, non-bulky layout.
 * Optimized glassmorphism card height and footer alignments.
 * Mobile number now prefixed with +91 for E.164 compliance.
 */

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../models/requests/registration_request.dart';
import '../../themes/app_theme.dart';
import '../../routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  String _selectedGender = 'M';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  final List<String> _genders = ['M', 'F', 'O'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(1900);
    final lastDate = now;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 18)),
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF37B21),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      _dateOfBirthController.text =
          '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms and Conditions to proceed.'),
          backgroundColor: Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final request = RegistrationRequest(
      fullName: _fullNameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      mobileNumber: '+91' + _mobileController.text.trim(),
      password: _passwordController.text.trim(),
      dateOfBirth: _dateOfBirthController.text.trim(),
      gender: _selectedGender,
    );

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(request);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Please login.'),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else if (mounted && authProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error!),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  // Premium, Compact Text Field Helper
  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? prefixWidget,
  }) {
    const inputTextStyle = TextStyle(fontSize: 22, color: Colors.black87);
    const hintTextStyle = TextStyle(color: Colors.grey, fontSize: 18);
    const iconColor = Colors.lightBlue;
    const focusedBorderColor = Color(0xFFC78B64);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      style: inputTextStyle,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: hintTextStyle,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: prefixWidget ??
            (prefixIcon != null ? Icon(prefixIcon, color: iconColor, size: 30) : null),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: focusedBorderColor, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
        errorStyle: const TextStyle(height: 0.8, fontSize: 11),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final size = MediaQuery.of(context).size;

    const iconColor = Colors.grey;
    const focusedBorderColor = Color(0xFFC78B64);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(0, 199, 16, 16),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 22),
            onPressed: _navigateToLogin,
          ),
        ),
        body: Stack(
          children: [
            // ==========================================
            // BACKGROUND LAYERS
            // ==========================================
            // Base Seamless Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF37B21),
                    Color(0xFFF37B21),
                    Colors.white,
                    Colors.white,
                    Color(0xFF007A33),
                    Color(0xFF007A33),
                  ],
                  stops: [0.0, 0.25, 0.45, 0.65, 0.85, 1.0],
                ),
              ),
            ),

            // Top Saffron Graphic
            Positioned(
              top: -15,
              left: 0,
              right: 0,
              height: size.height * 0.50,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                    stops: [0.65, 1.0],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstIn,
                child: Transform.scale(
                  scale: 1.8,
                  child: Opacity(
                    opacity: 0.70,
                    child: Image.asset(
                      'assets/images/upperimageRegister.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Green Graphic
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: size.height * 0.50,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black, Colors.transparent],
                    stops: [0.65, 1.0],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstIn,
                child: Transform.scale(
                  scale: 1.3,
                  child: Opacity(
                    opacity: 0.70,
                    child: Image.asset(
                      'assets/images/lowerimageRegister.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ),

            // ==========================================
            // FOREGROUND CONTENT LAYER
            // ==========================================
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: size.height * 0.04,
                    left: 24,
                    right: 24,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Title
                      const Text(
                        'IRCTC New User Registration',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Main Form Card
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(243, 15, 15, 15).withOpacity(0.8),
                              blurRadius: 15,
                              spreadRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Full Name
                              _buildStyledTextField(
                                controller: _fullNameController,
                                hint: 'Full Name',
                                prefixIcon: Icons.person_outline,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Please enter your full name';
                                  if (value.length < 2) return 'Name must be at least 2 characters';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),

                              // Username
                              _buildStyledTextField(
                                controller: _usernameController,
                                hint: 'Username (e.g., unique_name)',
                                prefixIcon: Icons.account_circle_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Please enter a username';
                                  if (value.length < 4) return 'Username must be 4+ characters';
                                  if (!RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(value)) {
                                    return 'Only letters, numbers, . _ - allowed';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),

                              // Email Address
                              _buildStyledTextField(
                                controller: _emailController,
                                hint: 'Email Address',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Please enter your email';
                                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                      .hasMatch(value)) return 'Enter a valid email';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),

                              // Mobile Number
                              _buildStyledTextField(
                                controller: _mobileController,
                                hint: 'Mobile Number',
                                keyboardType: TextInputType.phone,
                                prefixWidget: Padding(
                                  padding: const EdgeInsets.only(left: 14, right: 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('+91',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87)),
                                      const SizedBox(width: 8),
                                      Container(width: 1, height: 18, color: Colors.grey.shade400),
                                    ],
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your mobile number';
                                  }
                                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                    return 'Enter a valid 10-digit number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),

                              // Passwords Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _buildStyledTextField(
                                      controller: _passwordController,
                                      hint: 'Password',
                                      prefixIcon: Icons.lock_outline,
                                      obscureText: _obscurePassword,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            size: 30,
                                            color: iconColor),
                                        onPressed: () =>
                                            setState(() => _obscurePassword = !_obscurePassword),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) return 'Enter password';
                                        if (value.length < 8) return 'Too short (Min 8)';
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildStyledTextField(
                                      controller: _confirmPasswordController,
                                      hint: 'Confirm',
                                      prefixIcon: Icons.lock_outline,
                                      obscureText: _obscureConfirmPassword,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            _obscureConfirmPassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            size: 30,
                                            color: iconColor),
                                        onPressed: () => setState(() =>
                                            _obscureConfirmPassword = !_obscureConfirmPassword),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) return 'Confirm password';
                                        if (value != _passwordController.text) return 'Mismatch';
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // DOB and Gender Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _buildStyledTextField(
                                      controller: _dateOfBirthController,
                                      hint: 'DOB',
                                      prefixIcon: Icons.calendar_month_outlined,
                                      readOnly: true,
                                      onTap: _selectDate,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) return 'Select DOB';
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Gender Dropdown
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedGender,
                                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color.fromARGB(255, 15, 167, 144)),
                                      decoration: InputDecoration(
                                        hintText: 'Gender',
                                        prefixIcon: const Icon(Icons.people_outline, color: iconColor, size: 20),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                       fillColor: Colors.white.withOpacity(0.7),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: focusedBorderColor, width: 1.5),
                                        ),
                                      ),
                                      style: const TextStyle(fontSize: 15, color: Colors.black87),
                                      items: _genders.map((gender) {
                                        return DropdownMenuItem(
                                          value: gender,
                                          child: Text(gender == 'M' ? 'Male' : gender == 'F' ? 'Female' : 'Other'),
                                        );
                                      }).toList(),
                                      onChanged: (value) => setState(() => _selectedGender = value!),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Terms & Conditions Checkbox
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                      value: _agreedToTerms,
                                      onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                                      activeColor: const Color(0xFF007A33),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      side: BorderSide(color: Colors.grey.shade600, width: 1.2),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        text: 'I agree to the IRCTC ',
                                        style: TextStyle(fontSize: 14, color: Colors.black87),
                                        children: [
                                          TextSpan(
                                            text: 'Terms and Conditions',
                                            style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Metallic Create Account Button
                              Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFCD9171),
                                      Color(0xFFA6643F),
                                      Color(0xFF8B5133),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: const Color.fromARGB(0, 198, 10, 10),
                                  child: InkWell(
                                    onTap: _handleRegister,
                                    borderRadius: BorderRadius.circular(6),
                                    child: Center(
                                      child: authProvider.isLoading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                          : const Text(
                                              "CREATE ACCOUNT",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Gap before footer
                      const SizedBox(height: 36),

                      // Footer - Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 210, 13, 13),
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(offset: Offset(0, 1), blurRadius: 5.0, color: Color.fromARGB(137, 6, 9, 165)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _navigateToLogin,
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Color(0xFFFFA559),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                shadows: [
                                  Shadow(offset: Offset(0, 1), blurRadius: 5.0, color: Colors.black54),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Social Icons Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.facebook, color: const Color.fromARGB(255, 13, 37, 194), size: 30),
                          const SizedBox(width: 20),
                          Icon(Icons.flutter_dash, color: Color.fromARGB(255, 13, 37, 194), size: 30),
                          const SizedBox(width: 20),
                          Icon(Icons.camera_alt_outlined, color: const Color.fromARGB(255, 13, 37, 194), size: 30),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Footer - Copyright
                      Text(
                        '© 2026 Indian Railways. All rights reserved.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          shadows: const [
                            Shadow(offset: Offset(0, 1), blurRadius: 2.0, color: Color.fromARGB(255, 0, 0, 0)),
                          ],
                        ),
                      ),
                    ],
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