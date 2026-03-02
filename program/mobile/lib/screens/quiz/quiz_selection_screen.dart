// ============================================================
// File: quiz_selection_screen.dart
// Purpose: شاشة اختيار نوع الاختبار — قراءة/كتابة/استيعاب
// Owner: حياة — Integration Developer
// Branch: feature/flutter-services
// Week: 3 — الاختبارات والمحادثة الذكية
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:edu_smart_assistant/config/routes.dart';
// import 'package:edu_smart_assistant/config/theme.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatelessWidget باسم QuizSelectionScreen
//         - class QuizSelectionScreen extends StatelessWidget { ... }

// Step 2: بناء الواجهة
//         - Scaffold(
//             appBar: AppBar(title: Text('اختر نوع الاختبار')),
//             body: Padding(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _buildQuizTypeCard(...),  // القراءة
//                   SizedBox(height: 16),
//                   _buildQuizTypeCard(...),  // الكتابة
//                   SizedBox(height: 16),
//                   _buildQuizTypeCard(...),  // الاستيعاب
//                 ],
//               ),
//             ),
//           )

// Step 3: إنشاء بطاقة "اختبار القراءة"
//         - _buildQuizTypeCard(
//             icon: Icons.menu_book,
//             title: 'اختبار القراءة',
//             description: 'اقرأ الكلمات واختر النطق الصحيح',
//             color: AppTheme.primaryBlue,
//             onTap: () => Navigator.pushNamed(context, AppRoutes.readingQuiz),
//           )

// Step 4: إنشاء بطاقة "اختبار الكتابة"
//         - _buildQuizTypeCard(
//             icon: Icons.edit_note,
//             title: 'اختبار الكتابة',
//             description: 'أجب عن أسئلة الكتابة',
//             color: AppTheme.primaryGreen,
//             onTap: () => Navigator.pushNamed(context, AppRoutes.writingQuiz),
//           )

// Step 5: إنشاء بطاقة "اختبار الاستيعاب"
//         - _buildQuizTypeCard(
//             icon: Icons.psychology,
//             title: 'اختبار الاستيعاب',
//             description: 'اقرأ النص وأجب عن الأسئلة',
//             color: AppTheme.primaryOrange,
//             onTap: () => Navigator.pushNamed(context, AppRoutes.comprehensionQuiz),
//           )

// Step 6: إنشاء method _buildQuizTypeCard(...)
//         - Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             child: InkWell(
//               onTap: onTap,
//               child: Padding(
//                 padding: EdgeInsets.all(20),
//                 child: Row(children: [
//                   Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: ...),
//                     child: Icon(icon, size: 48, color: color),
//                   ),
//                   SizedBox(width: 16),
//                   Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                     Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                     Text(description, style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   ]),
//                 ]),
//               ),
//             ),
//           )

// --- Notes ---
// - 3 أنواع اختبارات مرتبطة بالدرس الحالي
// - كل بطاقة بلون باستيل مختلف
// - أيقونات كبيرة (48px) ونصوص واضحة
// - يمكن تمرير lessonId كـ argument لشاشات الاختبار
// - التصميم RTL مع ألوان مناسبة للأطفال
