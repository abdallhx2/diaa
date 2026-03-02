// ============================================================
// File: parent_service.dart
// Purpose: خدمة ولي الأمر — جلب بيانات الأطفال والتقارير وإضافة طفل
// Owner: حياة — Integration Developer
// Branch: feature/flutter-services
// Week: 2 — خدمات بيانات ولي الأمر
// ============================================================

// --- Required Imports ---
// import 'package:edu_smart_assistant/services/api_service.dart';
// import 'package:edu_smart_assistant/models/student_model.dart';
// import 'package:edu_smart_assistant/models/report_model.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class ParentService
//         - class ParentService {
//             final ApiService _apiService = ApiService();
//           }

// Step 2: إنشاء method getChildren()
//         - // جلب قائمة أطفال ولي الأمر
//         - Response response = await _apiService.get('/parent/children');
//         - List<StudentModel> children = (response.data as List)
//             .map((e) => StudentModel.fromJson(e))
//             .toList();
//         - return children;
//         - // GET /api/parent/children

// Step 3: إنشاء method getReport(String childId)
//         - // جلب التقرير العام لطفل
//         - Response response = await _apiService.get('/parent/reports/$childId');
//         - return ReportModel.fromJson(response.data);
//         - // GET /api/parent/reports/{childId}

// Step 4: إنشاء method getWeeklyReport(String childId)
//         - // جلب التقرير الأسبوعي
//         - Response response = await _apiService.get('/parent/reports/$childId?period=weekly');
//         - return ReportModel.fromJson(response.data);

// Step 5: إنشاء method getMonthlyReport(String childId)
//         - // جلب التقرير الشهري
//         - Response response = await _apiService.get('/parent/reports/$childId?period=monthly');
//         - return ReportModel.fromJson(response.data);

// Step 6: إنشاء method addChild(Map<String, dynamic> data)
//         - // إضافة طفل جديد
//         - Response response = await _apiService.post('/auth/add-child', data: data);
//         - // data يحتوي: { name, age, grade, learning_level }
//         - return StudentModel.fromJson(response.data);
//         - // POST /api/auth/add-child — application/json

// --- Notes ---
// - جميع الـ endpoints تتطلب مصادقة (ولي الأمر المُوثق)
// - getChildren يجلب كل الأطفال المرتبطين بولي الأمر
// - التقارير تدعم فلترة بالفترة: weekly / monthly
// - addChild يُنشئ حساب طفل مرتبط بولي الأمر الحالي
// - السيرفر يحسب التقارير ويرسلها جاهزة
