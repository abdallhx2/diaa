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
import 'package:edu_smart_assistant/screens/student/subject_selection_screen.dart';
import 'package:edu_smart_assistant/screens/student/lesson_list_screen.dart';
import 'package:edu_smart_assistant/screens/student/lesson_detail_screen.dart';
import 'package:edu_smart_assistant/screens/quiz/practice_selection_screen.dart';
import 'package:edu_smart_assistant/screens/parent/parent_progress_screen.dart';
import 'package:edu_smart_assistant/screens/parent/parent_results_screen.dart';
import 'package:edu_smart_assistant/screens/parent/completed_lessons_screen.dart';
import 'package:edu_smart_assistant/screens/parent/my_children_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String roleSelection = '/role-selection';
  static const String studentLogin = '/student-login';
  static const String parentLogin = '/parent-login';
  static const String parentRegister = '/parent-register';
  static const String studentDashboard = '/student-dashboard';
  static const String scanPage = '/scan-page';
  static const String scanQR = '/scan-qr';
  static const String uploadFile = '/upload-file';
  static const String textDisplay = '/text-display';
  static const String aiChat = '/ai-chat';
  static const String quizSelection = '/quiz-selection';
  static const String readingQuiz = '/reading-quiz';
  static const String writingQuiz = '/writing-quiz';
  static const String comprehensionQuiz = '/comprehension-quiz';
  static const String quizResult = '/quiz-result';
  static const String parentDashboard = '/parent-dashboard';
  static const String addChild = '/add-child';
  static const String reports = '/reports';
  static const String subjects = '/subjects';
  static const String lessonList = '/lesson-list';
  static const String lessonDetail = '/lesson-detail';
  static const String practiceSelect = '/practice-select';
  static const String parentProgress = '/parent-progress';
  static const String parentResults = '/parent-results';
  static const String completedLessons = '/completed-lessons';
  static const String myChildren = '/my-children';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(settings: settings, builder: (_) => const SplashScreen());
      case roleSelection:
        return MaterialPageRoute(settings: settings, builder: (_) => const RoleSelectionScreen());
      case studentLogin:
        return MaterialPageRoute(settings: settings, builder: (_) => const StudentLoginScreen());
      case parentLogin:
        return MaterialPageRoute(settings: settings, builder: (_) => const ParentLoginScreen());
      case parentRegister:
        return MaterialPageRoute(settings: settings, builder: (_) => const ParentRegisterScreen());
      case studentDashboard:
        return MaterialPageRoute(settings: settings,
            builder: (_) => const StudentDashboardScreen());
      case scanPage:
        return MaterialPageRoute(settings: settings, builder: (_) => const ScanPageScreen());
      case scanQR:
        return MaterialPageRoute(settings: settings, builder: (_) => const ScanQRScreen());
      case uploadFile:
        return MaterialPageRoute(settings: settings, builder: (_) => const UploadFileScreen());
      case textDisplay:
        return MaterialPageRoute(settings: settings, builder: (_) => const TextDisplayScreen());
      case aiChat:
        return MaterialPageRoute(settings: settings, builder: (_) => const AiChatScreen());
      case quizSelection:
        return MaterialPageRoute(settings: settings, builder: (_) => const QuizSelectionScreen());
      case readingQuiz:
        return MaterialPageRoute(settings: settings, builder: (_) => const ReadingQuizScreen());
      case writingQuiz:
        return MaterialPageRoute(settings: settings, builder: (_) => const WritingQuizScreen());
      case comprehensionQuiz:
        return MaterialPageRoute(settings: settings,
            builder: (_) => const ComprehensionQuizScreen());
      case quizResult:
        return MaterialPageRoute(settings: settings, builder: (_) => const QuizResultScreen());
      case parentDashboard:
        return MaterialPageRoute(settings: settings,
            builder: (_) => const ParentDashboardScreen());
      case addChild:
        return MaterialPageRoute(settings: settings, builder: (_) => const AddChildScreen());
      case reports:
        return MaterialPageRoute(settings: settings, builder: (_) => const ReportsScreen());
      case subjects:
        return MaterialPageRoute(settings: settings, builder: (_) => const SubjectSelectionScreen());
      case lessonList:
        return MaterialPageRoute(settings: settings, builder: (_) => const LessonListScreen(subjectName: '', subjectGrade: ''));
      case lessonDetail:
        return MaterialPageRoute(settings: settings, builder: (_) => const LessonDetailScreen(lessonName: ''));
      case practiceSelect:
        return MaterialPageRoute(settings: settings, builder: (_) => const PracticeSelectionScreen());
      case parentProgress:
        return MaterialPageRoute(settings: settings, builder: (_) => const ParentProgressScreen());
      case parentResults:
        return MaterialPageRoute(settings: settings, builder: (_) => const ParentResultsScreen());
      case completedLessons:
        return MaterialPageRoute(settings: settings, builder: (_) => const CompletedLessonsScreen());
      case myChildren:
        return MaterialPageRoute(settings: settings, builder: (_) => const MyChildrenScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('الصفحة غير موجودة: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
