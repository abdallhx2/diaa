// ============================================================
// File: routes.dart
// Purpose: تعريف مسارات التنقل — جميع شاشات التطبيق
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:edu_smart_assistant/screens/splash/splash_screen.dart';
// import 'package:edu_smart_assistant/screens/auth/role_selection_screen.dart';
// import 'package:edu_smart_assistant/screens/auth/student_login_screen.dart';
// import 'package:edu_smart_assistant/screens/auth/parent_login_screen.dart';
// import 'package:edu_smart_assistant/screens/auth/parent_register_screen.dart';
// import 'package:edu_smart_assistant/screens/student/student_dashboard_screen.dart';
// import 'package:edu_smart_assistant/screens/student/scan_page_screen.dart';
// import 'package:edu_smart_assistant/screens/student/scan_qr_screen.dart';
// import 'package:edu_smart_assistant/screens/student/upload_file_screen.dart';
// import 'package:edu_smart_assistant/screens/student/text_display_screen.dart';
// import 'package:edu_smart_assistant/screens/student/ai_chat_screen.dart';
// import 'package:edu_smart_assistant/screens/quiz/quiz_selection_screen.dart';
// import 'package:edu_smart_assistant/screens/quiz/reading_quiz_screen.dart';
// import 'package:edu_smart_assistant/screens/quiz/writing_quiz_screen.dart';
// import 'package:edu_smart_assistant/screens/quiz/comprehension_quiz_screen.dart';
// import 'package:edu_smart_assistant/screens/quiz/quiz_result_screen.dart';
// import 'package:edu_smart_assistant/screens/parent/parent_dashboard_screen.dart';
// import 'package:edu_smart_assistant/screens/parent/add_child_screen.dart';
// import 'package:edu_smart_assistant/screens/parent/reports_screen.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class AppRoutes مع أسماء المسارات كـ static const
//         - class AppRoutes {
//             static const String splash = '/splash';
//             static const String roleSelection = '/role-selection';
//             static const String studentLogin = '/student-login';
//             static const String parentLogin = '/parent-login';
//             static const String parentRegister = '/parent-register';
//             static const String studentDashboard = '/student-dashboard';
//             static const String scanPage = '/scan-page';
//             static const String scanQR = '/scan-qr';
//             static const String uploadFile = '/upload-file';
//             static const String textDisplay = '/text-display';
//             static const String aiChat = '/ai-chat';
//             static const String quizSelection = '/quiz-selection';
//             static const String readingQuiz = '/reading-quiz';
//             static const String writingQuiz = '/writing-quiz';
//             static const String comprehensionQuiz = '/comprehension-quiz';
//             static const String quizResult = '/quiz-result';
//             static const String parentDashboard = '/parent-dashboard';
//             static const String addChild = '/add-child';
//             static const String reports = '/reports';
//           }

// Step 2: إنشاء Map للمسارات (routes)
//         - static Map<String, WidgetBuilder> get routes => {
//             splash: (_) => const SplashScreen(),
//             roleSelection: (_) => const RoleSelectionScreen(),
//             studentLogin: (_) => const StudentLoginScreen(),
//             parentLogin: (_) => const ParentLoginScreen(),
//             parentRegister: (_) => const ParentRegisterScreen(),
//             studentDashboard: (_) => const StudentDashboardScreen(),
//             scanPage: (_) => const ScanPageScreen(),
//             scanQR: (_) => const ScanQRScreen(),
//             uploadFile: (_) => const UploadFileScreen(),
//             textDisplay: (_) => const TextDisplayScreen(),
//             aiChat: (_) => const AiChatScreen(),
//             quizSelection: (_) => const QuizSelectionScreen(),
//             readingQuiz: (_) => const ReadingQuizScreen(),
//             writingQuiz: (_) => const WritingQuizScreen(),
//             comprehensionQuiz: (_) => const ComprehensionQuizScreen(),
//             quizResult: (_) => const QuizResultScreen(),
//             parentDashboard: (_) => const ParentDashboardScreen(),
//             addChild: (_) => const AddChildScreen(),
//             reports: (_) => const ReportsScreen(),
//           };

// Step 3: (اختياري) إنشاء onGenerateRoute للشاشات التي تحتاج arguments
//         - static Route<dynamic> generateRoute(RouteSettings settings) {
//             switch (settings.name) {
//               case textDisplay:
//                 final args = settings.arguments as Map<String, dynamic>;
//                 return MaterialPageRoute(builder: (_) => TextDisplayScreen(args: args));
//               case aiChat:
//                 final args = settings.arguments as Map<String, dynamic>;
//                 return MaterialPageRoute(builder: (_) => AiChatScreen(args: args));
//               default:
//                 return MaterialPageRoute(builder: routes[settings.name]!);
//             }
//           }

// --- Notes ---
// - بعض الشاشات تحتاج arguments (مثل textDisplay تحتاج النص المستخرج)
// - يمكن استخدام onGenerateRoute بدل routes Map للتحكم الأفضل
// - جميع أسماء المسارات تبدأ بـ / (slash)
// - يمكن إضافة transition animations في generateRoute
