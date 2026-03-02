// ============================================================
// File: chat_message_model.dart
// Purpose: نموذج رسالة المحادثة — رسائل الطالب وردود المساعد الذكي
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// (لا يحتاج imports خارجية)

// --- Implementation Steps ---
// Step 1: إنشاء class ChatMessageModel
//         - class ChatMessageModel { ... }

// Step 2: تعريف الحقول (Fields)
//         - final String id;              // معرف الرسالة
//         - final String studentId;       // معرف الطالب
//         - final String lessonId;        // معرف الدرس المرتبط (سياق المحادثة)
//         - final String userMessage;     // رسالة الطالب (السؤال)
//         - final String botResponse;     // رد المساعد الذكي (الإجابة)
//         - final String audioUrl;        // رابط الصوت لرد المساعد (TTS)
//         - final DateTime createdAt;     // وقت الرسالة

// Step 3: إنشاء Constructor
//         - ChatMessageModel({
//             required this.id,
//             required this.studentId,
//             required this.lessonId,
//             required this.userMessage,
//             required this.botResponse,
//             this.audioUrl = '',
//             required this.createdAt,
//           });

// Step 4: إنشاء factory fromJson(Map<String, dynamic> json)
//         - factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
//             return ChatMessageModel(
//               id: json['id'] ?? '',
//               studentId: json['student_id'] ?? '',
//               lessonId: json['lesson_id'] ?? '',
//               userMessage: json['user_message'] ?? '',
//               botResponse: json['bot_response'] ?? '',
//               audioUrl: json['audio_url'] ?? '',
//               createdAt: DateTime.parse(json['created_at']),
//             );
//           }

// Step 5: إنشاء toJson() method
//         - Map<String, dynamic> toJson() => {
//             'id': id,
//             'student_id': studentId,
//             'lesson_id': lessonId,
//             'user_message': userMessage,
//             'bot_response': botResponse,
//             'audio_url': audioUrl,
//             'created_at': createdAt.toIso8601String(),
//           };

// --- Notes ---
// - كل رسالة تحتوي على سؤال الطالب ورد المساعد معاً
// - audioUrl هو رابط الصوت لرد المساعد (يتم تشغيله تلقائياً)
// - lessonId يربط المحادثة بالدرس الحالي (السياق)
// - أقصى عدد رسائل في الجلسة الواحدة: 20 (من constants.dart)
// - يستخدم في ChatBubbleWidget لعرض الرسائل
