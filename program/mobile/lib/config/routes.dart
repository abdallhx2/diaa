import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/screens/splash/splash_screen.dart';
import 'package:edu_smart_assistant/screens/student/student_dashboard_screen.dart';
import 'package:edu_smart_assistant/screens/student/scan_page_screen.dart';
import 'package:edu_smart_assistant/screens/student/scan_qr_screen.dart';
import 'package:edu_smart_assistant/screens/student/upload_file_screen.dart';
import 'package:edu_smart_assistant/screens/student/text_display_screen.dart';
import 'package:edu_smart_assistant/screens/student/ai_chat_screen.dart';

class AppRoutes {
  static const String splash            = '/';
  static const String roleSelection     = '/role-selection';
  static const String studentLogin      = '/student-login';
  static const String parentLogin       = '/parent-login';
  static const String parentRegister    = '/parent-register';
  static const String studentDashboard  = '/student-dashboard';
  static const String scanPage          = '/scan-page';
  static const String scanQR            = '/scan-qr';
  static const String uploadFile        = '/upload-file';
  static const String textDisplay       = '/text-display';
  static const String aiChat            = '/ai-chat';
  static const String quizSelection     = '/quiz-selection';
  static const String readingQuiz       = '/reading-quiz';
  static const String writingQuiz       = '/writing-quiz';
  static const String comprehensionQuiz = '/comprehension-quiz';
  static const String quizResult        = '/quiz-result';
  static const String parentDashboard   = '/parent-dashboard';
  static const String addChild          = '/add-child';
  static const String reports           = '/reports';

  static Map<String, WidgetBuilder> get routes => {
    splash:           (_) => const SplashScreen(),
    roleSelection:    (_) => const Scaffold(body: Center(child: Text('قريباً'))),
    studentLogin:     (_) => const Scaffold(body: Center(child: Text('قريباً'))),
    parentLogin:      (_) => const Scaffold(body: Center(child: Text('قريباً'))),
    parentRegister:   (_) => const Scaffold(body: Center(child: Text('قريباً'))),
    studentDashboard: (_) => const StudentDashboardScreen(),
    scanPage:         (_) => const ScanPageScreen(),
    scanQR:           (_) => const ScanQrScreen(),
    uploadFile:       (_) => const UploadFileScreen(),
    textDisplay:      (_) => const TextDisplayScreen(),
    aiChat:           (_) => const AiChatScreen(),
    quizSelection:    (_) => const Scaffold(body: Center(child: Text('قريباً'))),
    readingQuiz:      (_) => const Scaffold(body: Center(child: Text('قريباً'))),
    writingQuiz:      (_) => const Scaffold(body: Center(child: Text('قريباً'))),
    comprehensionQuiz:(_) => const Scaffold(body: Center(child: Text('قريباً'))),
    quizResult:       (_) => const Scaffold(body: Center(child: Text('قريباً'))),
    parentDashboard:  (_) => const Scaffold(body: Center(child: Text('قريباً'))),
    addChild:         (_) => const Scaffold(body: Center(child: Text('قريباً'))),
    reports:          (_) => const Scaffold(body: Center(child: Text('قريباً'))),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case textDisplay:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:  (_) => const TextDisplayScreen(),
          settings: RouteSettings(arguments: args),
        );
      case aiChat:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:  (_) => const AiChatScreen(),
          settings: RouteSettings(arguments: args),
        );
      default:
        final builder = routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder);
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('الصفحة غير موجودة')),
          ),
        );
    }
  }
}
