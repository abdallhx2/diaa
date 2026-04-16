import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:edu_smart_assistant/models/chat_message_model.dart';
import 'package:dio/dio.dart';

class ChatService {
// Step 1: الاتصال بـ ApiService
final ApiService _apiService = ApiService();

// Step 2: إرسال سؤال للـ AI
Future<Map<String, dynamic>> askQuestion(
String question, String lessonId) async {
try {
Response response = await _apiService.post('/chat/ask', data: {
'question': question,
'lesson_id': lessonId,
});

return {
'answer': response.data['answer'],
'audio_url': response.data['audio_url'],
};

} catch (e) {
throw Exception('حدث خطأ في إرسال السؤال، حاول مرة أخرى');
}
}

// Step 3: جلب تاريخ المحادثة
Future<List<ChatMessageModel>> getHistory(String lessonId) async {
try {
Response response =
await _apiService.get('/chat/history/$lessonId');

List<ChatMessageModel> messages = (response.data as List)
.map((e) => ChatMessageModel.fromJson(e))
.toList();

return messages;

} catch (e) {
throw Exception('حدث خطأ في جلب المحادثات');
}
}
}