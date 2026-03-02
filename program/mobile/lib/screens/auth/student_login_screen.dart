// ============================================================
// File: student_login_screen.dart
// Purpose: شاشة تسجيل دخول الطالب — البريد وكلمة المرور
// Owner: حياة — Integration Developer
// Branch: feature/flutter-services
// Week: 2 — شاشات المصادقة والتنقل
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:edu_smart_assistant/providers/auth_provider.dart';
// import 'package:edu_smart_assistant/config/routes.dart';
// import 'package:edu_smart_assistant/widgets/custom_text_field.dart';
// import 'package:edu_smart_assistant/widgets/custom_button.dart';
// import 'package:edu_smart_assistant/widgets/loading_widget.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatefulWidget باسم StudentLoginScreen
//         - class StudentLoginScreen extends StatefulWidget { ... }

// Step 2: تعريف المتغيرات
//         - final _formKey = GlobalKey<FormState>();
//         - final _emailController = TextEditingController();
//         - final _passwordController = TextEditingController();

// Step 3: بناء الواجهة
//         - Scaffold(
//             body: SafeArea(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.all(24),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(children: [
//                     // شعار التطبيق
//                     // Image.asset('assets/images/logo.png', height: 120),
//                     SizedBox(height: 32),
//
//                     Text('تسجيل دخول الطالب', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 32),
//
//                     // حقل البريد الإلكتروني
//                     CustomTextField(
//                       label: 'البريد الإلكتروني',
//                       hint: 'أدخل بريدك الإلكتروني',
//                       controller: _emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       prefixIcon: Icons.email,
//                       validator: (v) => !v!.contains('@') ? 'بريد إلكتروني غير صالح' : null,
//                     ),
//                     SizedBox(height: 16),
//
//                     // حقل كلمة المرور
//                     CustomTextField(
//                       label: 'كلمة المرور',
//                       hint: 'أدخل كلمة المرور',
//                       controller: _passwordController,
//                       obscureText: true,
//                       prefixIcon: Icons.lock,
//                       validator: (v) => v!.length < 6 ? 'كلمة المرور قصيرة جداً' : null,
//                     ),
//                     SizedBox(height: 24),
//
//                     // زر تسجيل الدخول
//                     Consumer<AuthProvider>(
//                       builder: (_, auth, __) => CustomButton(
//                         text: 'تسجيل الدخول',
//                         isLoading: auth.isLoading,
//                         onPressed: _login,
//                       ),
//                     ),
//                     SizedBox(height: 16),
//
//                     // رابط نسيت كلمة المرور
//                     TextButton(
//                       onPressed: _resetPassword,
//                       child: Text('نسيت كلمة المرور؟'),
//                     ),
//                   ]),
//                 ),
//               ),
//             ),
//           )

// Step 4: إنشاء method _login()
//         - إذا !_formKey.currentState!.validate(): return
//         - await context.read<AuthProvider>().login(
//             _emailController.text.trim(),
//             _passwordController.text,
//           );
//         - إذا نجح: Navigator.pushReplacementNamed(context, AppRoutes.studentDashboard)
//         - إذا فشل: عرض SnackBar مع رسالة الخطأ بالعربي

// Step 5: إنشاء method _resetPassword()
//         - عرض Dialog لإدخال البريد
//         - استدعاء AuthService().resetPassword(email)
//         - عرض "تم إرسال رابط إعادة تعيين كلمة المرور"

// Step 6: في dispose
//         - _emailController.dispose();
//         - _passwordController.dispose();

// --- Notes ---
// - التحقق من صحة البريد وكلمة المرور قبل الإرسال
// - كلمة المرور: حد أدنى 6 أحرف
// - عرض حالة التحميل أثناء تسجيل الدخول
// - رسائل الخطأ بالعربي: "البريد أو كلمة المرور غير صحيحة"
// - استخدام CustomTextField و CustomButton المخصصة
// - تسجيل الدخول يتم عبر Firebase Auth ثم API Backend
