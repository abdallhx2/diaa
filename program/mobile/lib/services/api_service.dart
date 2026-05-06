import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:edu_smart_assistant/config/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;

  /// اختيار الرابط المناسب حسب المنصة
  static String get _baseUrl {
    if (kIsWeb) {
      return AppConstants.webBaseUrl;
    }
    return AppConstants.apiBaseUrl;
  }

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout:
          const Duration(seconds: AppConstants.apiTimeoutSeconds),
      receiveTimeout:
          const Duration(seconds: AppConstants.apiTimeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Interceptor للمصادقة — إضافة توكن Firebase تلقائياً
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (DioException e, handler) {
        handler.next(e);
      },
    ));

    // تسجيل الطلبات في وضع التطوير فقط
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  /// الحصول على توكن Firebase Auth
  Future<String?> _getToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return await user.getIdToken();
      }
    } catch (_) {
      // Firebase غير متاح
    }
    return null;
  }

  /// طلب GET
  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// طلب POST
  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// طلب PUT
  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// طلب DELETE
  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// رفع ملف باستخدام FormData
  Future<Response> uploadFile(String path,
      {required FormData formData}) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// تحويل أخطاء Dio لرسائل عربية
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('انتهت مهلة الاتصال، حاول مرة أخرى');
      case DioExceptionType.connectionError:
        return Exception('لا يوجد اتصال بالإنترنت');
      case DioExceptionType.badResponse:
        return _handleStatusCode(e.response?.statusCode);
      default:
        return Exception('حدث خطأ غير متوقع');
    }
  }

  Exception _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return Exception('طلب غير صحيح');
      case 401:
        return Exception('الجلسة انتهت، سجل دخول مرة أخرى');
      case 403:
        return Exception('ليس لديك صلاحية للوصول');
      case 404:
        return Exception('العنصر غير موجود');
      case 422:
        return Exception('البيانات المدخلة غير صحيحة');
      case 500:
        return Exception('حدث خطأ في السيرفر');
      default:
        return Exception('حدث خطأ غير متوقع');
    }
  }
}
