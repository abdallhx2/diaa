// ============================================================
// File: main.dart
// Purpose: نقطة الدخول الرئيسية للتطبيق — تهيئة Firebase والـ Providers
// Owner: ديمة — Flutter Lead
// ============================================================

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/providers/student_provider.dart';
import 'package:edu_smart_assistant/providers/lesson_provider.dart';
import 'package:edu_smart_assistant/providers/quiz_provider.dart';
import 'package:edu_smart_assistant/providers/chat_provider.dart';
import 'package:edu_smart_assistant/providers/parent_provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';

// ── Inline stubs (remove once real files exist) ───────────────
// TODO: replace with:
//   import 'package:edu_smart_assistant/config/routes.dart';
//   import 'package:edu_smart_assistant/app.dart'; // for MyApp

class AppRoutes {
  static const String splash        = '/';
  static const String roleSelection = '/role-selection';
  static const String studentLogin  = '/student-login';
  static const String parentLogin   = '/parent-login';
  static const String studentDash   = '/student-dashboard';
  static const String parentDash    = '/parent-dashboard';
  static const String scanPage      = '/scan-page';
  static const String scanQR        = '/scan-qr';
  static const String uploadFile    = '/upload-file';
  static const String quizSelection = '/quiz-selection';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // TODO: replace with real route map once screens are created
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text('Route: ${settings.name}')),
      ),
    );
  }
}
// ── End stubs ─────────────────────────────────────────────────

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ParentProvider()),
      ],
      child: const _MyApp(),
    ),
  );
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('❌ فشل تهيئة Firebase: $e');
    debugPrint(
      'تأكد من وجود:\n'
      '  • google-services.json في android/app/\n'
      '  • GoogleService-Info.plist في ios/Runner/',
    );
    rethrow;
  }
}

// TODO: delete _MyApp and import real MyApp from app.dart once ready
class _MyApp extends StatelessWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduSmart Assistant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
