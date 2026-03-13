import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/screens/splash/splash_screen.dart';
import 'package:edu_smart_assistant/screens/auth/role_selection_screen.dart';
import 'package:edu_smart_assistant/screens/auth/student_login_screen.dart';
import 'package:edu_smart_assistant/screens/auth/parent_login_screen.dart';
import 'package:edu_smart_assistant/screens/auth/parent_register_screen.dart';
import 'package:edu_smart_assistant/screens/student/student_dashboard_screen.dart';
import 'package:edu_smart_assistant/screens/student/scan_page_screen.dart';
import 'package:edu_smart_assistant/screens/student/scan_qr_screen.dart';
import 'package:edu_smart_assistant/screens/student/upload_file_screen.dart';
import 'package:edu_smart_assistant/screens/student/text_display_screen.dart';
import 'package:edu_smart_assistant/screens/student/ai_chat_screen.dart';
import 'package:edu_smart_assistant/screens/quiz/quiz_selection_screen.dart';
import 'package:edu_smart_assistant/screens/quiz/reading_quiz_screen.dart';
import 'package:edu_smart_assistant/screens/quiz/writing_quiz_screen.dart';
import 'package:edu_smart_assistant/screens/quiz/comprehension_quiz_screen.dart';
import 'package:edu_smart_assistant/screens/quiz/quiz_result_screen.dart';
import 'package:edu_smart_assistant/screens/parent/parent_dashboard_screen.dart';
import 'package:edu_smart_assistant/screens/parent/add_child_screen.dart';
import 'package:edu_smart_assistant/screens/parent/reports_screen.dart';
 
class AppRoutes {
  static const String splash               = '/';
  static const String roleSelection        = '/role-selection';
  static const String studentLogin         = '/student-login';
  static const String parentLogin          = '/parent-login';
  static const String parentRegister       = '/parent-register';
  static const String studentDashboard     = '/student-dashboard';
  static const String scanPage             = '/scan-page';
  static const String scanQR               = '/scan-qr';
  static const String uploadFile           = '/upload-file';
  static const String textDisplay          = '/text-display';
  static const String aiChat               = '/ai-chat';
  static const String quizSelection        = '/quiz-selection';
  static const String readingQuiz          = '/reading-quiz';
  static const String writingQuiz          = '/writing-quiz';
  static const String comprehensionQuiz    = '/comprehension-quiz';
  static const String quizResult           = '/quiz-result';
  static const String parentDashboard      = '/parent-dashboard';
  static const String addChild             = '/add-child';
  static const String reports              = '/reports';
 
  static Map<String, WidgetBuilder> get routes => {
    splash:            (_) => const SplashScreen(),
    roleSelection:     (_) => const RoleSelectionScreen(),
    studentLogin:      (_) => const StudentLoginScreen(),
    parentLogin:       (_) => const ParentLoginScreen(),
    parentRegister:    (_) => const ParentRegisterScreen(),
    studentDashboard:  (_) => const StudentDashboardScreen(),
    scanPage:          (_) => const ScanPageScreen(),
    scanQR:            (_) => const ScanQrScreen(),
    uploadFile:        (_) => const UploadFileScreen(),
    textDisplay:       (_) => const TextDisplayScreen(),
    aiChat:            (_) => const AiChatScreen(),
    quizSelection:     (_) => const QuizSelectionScreen(),
    readingQuiz:       (_) => const ReadingQuizScreen(),
    writingQuiz:       (_) => const WritingQuizScreen(),
    comprehensionQuiz: (_) => const ComprehensionQuizScreen(),
    quizResult:        (_) => const QuizResultScreen(),
    parentDashboard:   (_) => const ParentDashboardScreen(),
    addChild:          (_) => const AddChildScreen(),
    reports:           (_) => const ReportsScreen(),
  };
 
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case textDisplay:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => const TextDisplayScreen(),
          settings: RouteSettings(arguments: args),
        );
      case aiChat:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => const AiChatScreen(),
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
 