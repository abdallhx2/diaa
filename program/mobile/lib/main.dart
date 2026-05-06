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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
      ],
      child: const MyApp(),
    ),
  );
}
