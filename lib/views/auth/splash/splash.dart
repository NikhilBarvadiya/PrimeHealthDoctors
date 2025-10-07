import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prime_health_doctors/utils/theme/light.dart';
import 'package:prime_health_doctors/views/auth/splash/splash_ctrl.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation, _scaleAnimation, _slideAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _colorAnimation = ColorTween(begin: AppTheme.primaryBlue.withOpacity(0.8), end: AppTheme.primaryBlue).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashCtrl>(
      init: SplashCtrl(),
      builder: (context) {
        return Scaffold(
          body: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_colorAnimation.value ?? AppTheme.primaryBlue, AppTheme.primaryDark]),
                ),
                child: Stack(
                  children: [
                    _buildBackgroundPattern(),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [_buildAppIcon(), const SizedBox(height: 32), _buildAppName(), const SizedBox(height: 12), _buildTagline(), const SizedBox(height: 60), _buildLoadingIndicator()],
                      ),
                    ),
                    _buildBottomBranding(),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: Opacity(opacity: 0.1, child: CustomPaint(painter: _MedicalPatternPainter())),
    );
  }

  Widget _buildAppIcon() {
    return Opacity(
      opacity: _fadeAnimation.value,
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 40, offset: const Offset(0, 20))],
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white, Color(0xFFF0F9FF)]),
          ),
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.primaryLight, AppTheme.primaryBlue]),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Center(
                child: Icon(
                  Icons.medical_services_rounded,
                  size: 48,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppName() {
    return Opacity(
      opacity: _fadeAnimation.value,
      child: Transform.translate(
        offset: Offset(0, _slideAnimation.value),
        child: Column(
          children: [
            Text(
              'PrimeHealth',
              style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.5, height: 1.1),
            ),
            const SizedBox(height: 4),
            Text(
              'DOCTORS',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.9), letterSpacing: 3.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return Opacity(
      opacity: _fadeAnimation.value * 0.9,
      child: Transform.translate(
        offset: Offset(0, _slideAnimation.value),
        child: Text(
          'Professional Healthcare Management Platform',
          style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withOpacity(0.8), letterSpacing: 0.3, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Opacity(
      opacity: _fadeAnimation.value,
      child: Column(
        children: [
          SizedBox(width: 32, height: 32, child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)))),
          const SizedBox(height: 16),
          Text(
            'Loading...',
            style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBranding() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Opacity(
        opacity: _fadeAnimation.value * 0.8,
        child: Column(
          children: [
            Text(
              'Trusted Medical Professionals',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(width: 40, height: 2, color: Colors.white.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }
}

class _MedicalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const crossSize = 40.0;
    final rows = (size.height / crossSize).ceil();
    final columns = (size.width / crossSize).ceil();
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        final x = j * crossSize;
        final y = i * crossSize;
        canvas.drawLine(Offset(x + crossSize / 2, y + crossSize / 4), Offset(x + crossSize / 2, y + 3 * crossSize / 4), paint);
        canvas.drawLine(Offset(x + crossSize / 4, y + crossSize / 2), Offset(x + 3 * crossSize / 4, y + crossSize / 2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
