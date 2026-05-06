import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/config/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  // ignore: unused_field
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.checkAuthState();

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      if (authProvider.userRole == 'student') {
        Navigator.pushReplacementNamed(context, AppRoutes.studentDashboard);
      } else if (authProvider.userRole == 'parent') {
        Navigator.pushReplacementNamed(context, AppRoutes.parentDashboard);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Compute a bounce scale for a single dot based on the controller value
  /// and an offset (0.0, 0.33, 0.66 for each dot).
  double _dotScale(double controllerValue, double offset) {
    // Create a repeating wave; each dot peaks at a different phase
    final t = ((controllerValue * 2) - offset) % 1.0;
    // Simple sine-like bounce: scale between 0.4 and 1.0
    final sinValue = (t * 3.14159).clamp(0.0, 3.14159);
    return 0.4 + 0.6 * _sinApprox(sinValue);
  }

  /// Approximate sin(x) for x in [0, pi]
  double _sinApprox(double x) {
    // Parabolic approximation: 4x(pi-x) / pi^2
    const pi = 3.14159;
    return (4 * x * (pi - x)) / (pi * pi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.3, -1),
            end: Alignment(-0.3, 1),
            colors: [Color(0xFF2D1B4E), Color(0xFF1A0F30)],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Center radial glow
            Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x408B5FBF), Colors.transparent],
                  radius: 0.7,
                ),
              ),
            ),
            // Center content
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '\u0636\u064A\u0627\u0621',
                    style: GoogleFonts.tajawal(
                      color: Colors.white,
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Opacity(
                    opacity: 0.8,
                    child: Text(
                      '\u0631\u0641\u064A\u0642 \u0627\u0644\u062A\u0639\u0644\u0645 \u0627\u0644\u0630\u0643\u064A',
                      style: GoogleFonts.tajawal(
                        color: AppTheme.accent100,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 3 bouncing dots
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          final scale = _dotScale(
                            _controller.value,
                            index * 0.33,
                          );
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4),
                            child: Transform.scale(
                              scale: scale,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primary100,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
