import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:edu_smart_assistant/models/lesson_model.dart';

class ScanService {
// Step 1: الاتصال بـ ApiService
final ApiService _apiService = ApiService();

// Step 2: مسح صفحة بالكاميرا
Future<LessonModel> scanPage(File imageFile) async {
try {
FormData formData = FormData.fromMap({
'image': await MultipartFile.fromFile(
imageFile.path,
filename: 'scan_${DateTime.now().millisecondsSinceEpoch}.jpg',
),
});

Response response =
await _apiService.uploadFile('/scan/ocr', formData: formData);

return LessonModel.fromJson(response.data);

} catch (e) {
throw Exception('حدث خطأ في مسح الصفحة');
}
}

// Step 3: مسح كود QR
Future<LessonModel> scanQR(String lessonId) async {
try {
Response response = await _apiService.post('/scan/qr', data: {
'lesson_id': lessonId,
});

return LessonModel.fromJson(response.data);

} catch (e) {
throw Exception('حدث خطأ في مسح الكود');
}
}

// Step 4: رفع صورة من المعرض
Future<LessonModel> uploadFile(File imageFile) async {
try {
FormData formData = FormData.fromMap({
'image': await MultipartFile.fromFile(
imageFile.path,
filename: 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
),
});

Response response =
await _apiService.uploadFile('/scan/upload', formData: formData);

return LessonModel.fromJson(response.data);

} catch (e) {
throw Exception('حدث خطأ في رفع الصورة');
}
}
}