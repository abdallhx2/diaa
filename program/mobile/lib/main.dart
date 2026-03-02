// ============================================================
// File: main.dart
// Purpose: نقطة الدخول الرئيسية للتطبيق — تهيئة Firebase والـ Providers
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'package:edu_smart_assistant/app.dart';
// import 'package:edu_smart_assistant/providers/auth_provider.dart';
// import 'package:edu_smart_assistant/providers/student_provider.dart';
// import 'package:edu_smart_assistant/providers/lesson_provider.dart';
// import 'package:edu_smart_assistant/providers/quiz_provider.dart';
// import 'package:edu_smart_assistant/providers/chat_provider.dart';
// import 'package:edu_smart_assistant/providers/parent_provider.dart';

// --- Implementation Steps ---
// Step 1: إنشاء دالة main() كـ async
//         - void main() async { ... }

// Step 2: تهيئة Flutter Binding
//         - WidgetsFlutterBinding.ensureInitialized();
//         - مطلوب قبل استخدام أي plugin أصلي

// Step 3: تهيئة Firebase
//         - await Firebase.initializeApp();
//         - التأكد من وجود ملفات google-services.json (Android) و GoogleService-Info.plist (iOS)

// Step 4: لف التطبيق بـ MultiProvider
//         - MultiProvider(
//             providers: [
//               ChangeNotifierProvider(create: (_) => AuthProvider()),
//               ChangeNotifierProvider(create: (_) => StudentProvider()),
//               ChangeNotifierProvider(create: (_) => LessonProvider()),
//               ChangeNotifierProvider(create: (_) => QuizProvider()),
//               ChangeNotifierProvider(create: (_) => ChatProvider()),
//               ChangeNotifierProvider(create: (_) => ParentProvider()),
//             ],
//             child: MyApp(),
//           )

// Step 5: تشغيل التطبيق
//         - runApp(MultiProvider(...));

// --- Notes ---
// - يجب أن تكون main() هي async لأن Firebase.initializeApp() تعيد Future
// - ترتيب الـ Providers مهم إذا كان أحدهم يعتمد على الآخر
// - MyApp يتم استيراده من app.dart
// - في حالة فشل Firebase، يجب إضافة try-catch وعرض شاشة خطأ
