import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:edu_smart_assistant/models/session_model.dart';

class StudentService {
  final ApiService _apiService = ApiService();

  /// جلب بيانات لوحة تحكم الطالب
  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await _apiService.get('/student/dashboard');

      final data = response.data;
      if (data['success'] == true) {
        return data['data'] as Map<String, dynamic>;
      }
      throw Exception(data['message'] ?? 'فشل في جلب بيانات لوحة التحكم');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل في جلب بيانات لوحة التحكم');
    }
  }

  /// جلب قائمة جلسات التعلم
  Future<List<SessionModel>> getSessions() async {
    try {
      final response = await _apiService.get('/student/sessions');

      final data = response.data;
      if (data['success'] == true) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((e) => SessionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('فشل في جلب الجلسات');
    }
  }

  /// جلب بيانات تقدم الطالب
  Future<Map<String, dynamic>> getProgress() async {
    try {
      final response = await _apiService.get('/student/progress');

      final data = response.data;
      if (data['success'] == true) {
        return data['data'] as Map<String, dynamic>;
      }
      throw Exception(data['message'] ?? 'فشل في جلب بيانات التقدم');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل في جلب بيانات التقدم');
    }
  }
}
