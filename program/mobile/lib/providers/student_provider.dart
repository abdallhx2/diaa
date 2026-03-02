// ============================================================
// File: student_provider.dart
// Purpose: إدارة حالة الطالب — بيانات لوحة التحكم والجلسات والتقدم
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 2 — شاشات الطالب الأساسية
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:edu_smart_assistant/models/student_model.dart';
// import 'package:edu_smart_assistant/models/session_model.dart';
// import 'package:edu_smart_assistant/services/student_service.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class StudentProvider extends ChangeNotifier
//         - class StudentProvider extends ChangeNotifier { ... }

// Step 2: تعريف الحقول (Fields)
//         - StudentModel? _studentData;              // بيانات الطالب
//         - List<SessionModel> _sessions = [];        // قائمة الجلسات
//         - Map<String, dynamic>? _progress;          // بيانات التقدم
//         - bool _isLoading = false;
//         - String? _errorMessage;
//         - final StudentService _studentService = StudentService();

// Step 3: إنشاء Getters
//         - StudentModel? get studentData => _studentData;
//         - List<SessionModel> get sessions => _sessions;
//         - Map<String, dynamic>? get progress => _progress;
//         - bool get isLoading => _isLoading;

// Step 4: إنشاء method fetchDashboard()
//         - _isLoading = true; notifyListeners();
//         - استدعاء _studentService.getDashboard()
//         - تعيين _studentData من الاستجابة
//         - _isLoading = false; notifyListeners();

// Step 5: إنشاء method fetchSessions()
//         - استدعاء _studentService.getSessions()
//         - تعيين _sessions = قائمة SessionModel من الاستجابة

// Step 6: إنشاء method fetchProgress()
//         - استدعاء _studentService.getProgress()
//         - تعيين _progress = بيانات التقدم

// --- Notes ---
// - يستخدم في student_dashboard_screen.dart
// - fetchDashboard() يُستدعى عند فتح لوحة الطالب
// - الجلسات تعرض تاريخ تعلم الطالب
// - التقدم يعرض الأداء العام
