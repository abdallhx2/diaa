// ============================================================
// File: loading_widget.dart
// Purpose: مؤشر تحميل — عرض دائرة التحميل مع رسالة اختيارية بالعربي
// Owner: رهف — UI Developer
// Branch: feature/flutter-parent
// Week: 1 — إعداد الـ Widgets الأساسية
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:edu_smart_assistant/config/theme.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatelessWidget باسم LoadingWidget
//         - class LoadingWidget extends StatelessWidget { ... }

// Step 2: تعريف الخصائص (Props)
//         - final String? message;    // رسالة اختيارية (مثل: "جاري التحميل...")

// Step 3: إنشاء Constructor
//         - const LoadingWidget({this.message});

// Step 4: بناء مؤشر التحميل
//         - return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // دائرة التحميل
//                 CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation(AppTheme.primaryBlue),
//                   strokeWidth: 3,
//                 ),
//                 // رسالة اختيارية
//                 if (message != null) ...[
//                   SizedBox(height: 16),
//                   Text(
//                     message!,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[600],
//                     ),
//                     textDirection: TextDirection.rtl,
//                   ),
//                 ],
//               ],
//             ),
//           );

// --- Notes ---
// - بسيط وقابل لإعادة الاستخدام في أي مكان
// - الرسالة اختيارية — إذا null يعرض الدائرة فقط
// - أمثلة على الرسائل:
//   * "جاري التحميل..."
//   * "جاري استخراج النص..."
//   * "جاري إرسال الإجابات..."
//   * "جاري التفكير..." (في المحادثة)
// - يُستخدم في كل شاشات التطبيق أثناء العمليات الطويلة
// - MainAxisSize.min لأخذ الحد الأدنى من المساحة
