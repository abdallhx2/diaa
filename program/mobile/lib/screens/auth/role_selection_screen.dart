// ============================================================
// File: role_selection_screen.dart
// Purpose: شاشة اختيار الدور — طالب أو ولي أمر
// Owner: حياة — Integration Developer
// Branch: feature/flutter-services
// Week: 2 — شاشات المصادقة والتنقل
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:edu_smart_assistant/config/routes.dart';
// import 'package:edu_smart_assistant/config/theme.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatelessWidget باسم RoleSelectionScreen
//         - class RoleSelectionScreen extends StatelessWidget { ... }

// Step 2: بناء الواجهة
//         - Scaffold(
//             body: SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.all(24),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // عنوان
//                     Text('من أنت؟', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 48),
//                     // بطاقات الاختيار
//                     _buildRoleCard(...),
//                     _buildRoleCard(...),
//                   ],
//                 ),
//               ),
//             ),
//           )

// Step 3: إنشاء بطاقة "طالب"
//         - _buildRoleCard(
//             icon: Icons.school,
//             title: 'طالب',
//             description: 'تعلم واستكشف دروسك',
//             color: AppTheme.primaryBlue,
//             onTap: () => Navigator.pushNamed(context, AppRoutes.studentLogin),
//           )

// Step 4: إنشاء بطاقة "ولي أمر"
//         - _buildRoleCard(
//             icon: Icons.family_restroom,
//             title: 'ولي أمر',
//             description: 'تابع تقدم طفلك',
//             color: AppTheme.primaryGreen,
//             onTap: () => Navigator.pushNamed(context, AppRoutes.parentLogin),
//           )

// Step 5: إنشاء method _buildRoleCard(...)
//         - Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             child: InkWell(
//               onTap: onTap,
//               borderRadius: BorderRadius.circular(16),
//               child: Padding(
//                 padding: EdgeInsets.all(24),
//                 child: Row(children: [
//                   Icon(icon, size: 64, color: color),
//                   SizedBox(width: 16),
//                   Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                     Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                     Text(description, style: TextStyle(fontSize: 16, color: Colors.grey)),
//                   ]),
//                 ]),
//               ),
//             ),
//           )

// --- Notes ---
// - تصميم مناسب للأطفال: أيقونات كبيرة، نصوص واضحة، ألوان باستيل
// - بطاقتين فقط: طالب وولي أمر
// - RTL: الأيقونة على اليمين والنص على اليسار
// - عند اختيار "ولي أمر": شاشة تسجيل الدخول مع خيار التسجيل
// - تصميم بسيط وسهل الاستخدام
