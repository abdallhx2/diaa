// ============================================================
// File: custom_text_field.dart
// Purpose: حقل نص مخصص — تصميم RTL موحد مع validation
// Owner: رهف — UI Developer
// Branch: feature/flutter-parent
// Week: 1 — إعداد الـ Widgets الأساسية
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatelessWidget باسم CustomTextField
//         - class CustomTextField extends StatelessWidget { ... }

// Step 2: تعريف الخصائص (Props)
//         - final String label;                           // عنوان الحقل بالعربي
//         - final String? hint;                            // نص توضيحي
//         - final TextEditingController controller;        // متحكم النص
//         - final bool obscureText;                        // إخفاء النص (كلمة المرور)
//         - final TextInputType? keyboardType;             // نوع لوحة المفاتيح
//         - final String? Function(String?)? validator;    // دالة التحقق
//         - final IconData? prefixIcon;                    // أيقونة في البداية

// Step 3: إنشاء Constructor
//         - const CustomTextField({
//             required this.label,
//             this.hint,
//             required this.controller,
//             this.obscureText = false,
//             this.keyboardType,
//             this.validator,
//             this.prefixIcon,
//           });

// Step 4: بناء حقل النص
//         - return TextFormField(
//             controller: controller,
//             obscureText: obscureText,
//             keyboardType: keyboardType,
//             validator: validator,
//             textDirection: TextDirection.rtl,    // RTL للعربية
//             style: TextStyle(fontSize: 18),       // خط كبير للأطفال
//             decoration: InputDecoration(
//               labelText: label,
//               hintText: hint,
//               prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               errorStyle: TextStyle(fontSize: 14),  // رسالة الخطأ
//             ),
//           );

// --- Notes ---
// - RTL: اتجاه النص من اليمين لليسار
// - حدود مستديرة (borderRadius: 12)
// - خط كبير (18px) مناسب للأطفال
// - prefixIcon تظهر على اليمين في RTL (الأيقونة قبل النص)
// - validator يعيد null إذا صحيح أو رسالة خطأ بالعربي إذا غير صحيح
// - obscureText = true لحقول كلمة المرور
// - يُستخدم في شاشات المصادقة وإضافة طفل
