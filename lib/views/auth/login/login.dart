import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/auth/login/login_ctrl.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginCtrl>(
      init: LoginCtrl(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundWhite,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  _buildHeaderSection(context),
                  const SizedBox(height: 48),
                  _buildLoginForm(ctrl, context),
                  const SizedBox(height: 24),
                  _buildSignInButton(ctrl, context),
                  const SizedBox(height: 32),
                  _buildDivider(context),
                  const SizedBox(height: 32),
                  _buildFooter(context, ctrl),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.primaryLight, AppTheme.primaryBlue]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 28),
          Text(
            'Welcome Back Doctor',
            style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, height: 1.2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to access your medical dashboard',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: AppTheme.textSecondary, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(LoginCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildEmailField(ctrl, context), const SizedBox(height: 20), _buildPasswordField(ctrl, context), const SizedBox(height: 16), _buildForgotPassword()],
    );
  }

  Widget _buildEmailField(LoginCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl.emailCtrl,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'doctor@primehealth.com',
            hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
            prefixIcon: Icon(Icons.email_rounded, color: AppTheme.textSecondary, size: 22),
            filled: true,
            fillColor: AppTheme.backgroundWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(LoginCtrl ctrl, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return TextFormField(
            controller: ctrl.passwordCtrl,
            obscureText: !ctrl.isPasswordVisible.value,
            textInputAction: TextInputAction.done,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.w400),
              prefixIcon: Icon(Icons.lock_rounded, color: AppTheme.textSecondary, size: 22),
              suffixIcon: IconButton(
                onPressed: ctrl.togglePasswordVisibility,
                icon: Icon(ctrl.isPasswordVisible.value ? Icons.visibility_rounded : Icons.visibility_off_rounded, color: AppTheme.textSecondary, size: 22),
              ),
              filled: true,
              fillColor: AppTheme.backgroundWhite,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onFieldSubmitted: (_) => ctrl.login(),
          );
        }),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
        ),
      ),
    );
  }

  Widget _buildSignInButton(LoginCtrl ctrl, BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: ctrl.isLoading.value ? null : ctrl.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: ctrl.isLoading.value
              ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8))))
              : Text(
                  'Sign In',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
        ),
      );
    });
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppTheme.borderColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textLight),
          ),
        ),
        Expanded(child: Divider(color: AppTheme.borderColor, thickness: 1)),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, LoginCtrl ctrl) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: AppTheme.textSecondary),
            ),
            GestureDetector(
              onTap: ctrl.goToRegister,
              child: Text(
                'Create Account',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(Icons.security_rounded, color: AppTheme.primaryBlue, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your medical data is securely encrypted',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
