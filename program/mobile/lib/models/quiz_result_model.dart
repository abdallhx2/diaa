// ============================================================
// File: quiz_result_model.dart
// Purpose: نموذج نتيجة الاختبار — النتيجة وتفاصيل الإجابات
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// (لا يحتاج imports خارجية)

// --- Implementation Steps ---
// Step 1: إنشاء class QuizResultModel
//         - class QuizResultModel { ... }

// Step 2: تعريف الحقول (Fields)
//         - final String id;                            // معرف النتيجة
//         - final String studentId;                     // معرف الطالب
//         - final String quizId;                        // معرف الاختبار
//         - final double score;                         // النتيجة (0.0 - 100.0)
//         - final Map<String, dynamic> answersDetail;   // تفاصيل الإجابات لكل سؤال
//         - final DateTime takenAt;                     // تاريخ أداء الاختبار

// Step 3: إنشاء Constructor
//         - QuizResultModel({
//             required this.id,
//             required this.studentId,
//             required this.quizId,
//             required this.score,
//             required this.answersDetail,
//             required this.takenAt,
//           });

// Step 4: إنشاء factory fromJson(Map<String, dynamic> json)
//         - factory QuizResultModel.fromJson(Map<String, dynamic> json) {
//             return QuizResultModel(
//               id: json['id'] ?? '',
//               studentId: json['student_id'] ?? '',
//               quizId: json['quiz_id'] ?? '',
//               score: (json['score'] ?? 0).toDouble(),
//               answersDetail: Map<String, dynamic>.from(json['answers_detail'] ?? {}),
//               takenAt: DateTime.parse(json['taken_at']),
//             );
//           }

// Step 5: إنشاء toJson() method
//         - Map<String, dynamic> toJson() => {
//             'id': id,
//             'student_id': studentId,
//             'quiz_id': quizId,
//             'score': score,
//             'answers_detail': answersDetail,
//             'taken_at': takenAt.toIso8601String(),
//           };

// --- Notes ---
// - answersDetail يحتوي على: { 'question_id': { 'answer': 'x', 'correct': true/false } }
// - score هي نسبة مئوية: (عدد الإجابات الصحيحة / عدد الأسئلة) * 100
// - يستخدم في شاشة quiz_result_screen.dart لعرض النتيجة
// - يستخدم في تقارير ولي الأمر لمتابعة أداء الطفل
