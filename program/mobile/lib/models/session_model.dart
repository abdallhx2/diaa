// ============================================================
// File: session_model.dart
// Purpose: نموذج الجلسة — تسجيل جلسة تعلم الطالب (مسح/QR/رفع)
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// (لا يحتاج imports خارجية)

// --- Implementation Steps ---
// Step 1: إنشاء class SessionModel
//         - class SessionModel { ... }

// Step 2: تعريف الحقول (Fields)
//         - final String id;              // معرف الجلسة
//         - final String studentId;       // معرف الطالب
//         - final String lessonId;        // معرف الدرس
//         - final String sessionType;     // نوع الجلسة: 'scan' / 'qr' / 'upload'
//         - final DateTime startedAt;     // وقت بداية الجلسة
//         - final DateTime? endedAt;      // وقت نهاية الجلسة (nullable — قد تكون مستمرة)
//         - final int durationMinutes;    // مدة الجلسة بالدقائق

// Step 3: إنشاء Constructor
//         - SessionModel({
//             required this.id,
//             required this.studentId,
//             required this.lessonId,
//             required this.sessionType,
//             required this.startedAt,
//             this.endedAt,
//             this.durationMinutes = 0,
//           });

// Step 4: إنشاء factory fromJson(Map<String, dynamic> json)
//         - factory SessionModel.fromJson(Map<String, dynamic> json) {
//             return SessionModel(
//               id: json['id'] ?? '',
//               studentId: json['student_id'] ?? '',
//               lessonId: json['lesson_id'] ?? '',
//               sessionType: json['session_type'] ?? '',
//               startedAt: DateTime.parse(json['started_at']),
//               endedAt: json['ended_at'] != null ? DateTime.parse(json['ended_at']) : null,
//               durationMinutes: json['duration_minutes'] ?? 0,
//             );
//           }

// Step 5: إنشاء toJson() method
//         - Map<String, dynamic> toJson() => {
//             'id': id,
//             'student_id': studentId,
//             'lesson_id': lessonId,
//             'session_type': sessionType,
//             'started_at': startedAt.toIso8601String(),
//             'ended_at': endedAt?.toIso8601String(),
//             'duration_minutes': durationMinutes,
//           };

// --- Notes ---
// - sessionType يحدد كيف بدأ الطالب الجلسة:
//   * scan: مسح صفحة بالكاميرا
//   * qr: مسح كود QR
//   * upload: رفع صورة من المعرض
// - endedAt يكون null إذا الجلسة لم تنتهِ بعد
// - durationMinutes يتم حسابه تلقائياً من الـ Backend
// - يستخدم في تقارير ولي الأمر لمعرفة وقت الدراسة
