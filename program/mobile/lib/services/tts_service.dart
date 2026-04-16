import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:dio/dio.dart';

class TtsService {
// Step 1: الاتصال بـ ApiService
final ApiService _apiService = ApiService();

// Step 2: تحويل النص لصوت
Future<String?> generateAudio(String text) async {
try {
Response response = await _apiService.post('/tts/generate', data: {
'text': text,
});

String audioUrl = response.data['audio_url'];
return audioUrl;

} catch (e) {
throw Exception('حدث خطأ في توليد الصوت');
}
}
}