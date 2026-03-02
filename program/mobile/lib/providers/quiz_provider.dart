// ============================================================
// File: quiz_provider.dart
// Purpose: إدارة حالة الاختبارات — الأسئلة، الإجابات، النتيجة
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 3 — شاشات الاختبارات والمحادثة الذكية
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:edu_smart_assistant/models/quiz_model.dart';
// import 'package:edu_smart_assistant/models/quiz_result_model.dart';
// import 'package:edu_smart_assistant/services/quiz_service.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class QuizProvider extends ChangeNotifier
//         - class QuizProvider extends ChangeNotifier { ... }

// Step 2: تعريف الحقول (Fields)
//         - List<QuizModel> _quizzes = [];           // قائمة الأسئلة
//         - int _currentQuizIndex = 0;                // رقم السؤال الحالي
//         - Map<String, String> _answers = {};        // إجابات الطالب: { quizId: answer }
//         - double _score = 0.0;                      // النتيجة النهائية
//         - bool _isCompleted = false;                // هل انتهى الاختبار؟
//         - bool _isLoading = false;
//         - final QuizService _quizService = QuizService();

// Step 3: إنشاء Getters
//         - List<QuizModel> get quizzes => _quizzes;
//         - int get currentQuizIndex => _currentQuizIndex;
//         - QuizModel? get currentQuiz => _quizzes.isNotEmpty ? _quizzes[_currentQuizIndex] : null;
//         - Map<String, String> get answers => _answers;
//         - double get score => _score;
//         - bool get isCompleted => _isCompleted;
//         - bool get isLoading => _isLoading;
//         - int get totalQuestions => _quizzes.length;
//         - double get progress => _quizzes.isEmpty ? 0 : (_currentQuizIndex + 1) / _quizzes.length;

// Step 4: إنشاء method loadQuizzes(String lessonId, String type)
//         - _isLoading = true; notifyListeners();
//         - استدعاء _quizService.getByType(type) أو getQuizzes(lessonId)
//         - _quizzes = القائمة المُرجعة
//         - _currentQuizIndex = 0; _answers = {}; _isCompleted = false;
//         - _isLoading = false; notifyListeners();

// Step 5: إنشاء method submitAnswer(String quizId, String answer)
//         - _answers[quizId] = answer;
//         - إذا _currentQuizIndex < _quizzes.length - 1:
//           * _currentQuizIndex++; notifyListeners();
//         - إلا:
//           * استدعاء calculateResult()

// Step 6: إنشاء method calculateResult()
//         - إرسال الإجابات للسيرفر: _quizService.submitQuiz(...)
//         - _score = النتيجة المُرجعة من السيرفر
//         - _isCompleted = true;
//         - notifyListeners();

// Step 7: إنشاء method reset()
//         - _quizzes = []; _currentQuizIndex = 0;
//         - _answers = {}; _score = 0.0; _isCompleted = false;
//         - notifyListeners();

// --- Notes ---
// - يدعم 3 أنواع اختبارات: reading, writing, comprehension
// - 5 أسئلة لكل جلسة اختبار (من constants.dart)
// - الإجابة الصحيحة لا تُعرف محلياً — السيرفر يحسب النتيجة
// - progress يُستخدم لعرض شريط التقدم "سؤال 3 من 5"
// - reset() يُستدعى عند بدء اختبار جديد أو العودة للوحة
