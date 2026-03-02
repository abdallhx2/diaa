// ============================================================
// File: report_card_widget.dart
// Purpose: بطاقة إحصائية — عرض رقم إحصائي مع عنوان وأيقونة
// Owner: رهف — UI Developer
// Branch: feature/flutter-parent
// Week: 2 — ويدجت التقارير
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatelessWidget باسم ReportCardWidget
//         - class ReportCardWidget extends StatelessWidget { ... }

// Step 2: تعريف الخصائص (Props)
//         - final String title;        // عنوان الإحصائية بالعربي (مثل: "الدروس المكتملة")
//         - final String value;        // القيمة (مثل: "15" أو "85%")
//         - final IconData icon;       // أيقونة (مثل: Icons.book)
//         - final Color color;         // لون البطاقة (مثل: primaryBlue)

// Step 3: إنشاء Constructor
//         - const ReportCardWidget({
//             required this.title,
//             required this.value,
//             required this.icon,
//             required this.color,
//           });

// Step 4: بناء بطاقة الإحصائية
//         - return Card(
//             elevation: 2,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // أيقونة في دائرة ملونة
//                   Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: color.withOpacity(0.15),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(icon, color: color, size: 28),
//                   ),
//                   SizedBox(height: 12),

//                   // القيمة بخط كبير وسميك
//                   Text(
//                     value,
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: color,
//                     ),
//                   ),
//                   SizedBox(height: 4),

//                   // العنوان
//                   Text(
//                     title,
//                     style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           );

// --- Notes ---
// - تصميم بسيط: أيقونة + قيمة كبيرة + عنوان
// - الأيقونة داخل دائرة بلون فاتح (opacity 0.15)
// - القيمة بخط كبير (24px) وسميك بنفس اللون
// - العنوان بخط صغير (14px) ورمادي
// - يُستخدم في parent_dashboard_screen.dart و reports_screen.dart
// - يمكن وضعه في GridView لعرض عدة بطاقات
// - حدود مستديرة (16px) مع ظل خفيف (elevation: 2)
