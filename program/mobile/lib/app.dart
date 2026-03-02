// ============================================================
// File: app.dart
// Purpose: إعداد MaterialApp الرئيسي — الثيم، التوجيه، اللغة العربية
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:edu_smart_assistant/config/theme.dart';
// import 'package:edu_smart_assistant/config/routes.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatelessWidget باسم MyApp
//         - class MyApp extends StatelessWidget { ... }

// Step 2: إنشاء MaterialApp مع الإعدادات العربية
//         - return MaterialApp(
//             title: 'المساعد التعليمي الذكي',
//             debugShowCheckedModeBanner: false,
//             ...
//           );

// Step 3: تعيين الثيم من theme.dart
//         - theme: AppTheme.lightTheme,
//         - استخدام الألوان الباستيل المناسبة للأطفال

// Step 4: إعداد RTL والـ Locale العربية
//         - locale: const Locale('ar', 'SA'),
//         - supportedLocales: [Locale('ar', 'SA')],
//         - localizationsDelegates: [
//             GlobalMaterialLocalizations.delegate,
//             GlobalWidgetsLocalizations.delegate,
//             GlobalCupertinoLocalizations.delegate,
//           ],
//         - لف بـ Directionality(textDirection: TextDirection.rtl, child: ...)

// Step 5: تعيين المسار الابتدائي للـ Splash
//         - initialRoute: '/splash',
//         - أو initialRoute: AppRoutes.splash

// Step 6: تسجيل جميع المسارات من routes.dart
//         - routes: AppRoutes.routes,
//         - أو onGenerateRoute: AppRoutes.generateRoute,

// --- Notes ---
// - debugShowCheckedModeBanner: false لإزالة شريط Debug
// - يجب إضافة حزمة flutter_localizations في pubspec.yaml
// - جميع النصوص ستكون بالعربية — التأكد من دعم RTL في كل الشاشات
// - الثيم يجب أن يكون مناسباً للأطفال (ألوان ناعمة، خطوط كبيرة)
