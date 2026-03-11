import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:edu_smart_assistant/config/constants.dart';

class ApiService {
static final ApiService _instance = ApiService._internal();
factory ApiService() => _instance;
ApiService._internal() {
_init();
}

late final Dio _dio;

void _init() {
_dio = Dio(BaseOptions(
baseUrl: AppConstants.apiBaseUrl,
connectTimeout: Duration(seconds: AppConstants.apiTimeoutSeconds),
receiveTimeout: Duration(seconds: AppConstants.apiTimeoutSeconds),
headers: {
'Content-Type': 'application/json',
'Accept': 'application/json',
},
));

_dio.interceptors.add(InterceptorsWrapper(
onRequest: (options, handler) async {
final user = FirebaseAuth.instance.currentUser;
if (user != null) {
final token = await user.getIdToken();
options.headers['Authorization'] = 'Bearer $token';
}
handler.next(options);
},
));

_dio.interceptors.add(InterceptorsWrapper(
onError: (DioException e, handler) {
String message;
switch (e.response?.statusCode) {
case 401:
message = 'الجلسة انتهت، سجل دخول مرة أخرى';
break;
case 404:
message = 'العنصر غير موجود';
break;
case 500:
message = 'حدث خطأ في السيرفر';
break;
default:
if (e.type == DioExceptionType.connectionTimeout) {
message = 'انتهت مهلة الاتصال';
} else if (e.type == DioExceptionType.unknown) {
message = 'لا يوجد اتصال بالإنترنت';
} else {
message = 'حدث خطأ غير متوقع';
}
}
print(message);
handler.next(e);
},
));

if (kDebugMode) {
_dio.interceptors.add(LogInterceptor(
requestBody: true,
responseBody: true,
));
}
}

Future<Response> get(String path,
{Map<String, dynamic>? queryParams}) async {
return await _dio.get(path, queryParameters: queryParams);
}

Future<Response> post(String path, {dynamic data}) async {
return await _dio.post(path, data: data);
}

Future<Response> put(String path, {dynamic data}) async {
return await _dio.put(path, data: data);
}

Future<Response> delete(String path) async {
return await _dio.delete(path);
}

Future<Response> uploadFile(String path,
{required FormData formData}) async {
return await _dio.post(path, data: formData);
}
}