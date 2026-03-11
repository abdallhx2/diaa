import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:edu_smart_assistant/models/quiz_model.dart';
import 'package:edu_smart_assistant/models/quiz_result_model.dart';
import 'package:dio/dio.dart';

class QuizService {
// Step 1: الاتصال بـ ApiService
final ApiService _apiService = ApiService();

// Step 2: جلب اختبارات درس معين
Future<List<QuizModel>> getQuizzes(String lessonId) async {
try {
Response response = await _apiService.get('/quizzes/$lessonId');

List<QuizModel> quizzes = (response.data as List)
.map((e) => QuizModel.fromJson(e))
.toList();

return quizzes;

} catch (e) {
throw Exception('حدث خطأ في جلب الاختبارات');
}
}

// Step 3: جلب اختبارات بنوع محدد
Future<List<QuizModel>> getByType(String type) async {
try {
Response response = await _apiService.get('/quizzes/types/$type');

List<QuizModel> quizzes = (response.data as List)
.map((e) => QuizModel.fromJson(e))
.toList();

return quizzes;

} catch (e) {
throw Exception('حدث خطأ في جلب الاختبارات');
}
}

// Step 4: إرسال إجابات الطالب
Future<QuizResultModel> submitQuiz(
String quizId, String studentId, Map<String, String> answers) async {
try {
Response response = await _apiService.post('/quizzes/submit', data: {
'quiz_id': quizId,
'student_id': studentId,
'answers': answers,
});

return QuizResultModel.fromJson(response.data);

} catch (e) {
throw Exception('حدث خطأ في إرسال الإجابات');
}
}

// Step 5: جلب نتائج طالب معين
Future<List<QuizResultModel>> getResults(String studentId) async {
try {
Response response =
await _apiService.get('/quizzes/results/$studentId');

List<QuizResultModel> results = (response.data as List)
.map((e) => QuizResultModel.fromJson(e))
.toList();

return results;

} catch (e) {
throw Exception('حدث خطأ في جلب النتائج');
}
}
}