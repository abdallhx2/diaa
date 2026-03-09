// ============================================================
// File: splash_screen.dart
// Purpose: شاشة البداية — عرض الشعار ثم التوجيه حسب حالة المصادقة
// Owner: حياة — Integration Developer
// Branch: feature/flutter-services
// Week: 2 — شاشات المصادقة والتنقل
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';

// TODO: replace with:
//   import 'package:edu_smart_assistant/config/routes.dart';
// AppRoutes is already defined in main.dart — import from there once routes.dart is created

// ============================================================
// Step 1: StatefulWidget
// ============================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  // Animation controller for the logo fade-in
  late final AnimationController _animController;
  late final Animation<double>    _fadeAnim;

  // ============================================================
  // Step 2: initState — start countdown + auth check
  // ============================================================
  @override
  void initState() {
    super.initState();

    // Logo fade-in animation over 1 second
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();

    // Wait 3 seconds then check auth state
    Future.delayed(const Duration(seconds: 3), () async {
      await _checkAuthAndNavigate();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ============================================================
  // Step 4: _checkAuthAndNavigate
  // ============================================================
  Future<void> _checkAuthAndNavigate() async {
    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.checkAuthState();

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      if (authProvider.userRole == 'student') {
        Navigator.pushReplacementNamed(context, '/student-dashboard');
      } else if (authProvider.userRole == 'parent') {
        Navigator.pushReplacementNamed(context, '/parent-dashboard');
      } else {
        // دور غير معروف — العودة لاختيار الدور
        Navigator.pushReplacementNamed(context, '/role-selection');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/role-selection');
    }
  }

  // ============================================================
  // Step 3: Build — Splash UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // خلفية زرقاء بتدرج
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end:   Alignment.bottomCenter,
              colors: [
                Color(0xFF3A7BD5), // أزرق داكن أعلى
                AppTheme.primaryBlue,
                Color(0xFF5BA3E8), // أزرق فاتح أسفل
              ],
            ),
          ),
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── الشعار ──────────────────────────────────
                  // خيار 1: Lottie animation (فعّل عند توفر الملف)
                  // Lottie.asset(
                  //   'assets/animations/splash.json',
                  //   width: 200,
                  //   height: 200,
                  // ),

                  // خيار 2: صورة (فعّل عند توفر الملف)
                  // Image.asset('assets/images/logo.png', width: 150),

                  // خيار 3: أيقونة مؤقتة (حتى تتوفر assets)
                  Container(
                    width:  130,
                    height: 130,
                    decoration: BoxDecoration(
                      color:       Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size:  72,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── اسم التطبيق ──────────────────────────────
                  const Text(
                    'المساعد التعليمي الذكي',
                    style: TextStyle(
                      fontSize:   28,
                      fontWeight: FontWeight.bold,
                      color:      Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── وصف مختصر ────────────────────────────────
                  Text(
                    'تعلّم بذكاء، تقدّم بثقة',
                    style: TextStyle(
                      fontSize: 16,
                      color:    Colors.white.withValues(alpha: 0.80),
                    ),
                  ),

                  const SizedBox(height: 64),

                  // ── مؤشر التحميل ─────────────────────────────
                  const SizedBox(
                    width:  32,
                    height: 32,
                    child: CircularProgressIndicator(
                      color:       Colors.white,
                      strokeWidth: 3,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'جاري التحميل...',
                    style: TextStyle(
                      fontSize: 14,
                      color:    Colors.white.withValues(alpha: 0.70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
