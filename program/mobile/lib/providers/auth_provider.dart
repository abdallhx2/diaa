// ============================================================
// File: auth_provider.dart
// Purpose: إدارة حالة المصادقة — تسجيل دخول/خروج، حفظ الجلسة
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 1-2 — إعداد البنية الأساسية + شاشات المصادقة
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:edu_smart_assistant/models/user_model.dart';
// import 'package:edu_smart_assistant/services/auth_service.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class AuthProvider extends ChangeNotifier
//         - class AuthProvider extends ChangeNotifier { ... }

// Step 2: تعريف الحقول (Fields)
//         - UserModel? _currentUser;          // المستخدم الحالي
//         - bool _isLoading = false;           // حالة التحميل
//         - bool _isAuthenticated = false;     // هل المستخدم مسجل دخول؟
//         - String? _userRole;                 // دور المستخدم: 'student' / 'parent'
//         - String? _errorMessage;             // رسالة الخطأ
//         - final AuthService _authService = AuthService();

// Step 3: إنشاء Getters
//         - UserModel? get currentUser => _currentUser;
//         - bool get isLoading => _isLoading;
//         - bool get isAuthenticated => _isAuthenticated;
//         - String? get userRole => _userRole;
//         - String? get errorMessage => _errorMessage;

// Step 4: إنشاء method login(String email, String password)
//         - تعيين _isLoading = true و notifyListeners()
//         - استدعاء _authService.signInWithEmail(email, password)
//         - عند النجاح: تعيين _currentUser, _isAuthenticated = true, _userRole
//         - حفظ حالة المصادقة في SharedPreferences
//         - عند الفشل: تعيين _errorMessage بالعربي
//         - تعيين _isLoading = false و notifyListeners()

// Step 5: إنشاء method logout()
//         - استدعاء _authService.signOut()
//         - تصفير جميع الحقول
//         - حذف حالة المصادقة من SharedPreferences
//         - notifyListeners()

// Step 6: إنشاء method checkAuthState()
//         - قراءة SharedPreferences لمعرفة هل المستخدم كان مسجل دخول
//         - إذا نعم: استدعاء _authService.getCurrentUser() لتحديث البيانات
//         - تحديث _isAuthenticated و _userRole
//         - يستخدم في splash_screen لتحديد الشاشة التالية

// Step 7: إنشاء method registerParent(Map<String, dynamic> data)
//         - تعيين _isLoading = true
//         - استدعاء _authService.registerWithEmail(email, password, name, phone)
//         - عند النجاح: تعيين _currentUser, _isAuthenticated = true
//         - عند الفشل: تعيين _errorMessage

// --- Notes ---
// - جميع رسائل الأخطاء يجب أن تكون بالعربي
// - SharedPreferences يحفظ: isLoggedIn (bool), userRole (String), userId (String)
// - notifyListeners() يجب استدعاؤها بعد كل تغيير في الحالة
// - يجب مسح _errorMessage قبل كل عملية جديدة
// - التعامل مع أخطاء Firebase Auth: wrong-password, user-not-found, email-already-in-use
