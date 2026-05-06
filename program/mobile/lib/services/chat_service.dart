import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:edu_smart_assistant/models/chat_message_model.dart';

class ChatService {
  final ApiService _apiService = ApiService();

  /// إرسال سؤال للمساعد الذكي
  Future<Map<String, dynamic>> askQuestion(
      String question, String lessonId) async {
    try {
      final response = await _apiService.post('/chat/ask', data: {
        'question': question,
        'lesson_id': lessonId.isEmpty ? null : lessonId,
      });

      final data = response.data;
      if (data['success'] == true) {
        return data['data'] as Map<String, dynamic>;
      }
      throw Exception(data['message'] ?? 'فشل في إرسال السؤال');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل في الاتصال بالمساعد الذكي');
    }
  }

  /// جلب تاريخ المحادثة لدرس معين
  /// Backend يعيد: { messages: [...] }
  Future<List<ChatMessageModel>> getHistory(String lessonId) async {
    if (lessonId.isEmpty) return [];
    try {
      final response = await _apiService.get('/chat/history/$lessonId');

      final data = response.data;
      if (data['success'] == true) {
        final messages = data['data']['messages'] as List<dynamic>? ?? [];
        return messages
            .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
