// ============================================================
// File: comprehension_quiz_screen.dart
// Purpose: شاشة اختبار الاستيعاب — قراءة نص قصير والإجابة عن أسئلة الفهم
// Owner: حياة — Integration Developer
// Branch: feature/flutter-services
// Week: 3 — الاختبارات والمحادثة الذكية
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:edu_smart_assistant/providers/quiz_provider.dart';
// import 'package:edu_smart_assistant/config/routes.dart';
// import 'package:edu_smart_assistant/widgets/quiz_option_widget.dart';
// import 'package:edu_smart_assistant/widgets/progress_bar_widget.dart';
// import 'package:edu_smart_assistant/widgets/loading_widget.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatefulWidget باسم ComprehensionQuizScreen
//         - class ComprehensionQuizScreen extends StatefulWidget { ... }

// Step 2: في initState — تحميل أسئلة الاستيعاب
//         - context.read<QuizProvider>().loadQuizzes(lessonId, 'comprehension');

// Step 3: تعريف المتغيرات
//         - String? _selectedAnswer;
//         - bool? _isCorrect;

// Step 4: بناء الواجهة (مع إضافة نص مقطع القراءة)
//         - Scaffold(
//             appBar: AppBar(title: Text('اختبار الاستيعاب')),
//             body: Consumer<QuizProvider>(
//               builder: (_, quizProvider, __) {
//                 final quiz = quizProvider.currentQuiz;
//                 return SingleChildScrollView(
//                   child: Column([
//                     // شريط التقدم
//                     ProgressBarWidget(progress: quizProvider.progress, ...),

//                     // مقطع نصي قصير من الدرس (في بطاقة)
//                     Card(
//                       margin: EdgeInsets.all(16),
//                       child: Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Text(
//                           quiz!.questionText.split('---')[0],  // النص قبل الفاصل
//                           style: TextStyle(fontSize: 18, height: 1.6),
//                           textDirection: TextDirection.rtl,
//                         ),
//                       ),
//                     ),

//                     // سؤال الاستيعاب
//                     Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Text(
//                         quiz.questionText.split('---')[1],  // السؤال بعد الفاصل
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ),

//                     // 3-4 خيارات
//                     ...quiz.options.map((option) => Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                       child: QuizOptionWidget(
//                         text: option,
//                         isSelected: _selectedAnswer == option,
//                         isCorrect: _isCorrect,
//                         onTap: () => _selectAnswer(option, quiz.id),
//                       ),
//                     )),
//                   ]),
//                 );
//               },
//             ),
//           )

// Step 5: إنشاء method _selectAnswer(String answer, String quizId)
//         - نفس منطق الاختبارات السابقة

// --- Notes ---
// - اختبار الاستيعاب يعرض نص قصير ثم يسأل أسئلة فهم
// - النص يُعرض في بطاقة منفصلة أعلى السؤال
// - يمكن أن يكون questionText يحتوي النص والسؤال مفصولين بـ '---'
// - أو يمكن استخدام حقلين منفصلين من السيرفر
// - ScrollView ضروري لأن المحتوى قد يكون طويلاً
// - 5 أسئلة لكل جلسة
