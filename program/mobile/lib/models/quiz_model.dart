// ============================================================
// File: quiz_model.dart
// Purpose: نموذج الاختبار — سؤال واحد مع خياراته
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// (لا يحتاج imports خارجية)

// --- Implementation Steps ---
// Step 1: إنشاء class QuizModel
//         - class QuizModel { ... }

// Step 2: تعريف الحقول (Fields)
//         - final String id;                // معرف السؤال
//         - final String lessonId;           // معرف الدرس المرتبط
//         - final String quizType;           // نوع الاختبار: 'reading' / 'writing' / 'comprehension'
//         - final String questionText;       // نص السؤال بالعربي
//         - final List<String> options;      // الخيارات (3-4 خيارات)
//         // ملاحظة: correctAnswer لا يُخزن في التطبيق — السيرفر فقط يعرف الإجابة الصحيحة

// Step 3: إنشاء Constructor
//         - QuizModel({
//             required this.id,
//             required this.lessonId,
//             required this.quizType,
//             required this.questionText,
//             required this.options,
//           });

// Step 4: إنشاء factory fromJson(Map<String, dynamic> json)
//         - factory QuizModel.fromJson(Map<String, dynamic> json) {
//             return QuizModel(
//               id: json['id'] ?? '',
//               lessonId: json['lesson_id'] ?? '',
//               quizType: json['quiz_type'] ?? '',
//               questionText: json['question_text'] ?? '',
//               options: List<String>.from(json['options'] ?? []),
//             );
//           }

// Step 5: إنشاء toJson() method
//         - Map<String, dynamic> toJson() => {
//             'id': id,
//             'lesson_id': lessonId,
//             'quiz_type': quizType,
//             'question_text': questionText,
//             'options': options,
//           };

// --- Notes ---
// - الإجابة الصحيحة (correctAnswer) لا تُرسل للتطبيق لمنع الغش
// - التحقق من الإجابة يتم على السيرفر فقط
// - quizType يحدد نوع الاختبار:
//   * reading: اختبار قراءة (تهجئة وقراءة كلمات)
//   * writing: اختبار كتابة (اختيار من متعدد عن المحتوى)
//   * comprehension: اختبار استيعاب (فهم النص)
// - options عادة 3-4 خيارات
