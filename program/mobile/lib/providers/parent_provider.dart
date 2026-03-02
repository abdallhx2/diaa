// ============================================================
// File: parent_provider.dart
// Purpose: إدارة حالة ولي الأمر — الأطفال، التقارير، الإحصائيات
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 2-3 — شاشات ولي الأمر والتقارير
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:edu_smart_assistant/models/student_model.dart';
// import 'package:edu_smart_assistant/models/report_model.dart';
// import 'package:edu_smart_assistant/services/parent_service.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class ParentProvider extends ChangeNotifier
//         - class ParentProvider extends ChangeNotifier { ... }

// Step 2: تعريف الحقول (Fields)
//         - List<StudentModel> _children = [];       // قائمة الأطفال
//         - StudentModel? _selectedChild;             // الطفل المختار حالياً
//         - ReportModel? _weeklyReport;               // التقرير الأسبوعي
//         - ReportModel? _monthlyReport;              // التقرير الشهري
//         - bool _isLoading = false;
//         - String? _errorMessage;
//         - final ParentService _parentService = ParentService();

// Step 3: إنشاء Getters
//         - List<StudentModel> get children => _children;
//         - StudentModel? get selectedChild => _selectedChild;
//         - ReportModel? get weeklyReport => _weeklyReport;
//         - ReportModel? get monthlyReport => _monthlyReport;
//         - bool get isLoading => _isLoading;
//         - bool get hasChildren => _children.isNotEmpty;

// Step 4: إنشاء method fetchChildren()
//         - _isLoading = true; notifyListeners();
//         - استدعاء _parentService.getChildren()
//         - _children = القائمة المُرجعة
//         - إذا _children.isNotEmpty: _selectedChild = _children.first;
//         - _isLoading = false; notifyListeners();

// Step 5: إنشاء method selectChild(StudentModel child)
//         - _selectedChild = child;
//         - notifyListeners();
//         - يمكن استدعاء fetchReport تلقائياً بعد التحديد

// Step 6: إنشاء method fetchReport(String childId, String type)
//         - type يكون 'weekly' أو 'monthly'
//         - استدعاء _parentService.getWeeklyReport(childId) أو getMonthlyReport(childId)
//         - تعيين _weeklyReport أو _monthlyReport
//         - notifyListeners();

// Step 7: إنشاء method addChild(Map<String, dynamic> data)
//         - _isLoading = true; notifyListeners();
//         - استدعاء _parentService.addChild(data)
//         - عند النجاح: إضافة الطفل الجديد لـ _children
//         - عند الفشل: تعيين _errorMessage
//         - _isLoading = false; notifyListeners();

// --- Notes ---
// - يُستخدم في: parent_dashboard_screen, add_child_screen, reports_screen
// - fetchChildren() يُستدعى عند فتح لوحة ولي الأمر
// - إذا لم يكن هناك أطفال: عرض زر "أضف طفلك الأول"
// - selectedChild يتغير عبر dropdown في لوحة ولي الأمر
// - التقارير تُحدث عند تغيير الطفل المحدد أو نوع التقرير
