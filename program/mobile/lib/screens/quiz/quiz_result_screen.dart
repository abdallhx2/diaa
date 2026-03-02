// ============================================================
// File: quiz_result_screen.dart
// Purpose: شاشة نتيجة الاختبار — عرض الدرجة مع رسوم تحفيزية
// Owner: حياة — Integration Developer
// Branch: feature/flutter-services
// Week: 3 — الاختبارات والمحادثة الذكية
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:lottie/lottie.dart';
// import 'package:edu_smart_assistant/providers/quiz_provider.dart';
// import 'package:edu_smart_assistant/config/routes.dart';
// import 'package:edu_smart_assistant/config/theme.dart';
// import 'package:edu_smart_assistant/widgets/custom_button.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatelessWidget باسم QuizResultScreen
//         - class QuizResultScreen extends StatelessWidget { ... }

// Step 2: قراءة النتيجة من QuizProvider
//         - final quizProvider = context.read<QuizProvider>();
//         - double score = quizProvider.score;
//         - int correct = (score / 100 * 5).round();  // عدد الإجابات الصحيحة
//         - bool isGoodScore = score >= 60;

// Step 3: بناء الواجهة
//         - Scaffold(
//             body: SafeArea(
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // حركة Lottie تحفيزية
//                     if (isGoodScore)
//                       // Lottie.asset('assets/animations/celebration.json', width: 200)
//                       // نجوم واحتفال للنتيجة الجيدة
//                     else
//                       // Lottie.asset('assets/animations/encouragement.json', width: 200)
//                       // تشجيع للنتيجة المنخفضة

//                     SizedBox(height: 24),

//                     // عرض الدرجة بشكل بارز
//                     Text(
//                       '${correct}/5',
//                       style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold,
//                         color: isGoodScore ? AppTheme.successColor : AppTheme.primaryOrange),
//                     ),
//                     Text(
//                       '${score.round()}%',
//                       style: TextStyle(fontSize: 28, color: Colors.grey),
//                     ),

//                     SizedBox(height: 16),

//                     // رسالة تحفيزية
//                     Text(
//                       isGoodScore ? 'أحسنت! عمل رائع!' : 'لا بأس، حاول مرة أخرى!',
//                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),

//                     SizedBox(height: 48),

//                     // زر إعادة الاختبار
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 32),
//                       child: CustomButton(
//                         text: 'إعادة الاختبار',
//                         icon: Icons.refresh,
//                         color: AppTheme.primaryOrange,
//                         onPressed: () {
//                           quizProvider.reset();
//                           Navigator.pop(context);  // العودة لشاشة الاختبار
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 12),

//                     // زر العودة للوحة
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 32),
//                       child: CustomButton(
//                         text: 'العودة للوحة',
//                         icon: Icons.home,
//                         color: AppTheme.primaryBlue,
//                         onPressed: () {
//                           quizProvider.reset();
//                           Navigator.pushNamedAndRemoveUntil(
//                             context, AppRoutes.studentDashboard, (route) => false,
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )

// --- Notes ---
// - النتيجة تُعرض كـ "4/5 = 80%"
// - Lottie animation: نجوم/احتفال إذا النتيجة >= 60%، تشجيع إذا أقل
// - أضف ملفات Lottie في: assets/animations/celebration.json و encouragement.json
// - يمكن تحميل ملفات Lottie مجانية من lottiefiles.com
// - زران: إعادة الاختبار أو العودة للوحة
// - quizProvider.reset() يمسح بيانات الاختبار السابق
// - رسائل تحفيزية بالعربي مناسبة للأطفال
