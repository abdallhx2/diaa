import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';

class SplashScreen extends StatefulWidget {
const SplashScreen({super.key});

@override
State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
void initState() {
super.initState();
Future.delayed(const Duration(seconds: 3), () async {
await _checkAuthAndNavigate();
});
}

Future<void> _checkAuthAndNavigate() async {
final authProvider = context.read<AuthProvider>();
await authProvider.checkAuthState();

if (authProvider.isAuthenticated) {
if (authProvider.userRole == 'student') {
Navigator.pushReplacementNamed(context, AppRoutes.studentDashboard);
} else if (authProvider.userRole == 'parent') {
Navigator.pushReplacementNamed(context, AppRoutes.parentDashboard);
}
} else {
Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFF4A1A7A), // بنفسجي غامق
body: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
// شعار الكتاب
Image.asset(
'assets/images/logo.png',
width: 120,
color: Colors.white,
errorBuilder: (context, error, stackTrace) {
return const Icon(
Icons.menu_book,
size: 100,
color: Colors.white,
);
},
),

const SizedBox(height: 16),

// اسم التطبيق
const Text(
'ضياء',
style: TextStyle(
fontSize: 36,
fontWeight: FontWeight.bold,
color: Colors.white,
),
),

const SizedBox(height: 8),

// الوصف
const Text(
'رفيق التعلم الذكي',
style: TextStyle(
fontSize: 16,
color: Colors.white70,
),
),

const SizedBox(height: 48),

// دائرة التحميل
const CircularProgressIndicator(color: Colors.white),
],
),
),
);
}
}