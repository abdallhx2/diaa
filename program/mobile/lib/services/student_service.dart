import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:edu_smart_assistant/models/session_model.dart';
import 'package:dio/dio.dart';

class StudentService {
// Step 1: الاتصال بـ ApiService
final ApiService _apiService = ApiService();

// Step 2: جلب لوحة تحكم الطالب
Future<Map<String, dynamic>> getDashboard() async {
try {
Response response = await _apiService.get('/student/dashboard');
return response.data;

} catch (e) {
throw Exception('حدث خطأ في جلب لوحة التحكم');
}
}

// Step 3: جلب جلسات التعلم
Future<List<SessionModel>> getSessions() async {
try {
Response response = await _apiService.get('/student/sessions');

List<SessionModel> sessions = (response.data as List)
.map((e) => SessionModel.fromJson(e))
.toList();

return sessions;

} catch (e) {
throw Exception('حدث خطأ في جلب الجلسات');
}
}

// Step 4: جلب تقدم الطالب
Future<Map<String, dynamic>> getProgress() async {
try {
Response response = await _apiService.get('/student/progress');
return response.data;

} catch (e) {
throw Exception('حدث خطأ في جلب بيانات التقدم');
}
}
}