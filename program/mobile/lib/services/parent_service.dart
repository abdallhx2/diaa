import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:edu_smart_assistant/models/student_model.dart';
import 'package:edu_smart_assistant/models/report_model.dart';

class ParentService {
  final ApiService _apiService = ApiService();

  /// جلب قائمة أطفال ولي الأمر
  Future<List<StudentModel>> getChildren() async {
    try {
      final response = await _apiService.get('/parent/children');

      final data = response.data;
      if (data['success'] == true) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((e) => StudentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('فشل في جلب قائمة الأطفال');
    }
  }

  /// جلب التقرير العام لطفل
  Future<ReportModel> getReports(String childId) async {
    try {
      final response = await _apiService.get('/parent/reports/$childId');

      final data = response.data;
      if (data['success'] == true) {
        return ReportModel.fromJson(data['data']);
      }
      throw Exception(data['message'] ?? 'فشل في جلب التقرير');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل في جلب التقرير');
    }
  }

  /// جلب التقرير الأسبوعي لطفل
  Future<ReportModel> getWeeklyReport(String childId) async {
    try {
      final response =
          await _apiService.get('/parent/reports/$childId/weekly');

      final data = response.data;
      if (data['success'] == true) {
        return ReportModel.fromJson(data['data']);
      }
      throw Exception(data['message'] ?? 'فشل في جلب التقرير الأسبوعي');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل في جلب التقرير الأسبوعي');
    }
  }

  /// جلب التقرير الشهري لطفل
  Future<ReportModel> getMonthlyReport(String childId) async {
    try {
      final response =
          await _apiService.get('/parent/reports/$childId/monthly');

      final data = response.data;
      if (data['success'] == true) {
        return ReportModel.fromJson(data['data']);
      }
      throw Exception(data['message'] ?? 'فشل في جلب التقرير الشهري');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل في جلب التقرير الشهري');
    }
  }

  /// إضافة طفل جديد
  Future<StudentModel> addChild(Map<String, dynamic> data) async {
    try {
      final response =
          await _apiService.post('/auth/add-child', data: data);

      final responseData = response.data;
      if (responseData['success'] == true) {
        return StudentModel.fromJson(responseData['data']);
      }
      throw Exception(responseData['message'] ?? 'فشل في إضافة الطفل');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل في إضافة الطفل');
    }
  }
}
