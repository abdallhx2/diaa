// ============================================================
// File: quiz_service.dart
// Purpose: خدمة الاختبارات — جلب الأسئلة وإرسال الإجابات واستلام النتائج
// Owner: حياة — Integration Developer
// Branch: feature/flutter-services
// Week: 3 — خدمات الاختبارات
// ============================================================

// --- Required Imports ---
// import 'package:edu_smart_assistant/services/api_service.dart';
// import 'package:edu_smart_assistant/models/quiz_model.dart';
// import 'package:edu_smart_assistant/models/quiz_result_model.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class QuizService
//         - class QuizService {
//             final ApiService _apiService = ApiService();
//           }

// Step 2: إنشاء method getQuizzes(String lessonId)
//         - // جلب جميع اختبارات درس معين
//         - Response response = await _apiService.get('/quizzes/$lessonId');
//         - List<QuizModel> quizzes = (response.data as List)
//             .map((e) => QuizModel.fromJson(e))
//             .toList();
//         - return quizzes;
//         - // GET /api/quizzes/{lessonId}

// Step 3: إنشاء method getByType(String type)
//         - // جلب اختبارات بنوع محدد (reading/writing/comprehension)
//         - Response response = await _apiService.get('/quizzes/types/$type');
//         - List<QuizModel> quizzes = (response.data as List)
//             .map((e) => QuizModel.fromJson(e))
//             .toList();
//         - return quizzes;
//         - // GET /api/quizzes/types/{type}

// Step 4: إنشاء method submitQuiz(String quizId, String studentId, Map<String, String> answers)
//         - // إرسال إجابات الطالب واستلام النتيجة
//         - Response response = await _apiService.post('/quizzes/submit', data: {
//             'quiz_id': quizId,
//             'student_id': studentId,
//             'answers': answers,
//           });
//         - return QuizResultModel.fromJson(response.data);
//         - // POST /api/quizzes/submit — application/json
//         - // Response: { "score": 80.0, "answers_detail": {...}, ... }

// Step 5: إنشاء method getResults(String studentId)
//         - // جلب جميع نتائج اختبارات طالب
//         - Response response = await _apiService.get('/quizzes/results/$studentId');
//         - List<QuizResultModel> results = (response.data as List)
//             .map((e) => QuizResultModel.fromJson(e))
//             .toList();
//         - return results;
//         - // GET /api/quizzes/results/{studentId}

// --- Notes ---
// - الإجابة الصحيحة لا تُرسل للتطبيق — السيرفر يحسب النتيجة
// - submitQuiz يرسل كل الإجابات دفعة واحدة بعد انتهاء الاختبار
// - answers هي Map: { 'quiz_question_id': 'selected_answer', ... }
// - getResults يُستخدم في تقارير ولي الأمر
// - 3 أنواع: reading, writing, comprehension
