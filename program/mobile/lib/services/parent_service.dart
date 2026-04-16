import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:edu_smart_assistant/models/student_model.dart';
import 'package:edu_smart_assistant/models/report_model.dart';
import 'package:dio/dio.dart';

class ParentService {
// Step 1: الاتصال بـ ApiService
final ApiService _apiService = ApiService();

// Step 2: جلب قائمة الأطفال
Future<List<StudentModel>> getChildren() async {
try {
Response response = await _apiService.get('/parent/children');

List<StudentModel> children = (response.data as List)
.map((e) => StudentModel.fromJson(e))
.toList();

return children;

} catch (e) {
throw Exception('حدث خطأ في جلب بيانات الأطفال');
}
}

// Step 3: التقرير العام
Future<ReportModel> getReport(String childId) async {
try {
Response response =
await _apiService.get('/parent/reports/$childId');

return ReportModel.fromJson(response.data);

} catch (e) {
throw Exception('حدث خطأ في جلب التقرير');
}
}

// Step 4: التقرير الأسبوعي
Future<ReportModel> getWeeklyReport(String childId) async {
try {
Response response = await _apiService.get(
'/parent/reports/$childId',
queryParams: {'period': 'weekly'});

return ReportModel.fromJson(response.data);

} catch (e) {
throw Exception('حدث خطأ في جلب التقرير الأسبوعي');
}
}

// Step 5: التقرير الشهري
Future<ReportModel> getMonthlyReport(String childId) async {
try {
Response response = await _apiService.get(
'/parent/reports/$childId',
queryParams: {'period': 'monthly'});

return ReportModel.fromJson(response.data);

} catch (e) {
throw Exception('حدث خطأ في جلب التقرير الشهري');
}
}

// Step 6: إضافة طفل جديد
Future<StudentModel> addChild(Map<String, dynamic> data) async {
try {
Response response =
await _apiService.post('/auth/add-child', data: data);

return StudentModel.fromJson(response.data);

} catch (e) {
throw Exception('حدث خطأ في إضافة الطفل');
}
}
}
