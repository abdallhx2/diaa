// ============================================================
// File: scan_service.dart
// Purpose: خدمة المسح — استدعاء API لـ OCR و QR ورفع الملفات
// Owner: حياة — Integration Developer
// Branch: feature/flutter-services
// Week: 2 — خدمات المسح والاستخراج
// ============================================================

// --- Required Imports ---
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:edu_smart_assistant/services/api_service.dart';
// import 'package:edu_smart_assistant/models/lesson_model.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class ScanService
//         - class ScanService {
//             final ApiService _apiService = ApiService();
//           }

// Step 2: إنشاء method scanPage(File imageFile)
//         - // مسح صفحة بالكاميرا → OCR
//         - FormData formData = FormData.fromMap({
//             'image': await MultipartFile.fromFile(
//               imageFile.path,
//               filename: 'scan_${DateTime.now().millisecondsSinceEpoch}.jpg',
//             ),
//           });
//         - Response response = await _apiService.uploadFile('/scan/ocr', formData: formData);
//         - // الاستجابة تحتوي على: extracted_text + lesson data
//         - return LessonModel.fromJson(response.data);
//         - // POST /api/scan/ocr — multipart/form-data

// Step 3: إنشاء method scanQR(String lessonId)
//         - // مسح كود QR → جلب بيانات الدرس
//         - Response response = await _apiService.post('/scan/qr', data: {
//             'lesson_id': lessonId,
//           });
//         - return LessonModel.fromJson(response.data);
//         - // POST /api/scan/qr — application/json

// Step 4: إنشاء method uploadFile(File imageFile)
//         - // رفع صورة من المعرض → OCR
//         - FormData formData = FormData.fromMap({
//             'image': await MultipartFile.fromFile(
//               imageFile.path,
//               filename: 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
//             ),
//           });
//         - Response response = await _apiService.uploadFile('/scan/upload', formData: formData);
//         - return LessonModel.fromJson(response.data);
//         - // POST /api/scan/upload — multipart/form-data

// --- Notes ---
// - scanPage و uploadFile يرسلان الصورة كـ multipart/form-data
// - scanQR يرسل lesson_id فقط كـ JSON
// - جميع الدوال تعيد LessonModel مع النص المستخرج
// - الـ OCR يتم على السيرفر (ليس محلياً)
// - اسم الملف يحتوي timestamp لتجنب التكرار
// - في حالة الفشل: throw Exception مع رسالة عربية
