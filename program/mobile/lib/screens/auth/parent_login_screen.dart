// ============================================================
// File: parent_login_screen.dart
// Purpose: شاشة تسجيل دخول ولي الأمر — مشابهة للطالب مع رابط التسجيل
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
// Step 1: إنشاء StatefulWidget باسم ParentLoginScreen
//         - class ParentLoginScreen extends StatefulWidget { ... }

// Step 2: تعريف المتغيرات (مشابهة لـ StudentLoginScreen)
//         - final _formKey = GlobalKey<FormState>();
//         - final _emailController = TextEditingController();
//         - final _passwordController = TextEditingController();

// Step 3: بناء الواجهة (مشابهة لـ StudentLoginScreen)
//         - نفس البنية مع تغييرات:
//           * العنوان: 'تسجيل دخول ولي الأمر'
//           * نفس حقول البريد وكلمة المرور
//           * زر "تسجيل الدخول"
//           * رابط "نسيت كلمة المرور؟"
//           * إضافة رابط: "إنشاء حساب جديد" → AppRoutes.parentRegister

// Step 4: إنشاء method _login()
//         - مشابه لـ StudentLoginScreen
//         - عند النجاح: Navigator.pushReplacementNamed(context, AppRoutes.parentDashboard)
//         - ملاحظة: role = 'parent' في استدعاء login

// Step 5: إضافة رابط إنشاء حساب جديد
//         - Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Text('ليس لديك حساب؟'),
//             TextButton(
//               onPressed: () => Navigator.pushNamed(context, AppRoutes.parentRegister),
//               child: Text('إنشاء حساب جديد'),
//             ),
//           ])

// Step 6: في dispose
//         - _emailController.dispose();
//         - _passwordController.dispose();

// --- Notes ---
// - مشابهة لشاشة تسجيل دخول الطالب مع إضافة رابط التسجيل
// - role = 'parent' للتمييز عن تسجيل دخول الطالب
// - عند النجاح: التوجيه للوحة ولي الأمر (ليس لوحة الطالب)
// - رابط "إنشاء حساب جديد" ينقل لشاشة التسجيل
