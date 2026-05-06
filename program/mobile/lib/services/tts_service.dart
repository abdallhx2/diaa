import 'package:edu_smart_assistant/services/api_service.dart';

class TtsService {
  final ApiService _apiService = ApiService();

  /// تحويل النص إلى كلام — يعيد رابط الملف الصوتي
  Future<String> generateSpeech(String text) async {
    try {
      final response = await _apiService.post('/tts/generate', data: {
        'text': text,
      });

      final data = response.data;
      if (data['success'] == true) {
        return data['data']['audio_url'] ?? '';
      }
      throw Exception(data['message'] ?? 'فشل في توليد الصوت');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل في تحويل النص إلى كلام');
    }
  }
}
