// ============================================================
// File: theme.dart
// Purpose: تعريف ثيم التطبيق — ألوان باستيل، خطوط عربية، تصميم مناسب للأطفال
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// --- Implementation Steps ---
// Step 1: تعريف لوحة الألوان الأساسية (Pastel colors مناسبة للأطفال)
//         - static const Color primaryBlue = Color(0xFF4A90D9);    // أزرق ناعم
//         - static const Color primaryGreen = Color(0xFF66BB6A);   // أخضر ناعم
//         - static const Color primaryOrange = Color(0xFFFFA726);  // برتقالي ناعم
//         - static const Color backgroundColor = Color(0xFFF5F7FA); // خلفية فاتحة
//         - static const Color cardColor = Colors.white;
//         - static const Color textPrimary = Color(0xFF2C3E50);    // نص أساسي
//         - static const Color textSecondary = Color(0xFF7F8C8D);  // نص ثانوي
//         - static const Color errorColor = Color(0xFFE57373);     // أحمر ناعم للأخطاء
//         - static const Color successColor = Color(0xFF81C784);   // أخضر ناعم للنجاح

// Step 2: تعريف عائلة الخط العربي
//         - استخدام Google Fonts — Cairo أو Tajawal
//         - static TextTheme get arabicTextTheme => GoogleFonts.cairoTextTheme();
//         - أو GoogleFonts.tajawalTextTheme()

// Step 3: إنشاء ThemeData مع أحجام نص كبيرة للأطفال
//         - static ThemeData get lightTheme => ThemeData(
//             primaryColor: primaryBlue,
//             colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
//             scaffoldBackgroundColor: backgroundColor,
//             textTheme: arabicTextTheme.copyWith(
//               headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//               headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               bodyLarge: TextStyle(fontSize: 20),   // حجم كبير للأطفال
//               bodyMedium: TextStyle(fontSize: 18),
//               labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//           );

// Step 4: ثيم الأزرار — ارتفاع لا يقل عن 48dp
//         - elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//               minimumSize: Size(double.infinity, 48),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//           ),

// Step 5: ثيم حقول الإدخال مع حدود مستديرة
//         - inputDecorationTheme: InputDecorationTheme(
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//             filled: true,
//             fillColor: Colors.white,
//             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           ),

// Step 6: ثيم البطاقات
//         - cardTheme: CardTheme(
//             elevation: 2,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             margin: EdgeInsets.all(8),
//           ),

// Step 7: ثيم الـ AppBar
//         - appBarTheme: AppBarTheme(
//             backgroundColor: primaryBlue,
//             foregroundColor: Colors.white,
//             elevation: 0,
//             centerTitle: true,
//             titleTextStyle: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold),
//           ),

// --- Notes ---
// - جميع الألوان يجب أن تكون باستيل (ناعمة) لتناسب الأطفال
// - الخطوط يجب أن تكون كبيرة وواضحة
// - أقل ارتفاع للأزرار 48dp لسهولة اللمس
// - يمكن إضافة dark theme لاحقاً
// - تأكد من إضافة google_fonts في pubspec.yaml
