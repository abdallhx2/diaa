import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:edu_smart_assistant/models/lesson_model.dart';
import 'package:edu_smart_assistant/models/lesson_detail_model.dart';

class LessonService {
  final ApiService _apiService = ApiService();

  Future<List<String>> getSubjects(String grade) async {
    try {
      final response = await _apiService.get(
        '/lessons/subjects',
        queryParameters: {'grade': grade},
      );
      final data = response.data;
      if (data['success'] == true) {
        final list = data['data']['subjects'] as List<dynamic>? ?? [];
        return list.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      throw Exception('فشل في جلب المواد');
    }
  }

  Future<List<LessonModel>> getLessons(String grade, String subject) async {
    try {
      final response = await _apiService.get(
        '/lessons',
        queryParameters: {'grade': grade, 'subject': subject},
      );
      final data = response.data;
      if (data['success'] == true) {
        final list = data['data'] as List<dynamic>? ?? [];
        return list
            .map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('فشل في جلب الدروس');
    }
  }

  Future<LessonDetailModel> getLessonDetail(String id) async {
    try {
      final response = await _apiService.get('/lessons/$id');
      final data = response.data;
      if (data['success'] == true) {
        return LessonDetailModel.fromJson(
            data['data'] as Map<String, dynamic>);
      }
      throw Exception(data['message'] ?? 'فشل في جلب تفاصيل الدرس');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل في جلب تفاصيل الدرس');
    }
  }
}
