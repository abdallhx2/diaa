import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:edu_smart_assistant/models/lesson_model.dart';

class ScanService {
  final ApiService _apiService = ApiService();

  /// مسح صفحة بالكاميرا — إرسال صورة لاستخراج النص بـ OCR
  /// Backend يعيد: { extracted_text: string }
  Future<String> sendImageForOcr(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'scan_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      final response = await _apiService.uploadFile(
        '/scan/ocr',
        formData: formData,
      );

      final data = response.data;
      if (data['success'] == true) {
        return data['data']['extracted_text'] ?? '';
      }
      throw Exception(data['message'] ?? 'فشل في استخراج النص من الصورة');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل في استخراج النص من الصورة');
    }
  }

  /// مسح كود QR — إرسال بيانات QR لجلب الدرس
  /// Backend يعيد: LessonModel (id, title, subject, grade_level, original_text, audio_url)
  Future<LessonModel> sendQrData(String qrData) async {
    try {
      final response = await _apiService.post('/scan/qr', data: {
        'qr_code': qrData,
      });

      final data = response.data;
      if (data['success'] == true) {
        return LessonModel.fromJson(data['data']);
      }
      throw Exception(data['message'] ?? 'فشل في جلب بيانات الدرس');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل في جلب بيانات الدرس من كود QR');
    }
  }

  /// رفع ملف/صورة — إرسال صورة من المعرض لاستخراج النص
  /// Backend يعيد: { extracted_text: string }
  Future<String> uploadFile(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      final response = await _apiService.uploadFile(
        '/scan/upload',
        formData: formData,
      );

      final data = response.data;
      if (data['success'] == true) {
        return data['data']['extracted_text'] ?? '';
      }
      throw Exception(data['message'] ?? 'فشل في رفع الملف');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('فشل في رفع الملف واستخراج النص');
    }
  }
}
