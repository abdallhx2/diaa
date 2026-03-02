// ============================================================
// File: custom_button.dart
// Purpose: زر مخصص قابل لإعادة الاستخدام — تصميم موحد في كل التطبيق
// Owner: رهف — UI Developer
// Branch: feature/flutter-parent
// Week: 1 — إعداد الـ Widgets الأساسية
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:edu_smart_assistant/config/theme.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatelessWidget باسم CustomButton
//         - class CustomButton extends StatelessWidget { ... }

// Step 2: تعريف الخصائص (Props)
//         - final String text;              // نص الزر بالعربي
//         - final VoidCallback? onPressed;   // دالة عند الضغط
//         - final Color? color;              // لون الزر (افتراضي: primaryBlue)
//         - final bool isLoading;            // هل في حالة تحميل؟
//         - final IconData? icon;            // أيقونة اختيارية

// Step 3: إنشاء Constructor
//         - const CustomButton({
//             required this.text,
//             required this.onPressed,
//             this.color,
//             this.isLoading = false,
//             this.icon,
//           });

// Step 4: بناء الزر
//         - return ElevatedButton(
//             onPressed: isLoading ? null : onPressed,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: color ?? AppTheme.primaryBlue,
//               foregroundColor: Colors.white,
//               minimumSize: Size(double.infinity, 48),  // عرض كامل، ارتفاع 48dp
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 2,
//             ),
//             child: isLoading
//               ? SizedBox(
//                   height: 24, width: 24,
//                   child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//                 )
//               : Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (icon != null) ...[
//                       Icon(icon, size: 20),
//                       SizedBox(width: 8),
//                     ],
//                     Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//                   ],
//                 ),
//           );

// --- Notes ---
// - الحد الأدنى للارتفاع 48dp (سهولة اللمس للأطفال)
// - عند isLoading = true: يعرض CircularProgressIndicator ويعطل الضغط
// - ألوان باستيل ناعمة مع نص أبيض
// - حدود مستديرة (borderRadius: 12)
// - خط عربي بحجم 18 وسمك w600
// - يمكن إضافة أيقونة اختياريةBeside النص
// - يُستخدم في جميع شاشات التطبيق
