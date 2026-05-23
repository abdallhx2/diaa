import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/app.dart';
import 'package:edu_smart_assistant/firebase_options.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/providers/student_provider.dart';
import 'package:edu_smart_assistant/providers/lesson_provider.dart';
import 'package:edu_smart_assistant/providers/quiz_provider.dart';
import 'package:edu_smart_assistant/providers/chat_provider.dart';
import 'package:edu_smart_assistant/providers/parent_provider.dart';
import 'package:edu_smart_assistant/providers/subjects_provider.dart';
import 'package:edu_smart_assistant/providers/lessons_provider.dart';
import 'package:edu_smart_assistant/providers/achievement_provider.dart';
import 'package:edu_smart_assistant/services/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FcmService.registerBackgroundHandler();
  } catch (e) {
    debugPrint('خطأ في تهيئة Firebase: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ParentProvider()),
        ChangeNotifierProvider(create: (_) => SubjectsProvider()),
        ChangeNotifierProvider(create: (_) => LessonsProvider()),
        ChangeNotifierProvider(create: (_) => AchievementProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
