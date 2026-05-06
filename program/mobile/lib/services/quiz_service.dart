import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:edu_smart_assistant/models/quiz_model.dart';
import 'package:edu_smart_assistant/models/quiz_result_model.dart';

class QuizService {
  final ApiService _apiService = ApiService();

  /// جلب اختبارات درس معين
  Future<List<QuizModel>> getQuizzesByLesson(String lessonId) async {
    try {
      final response = await _apiService.get('/quizzes/$lessonId');

      final data = response.data;
      if (data['success'] == true) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((e) => QuizModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('فشل في جلب الاختبارات');
    }
  }

  /// جلب اختبارات بنوع محدد
  Future<List<QuizModel>> getQuizzesByType(String type) async {
    try {
      final response = await _apiService.get('/quizzes/types/$type');

      final data = response.data;
      if (data['success'] == true) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((e) => QuizModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('فشل في جلب الاختبارات');
    }
  }

  /// إرسال إجابة سؤال واحد
  Future<QuizResultModel> submitAnswer(
      String quizId, String selectedAnswer) async {
    try {
      final response = await _apiService.post('/quizzes/submit', data: {
        'quiz_id': quizId,
        'selected_answer': selectedAnswer,
      });

      final data = response.data;
      if (data['success'] == true) {
        return QuizResultModel.fromJson(data['data']);
      }
      throw Exception(data['message'] ?? 'فشل في إرسال الإجابة');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل في إرسال الإجابة');
    }
  }

  /// جلب نتائج اختبارات طالب
  Future<List<QuizResultModel>> getResults(String studentId) async {
    try {
      final response = await _apiService.get('/quizzes/results/$studentId');

      final data = response.data;
      if (data['success'] == true) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((e) => QuizResultModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('فشل في جلب النتائج');
    }
  }
}
