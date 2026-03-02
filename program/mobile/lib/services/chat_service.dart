// ============================================================
// File: chat_service.dart
// Purpose: خدمة المحادثة الذكية — إرسال الأسئلة واستقبال الردود من AI
// Owner: حياة — Integration Developer
// Branch: feature/flutter-services
// Week: 2 — خدمات المحادثة الذكية
// ============================================================

// --- Required Imports ---
// import 'package:edu_smart_assistant/services/api_service.dart';
// import 'package:edu_smart_assistant/models/chat_message_model.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class ChatService
//         - class ChatService {
//             final ApiService _apiService = ApiService();
//           }

// Step 2: إنشاء method askQuestion(String question, String lessonId)
//         - // إرسال سؤال الطالب للـ AI
//         - Response response = await _apiService.post('/chat/ask', data: {
//             'question': question,
//             'lesson_id': lessonId,
//           });
//         - // الاستجابة تحتوي على: answer + audio_url
//         - return {
//             'answer': response.data['answer'],        // رد المساعد النصي
//             'audio_url': response.data['audio_url'],   // رابط الصوت لرد المساعد
//           };
//         - // POST /api/chat/ask — application/json
//         - // Response: { "answer": "...", "audio_url": "..." }

// Step 3: إنشاء method getHistory(String lessonId)
//         - // جلب تاريخ المحادثة لدرس معين
//         - Response response = await _apiService.get('/chat/history/$lessonId');
//         - List<ChatMessageModel> messages = (response.data as List)
//             .map((e) => ChatMessageModel.fromJson(e))
//             .toList();
//         - return messages;
//         - // GET /api/chat/history/{lessonId}
//         - // Response: [{ "user_message": "...", "bot_response": "...", ... }, ...]

// --- Notes ---
// - السيرفر يستخدم AI (مثل GPT أو Gemini) للإجابة على الأسئلة
// - lessonId يُرسل كسياق لكي يفهم AI محتوى الدرس
// - audio_url هو صوت رد المساعد (يتم توليده بـ TTS على السيرفر)
// - getHistory يجلب المحادثات السابقة لنفس الدرس
// - الحد الأقصى 20 رسالة لكل جلسة (يُتحقق في ChatProvider)
// - في حالة الفشل: throw Exception مع رسالة عربية
