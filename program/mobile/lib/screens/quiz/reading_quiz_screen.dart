// ============================================================
// File: reading_quiz_screen.dart
// Purpose: شاشة اختبار القراءة — تهجئة الكلمات واختيار النطق الصحيح
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
// Step 1: إنشاء StatefulWidget باسم ReadingQuizScreen
//         - class ReadingQuizScreen extends StatefulWidget { ... }

// Step 2: في initState — تحميل أسئلة القراءة
//         - context.read<QuizProvider>().loadQuizzes(lessonId, 'reading');

// Step 3: تعريف المتغيرات
//         - String? _selectedAnswer;         // الإجابة المحددة
//         - bool? _isCorrect;                // هل الإجابة صحيحة؟ (يأتي من السيرفر)

// Step 4: بناء الواجهة
//         - Scaffold(
//             appBar: AppBar(title: Text('اختبار القراءة')),
//             body: Consumer<QuizProvider>(
//               builder: (_, quizProvider, __) {
//                 if (quizProvider.isLoading) return LoadingWidget();
//                 final quiz = quizProvider.currentQuiz;
//                 return Column([
//                   // شريط التقدم: "سؤال 3 من 5"
//                   Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Column([
//                       Text('سؤال ${quizProvider.currentQuizIndex + 1} من ${quizProvider.totalQuestions}'),
//                       ProgressBarWidget(
//                         progress: quizProvider.progress,
//                         label: 'التقدم',
//                         color: AppTheme.primaryBlue,
//                       ),
//                     ]),
//                   ),

//                   // عرض الكلمة مع التهجئة
//                   // مثال: "تَ-كا-ثُف"
//                   Padding(
//                     padding: EdgeInsets.all(24),
//                     child: Text(
//                       quiz!.questionText,
//                       style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),

//                   // عرض 4 خيارات
//                   ...quiz.options.map((option) => Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                     child: QuizOptionWidget(
//                       text: option,
//                       isSelected: _selectedAnswer == option,
//                       isCorrect: _isCorrect,  // null قبل الإجابة
//                       onTap: () => _selectAnswer(option, quiz.id),
//                     ),
//                   )),
//                 ]);
//               },
//             ),
//           )

// Step 5: إنشاء method _selectAnswer(String answer, String quizId)
//         - setState(() => _selectedAnswer = answer);
//         - إرسال الإجابة: context.read<QuizProvider>().submitAnswer(quizId, answer)
//         - تلوين الخيار (أخضر صحيح / أحمر خطأ)
//         - انتظار 1 ثانية: await Future.delayed(Duration(seconds: 1))
//         - إذا آخر سؤال: Navigator.pushReplacementNamed(context, AppRoutes.quizResult)
//         - إذا لا: إعادة تعيين _selectedAnswer = null للسؤال التالي

// --- Notes ---
// - 5 أسئلة لكل جلسة اختبار
// - الكلمة تعرض بخط كبير (32px) مع التشكيل
// - بعد اختيار الإجابة: تلوين الخيار + انتظار 1 ثانية + الانتقال للسؤال التالي
// - شريط التقدم يتحدث تلقائياً مع كل سؤال
// - بعد السؤال الأخير: الانتقال لشاشة النتيجة
