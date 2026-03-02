// ============================================================
// File: student_service.dart
// Purpose: خدمة الطالب — جلب بيانات لوحة التحكم والجلسات والتقدم
// Owner: حياة — Integration Developer
// Branch: feature/flutter-services
// Week: 2 — خدمات بيانات الطالب
// ============================================================

// --- Required Imports ---
// import 'package:edu_smart_assistant/services/api_service.dart';
// import 'package:edu_smart_assistant/models/student_model.dart';
// import 'package:edu_smart_assistant/models/session_model.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class StudentService
//         - class StudentService {
//             final ApiService _apiService = ApiService();
//           }

// Step 2: إنشاء method getDashboard()
//         - // جلب بيانات لوحة تحكم الطالب
//         - Response response = await _apiService.get('/student/dashboard');
//         - return response.data;
//         - // GET /api/student/dashboard
//         - // Response: { "student": {...}, "recent_lessons": [...], "stats": {...} }

// Step 3: إنشاء method getSessions()
//         - // جلب قائمة جلسات التعلم
//         - Response response = await _apiService.get('/student/sessions');
//         - List<SessionModel> sessions = (response.data as List)
//             .map((e) => SessionModel.fromJson(e))
//             .toList();
//         - return sessions;
//         - // GET /api/student/sessions

// Step 4: إنشاء method getProgress()
//         - // جلب بيانات تقدم الطالب
//         - Response response = await _apiService.get('/student/progress');
//         - return response.data;
//         - // GET /api/student/progress
//         - // Response: { "total_lessons": 10, "completed": 7, "avg_score": 85.0, ... }

// --- Notes ---
// - جميع الـ endpoints تتطلب مصادقة (التوكن يُرسل تلقائياً من ApiService)
// - البيانات تُحدد بناءً على الطالب المُوثق (لا حاجة لتمرير student_id)
// - getDashboard يُستخدم في student_dashboard_screen.dart
// - getSessions يعرض تاريخ الجلسات (مسح/QR/رفع)
// - getProgress يُستخدم لعرض إحصائيات التقدم
