// ============================================================
// File: lesson_model.dart
// Purpose: نموذج الدرس — بيانات الدرس المستخرج من المسح أو QR
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// (لا يحتاج imports خارجية)

// --- Implementation Steps ---
// Step 1: إنشاء class LessonModel
//         - class LessonModel { ... }

// Step 2: تعريف الحقول (Fields)
//         - final String id;              // معرف الدرس
//         - final String title;           // عنوان الدرس بالعربي
//         - final String subject;         // المادة (لغة عربية، رياضيات، إلخ)
//         - final String gradeLevel;      // الصف الدراسي
//         - final String originalText;    // النص الأصلي المستخرج من الصفحة
//         - final String qrCode;          // كود QR المرتبط بالدرس
//         - final String audioUrl;        // رابط الملف الصوتي (TTS)
//         - final DateTime createdAt;     // تاريخ الإنشاء

// Step 3: إنشاء Constructor
//         - LessonModel({
//             required this.id,
//             required this.title,
//             this.subject = '',
//             this.gradeLevel = '',
//             required this.originalText,
//             this.qrCode = '',
//             this.audioUrl = '',
//             required this.createdAt,
//           });

// Step 4: إنشاء factory fromJson(Map<String, dynamic> json)
//         - factory LessonModel.fromJson(Map<String, dynamic> json) {
//             return LessonModel(
//               id: json['id'] ?? '',
//               title: json['title'] ?? '',
//               subject: json['subject'] ?? '',
//               gradeLevel: json['grade_level'] ?? '',
//               originalText: json['original_text'] ?? '',
//               qrCode: json['qr_code'] ?? '',
//               audioUrl: json['audio_url'] ?? '',
//               createdAt: DateTime.parse(json['created_at']),
//             );
//           }

// Step 5: إنشاء toJson() method
//         - Map<String, dynamic> toJson() => {
//             'id': id,
//             'title': title,
//             'subject': subject,
//             'grade_level': gradeLevel,
//             'original_text': originalText,
//             'qr_code': qrCode,
//             'audio_url': audioUrl,
//             'created_at': createdAt.toIso8601String(),
//           };

// --- Notes ---
// - originalText هو النص المستخرج بـ OCR من صورة الصفحة
// - audioUrl يتم توليده من خدمة TTS بعد استخراج النص
// - qrCode يكون فارغ إذا تم المسح بالكاميرا أو رفع الملف
// - الدرس يرتبط بالمنهج السعودي
