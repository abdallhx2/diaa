// ============================================================
// File: student_dashboard_screen.dart
// Purpose: الشاشة الرئيسية للطالب — 4 أزرار كبيرة للتنقل
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 2 — شاشات الطالب الأساسية
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:edu_smart_assistant/providers/auth_provider.dart';
// import 'package:edu_smart_assistant/providers/student_provider.dart';
// import 'package:edu_smart_assistant/config/routes.dart';
// import 'package:edu_smart_assistant/config/theme.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatefulWidget باسم StudentDashboardScreen
//         - class StudentDashboardScreen extends StatefulWidget { ... }

// Step 2: في initState — تحميل بيانات الطالب
//         - context.read<StudentProvider>().fetchDashboard();

// Step 3: بناء Scaffold مع AppBar
//         - AppBar(
//             title: Text('مرحباً ${studentName}'),  // عرض اسم الطالب
//             actions: [
//               IconButton(icon: Icon(Icons.logout), onPressed: logout),
//             ],
//           )

// Step 4: بناء GridView مع 4 بطاقات كبيرة
//         - GridView.count(
//             crossAxisCount: 2,    // عمودين
//             padding: EdgeInsets.all(16),
//             mainAxisSpacing: 16,
//             crossAxisSpacing: 16,
//             children: [
//               // بطاقة 1: مسح صفحة
//               _buildDashboardCard(
//                 title: 'مسح صفحة',
//                 icon: Icons.camera_alt,
//                 color: AppTheme.primaryBlue,      // أزرق
//                 onTap: () => Navigator.pushNamed(context, AppRoutes.scanPage),
//               ),
//               // بطاقة 2: مسح QR
//               _buildDashboardCard(
//                 title: 'مسح QR',
//                 icon: Icons.qr_code_scanner,
//                 color: AppTheme.primaryGreen,     // أخضر
//                 onTap: () => Navigator.pushNamed(context, AppRoutes.scanQR),
//               ),
//               // بطاقة 3: رفع ملف
//               _buildDashboardCard(
//                 title: 'رفع ملف',
//                 icon: Icons.upload_file,
//                 color: AppTheme.primaryOrange,    // برتقالي
//                 onTap: () => Navigator.pushNamed(context, AppRoutes.uploadFile),
//               ),
//               // بطاقة 4: حل اختبار
//               _buildDashboardCard(
//                 title: 'حل اختبار',
//                 icon: Icons.quiz,
//                 color: Color(0xFF9C27B0),         // بنفسجي ناعم
//                 onTap: () => Navigator.pushNamed(context, AppRoutes.quizSelection),
//               ),
//             ],
//           )

// Step 5: إنشاء method _buildDashboardCard(...)
//         - return Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             child: InkWell(
//               onTap: onTap,
//               borderRadius: BorderRadius.circular(16),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(icon, size: 64, color: color),   // أيقونة كبيرة 64px
//                   SizedBox(height: 12),
//                   Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//             ),
//           );

// Step 6: إنشاء method logout
//         - context.read<AuthProvider>().logout();
//         - Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);

// --- Notes ---
// - التصميم مناسب للأطفال: أيقونات كبيرة 64px، نصوص كبيرة 20px
// - ألوان باستيل مختلفة لكل بطاقة
// - الأزرار يجب أن تكون سهلة اللمس (minimum 48dp)
// - RTL: النصوص والأيقونات من اليمين لليسار
// - زر تسجيل الخروج في AppBar
