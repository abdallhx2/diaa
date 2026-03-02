// ============================================================
// File: parent_register_screen.dart
// Purpose: شاشة تسجيل ولي أمر جديد — إنشاء حساب بـ Firebase Auth + Backend
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

// --- Implementation Steps ---
// Step 1: إنشاء StatefulWidget باسم ParentRegisterScreen
//         - class ParentRegisterScreen extends StatefulWidget { ... }

// Step 2: تعريف المتغيرات
//         - final _formKey = GlobalKey<FormState>();
//         - final _nameController = TextEditingController();
//         - final _emailController = TextEditingController();
//         - final _passwordController = TextEditingController();
//         - final _confirmPasswordController = TextEditingController();
//         - final _phoneController = TextEditingController();

// Step 3: بناء Form مع الحقول
//         - Scaffold(
//             appBar: AppBar(title: Text('إنشاء حساب جديد')),
//             body: SingleChildScrollView(
//               padding: EdgeInsets.all(24),
//               child: Form(key: _formKey, child: Column([
//                 // حقل الاسم الكامل
//                 CustomTextField(
//                   label: 'الاسم الكامل',
//                   hint: 'أدخل اسمك الكامل',
//                   controller: _nameController,
//                   prefixIcon: Icons.person,
//                   validator: (v) => v!.isEmpty ? 'الاسم مطلوب' : null,
//                 ),
//                 // حقل البريد الإلكتروني
//                 CustomTextField(
//                   label: 'البريد الإلكتروني',
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   prefixIcon: Icons.email,
//                   validator: (v) => !v!.contains('@') ? 'بريد غير صالح' : null,
//                 ),
//                 // حقل كلمة المرور
//                 CustomTextField(
//                   label: 'كلمة المرور',
//                   controller: _passwordController,
//                   obscureText: true,
//                   prefixIcon: Icons.lock,
//                   validator: (v) => v!.length < 6 ? 'يجب 6 أحرف على الأقل' : null,
//                 ),
//                 // حقل تأكيد كلمة المرور
//                 CustomTextField(
//                   label: 'تأكيد كلمة المرور',
//                   controller: _confirmPasswordController,
//                   obscureText: true,
//                   prefixIcon: Icons.lock_outline,
//                   validator: (v) => v != _passwordController.text ? 'كلمات المرور غير متطابقة' : null,
//                 ),
//                 // حقل رقم الهاتف
//                 CustomTextField(
//                   label: 'رقم الهاتف',
//                   controller: _phoneController,
//                   keyboardType: TextInputType.phone,
//                   prefixIcon: Icons.phone,
//                   validator: (v) => v!.length < 10 ? 'رقم هاتف غير صالح' : null,
//                 ),
//                 SizedBox(height: 24),
//                 // زر التسجيل
//                 Consumer<AuthProvider>(
//                   builder: (_, auth, __) => CustomButton(
//                     text: 'إنشاء الحساب',
//                     isLoading: auth.isLoading,
//                     onPressed: _register,
//                   ),
//                 ),
//                 // رابط تسجيل الدخول
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('لديك حساب؟ تسجيل دخول'),
//                 ),
//               ])),
//             ),
//           )

// Step 4: إنشاء method _register()
//         - إذا !_formKey.currentState!.validate(): return
//         - data = { name, email, password, phone }
//         - await context.read<AuthProvider>().registerParent(data)
//         - عند النجاح:
//           * Firebase Auth يُنشئ الحساب
//           * Backend يُنشئ سجل ولي الأمر
//           * Navigator.pushReplacementNamed(context, AppRoutes.parentDashboard)
//         - عند الفشل:
//           * عرض رسالة خطأ بالعربي

// Step 5: Validation Rules (قواعد التحقق)
//         - الاسم: مطلوب، غير فارغ
//         - البريد: يحتوي @ وصيغة صحيحة
//         - كلمة المرور: 6 أحرف على الأقل
//         - تأكيد كلمة المرور: يطابق كلمة المرور
//         - الهاتف: 10 أرقام على الأقل

// Step 6: في dispose
//         - التخلص من جميع الـ Controllers

// --- Notes ---
// - التسجيل يتم على خطوتين: 1) Firebase Auth 2) Backend API
// - Firebase Auth يُنشئ حساب المصادقة
// - Backend API يُنشئ سجل ولي الأمر في قاعدة البيانات
// - رسائل الأخطاء بالعربي: "البريد مستخدم بالفعل"، "كلمة المرور ضعيفة"
// - رابط "لديك حساب؟" يعود لشاشة تسجيل الدخول
