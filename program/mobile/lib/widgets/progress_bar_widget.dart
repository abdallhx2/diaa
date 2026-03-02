// ============================================================
// File: progress_bar_widget.dart
// Purpose: شريط تقدم — عرض نسبة الإنجاز مع عنوان ونسبة مئوية
// Owner: رهف — UI Developer
// Branch: feature/flutter-parent
// Week: 1 — إعداد الـ Widgets الأساسية
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:edu_smart_assistant/config/theme.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatelessWidget باسم ProgressBarWidget
//         - class ProgressBarWidget extends StatelessWidget { ... }

// Step 2: تعريف الخصائص (Props)
//         - final double progress;     // نسبة التقدم (0.0 - 1.0)
//         - final String label;        // عنوان الشريط بالعربي
//         - final Color? color;        // لون الشريط (افتراضي: primaryBlue)

// Step 3: إنشاء Constructor
//         - const ProgressBarWidget({
//             required this.progress,
//             required this.label,
//             this.color,
//           });

// Step 4: بناء الشريط
//         - return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // صف العنوان والنسبة
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                   Text('${(progress * 100).round()}%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               SizedBox(height: 8),
//               // شريط التقدم
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: LinearProgressIndicator(
//                   value: progress.clamp(0.0, 1.0),
//                   minHeight: 12,                        // ارتفاع مناسب
//                   backgroundColor: Colors.grey[200],
//                   valueColor: AlwaysStoppedAnimation(color ?? AppTheme.primaryBlue),
//                 ),
//               ),
//             ],
//           );

// --- Notes ---
// - progress يكون بين 0.0 و 1.0 (يتم clamp لمنع القيم الخاطئة)
// - يعرض: العنوان على اليمين (RTL)، النسبة على اليسار
// - ارتفاع الشريط 12px (مرئي وواضح)
// - حدود مستديرة (8px) للشريط
// - يُستخدم في: شاشة الاختبارات (تقدم الأسئلة) ولوحة ولي الأمر (تقدم الطفل)
