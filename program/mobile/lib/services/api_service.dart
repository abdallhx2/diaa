// ============================================================
// File: api_service.dart
// Purpose: إعداد Dio HTTP Client — الاتصال بالـ API مع التوثيق والتعامل مع الأخطاء
// Owner: حياة — Integration Developer
// Branch: feature/flutter-services
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:edu_smart_assistant/config/constants.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class ApiService (Singleton)
//         - class ApiService {
//             static final ApiService _instance = ApiService._internal();
//             factory ApiService() => _instance;
//             ApiService._internal();
//             late final Dio _dio;
//           }

// Step 2: تهيئة Dio مع الإعدادات الأساسية
//         - _dio = Dio(BaseOptions(
//             baseUrl: AppConstants.apiBaseUrl,  // 'http://localhost:8000/api'
//             connectTimeout: Duration(seconds: AppConstants.apiTimeoutSeconds),
//             receiveTimeout: Duration(seconds: AppConstants.apiTimeoutSeconds),
//             headers: {
//               'Content-Type': 'application/json',
//               'Accept': 'application/json',
//             },
//           ));

// Step 3: إضافة Interceptor لتوكن المصادقة
//         - _dio.interceptors.add(InterceptorsWrapper(
//             onRequest: (options, handler) async {
//               // الحصول على التوكن من Firebase Auth
//               final user = FirebaseAuth.instance.currentUser;
//               if (user != null) {
//                 final token = await user.getIdToken();
//                 options.headers['Authorization'] = 'Bearer $token';
//               }
//               handler.next(options);
//             },
//           ));

// Step 4: إضافة Interceptor للتعامل مع الأخطاء
//         - _dio.interceptors.add(InterceptorsWrapper(
//             onError: (DioException e, handler) {
//               // تحويل أخطاء الـ API لرسائل عربية واضحة
//               // 401: "الجلسة انتهت، سجل دخول مرة أخرى"
//               // 404: "العنصر غير موجود"
//               // 500: "حدث خطأ في السيرفر"
//               // timeout: "انتهت مهلة الاتصال"
//               // no internet: "لا يوجد اتصال بالإنترنت"
//               handler.next(e);
//             },
//           ));

// Step 5: إضافة Interceptor للتسجيل (Debug mode فقط)
//         - if (kDebugMode) {
//             _dio.interceptors.add(LogInterceptor(
//               requestBody: true,
//               responseBody: true,
//             ));
//           }

// Step 6: توفير دوال HTTP الأساسية
//         - Future<Response> get(String path, {Map<String, dynamic>? queryParams})
//         - Future<Response> post(String path, {dynamic data})
//         - Future<Response> put(String path, {dynamic data})
//         - Future<Response> delete(String path)
//         - Future<Response> uploadFile(String path, {required FormData formData})

// --- Notes ---
// - Singleton pattern لاستخدام instance واحد في كل التطبيق
// - التوكن يُجلب تلقائياً من Firebase Auth لكل طلب
// - الـ timeout هو 30 ثانية (من constants.dart)
// - Content-Type: application/json لكل الطلبات (عدا رفع الملفات)
// - رفع الملفات يستخدم FormData مع multipart
// - تسجيل الطلبات فقط في debug mode
