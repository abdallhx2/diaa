import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:edu_smart_assistant/config/constants.dart';

class TtsService {
  final ApiService _apiService = ApiService();

  /// تحويل النص إلى كلام — يعيد رابط الملف الصوتي المطلق
  Future<String> generateSpeech(String text) async {
    try {
      final response = await _apiService.post('/tts/generate', data: {
        'text': text,
      });

      final data = response.data;
      if (data['success'] == true) {
        final raw = (data['data']?['audio_url'] ?? '').toString();
        return _absolute(raw);
      }
      throw Exception(data['message'] ?? 'فشل في توليد الصوت');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل في تحويل النص إلى كلام');
    }
  }

  /// تحويل المسار النسبي إلى رابط مطلق
  String _absolute(String url) {
    if (url.isEmpty) return url;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    final origin = Uri.parse(AppConstants.apiBaseUrl).origin;
    return url.startsWith('/') ? '$origin$url' : '$origin/$url';
  }
}
