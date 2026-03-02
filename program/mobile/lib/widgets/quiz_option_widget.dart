// ============================================================
// File: quiz_option_widget.dart
// Purpose: خيار اختبار — بطاقة خيار مع تغيير اللون عند الاختيار والتصحيح
// Owner: رهف — UI Developer
// Branch: feature/flutter-parent
// Week: 2 — ويدجت الاختبارات
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:edu_smart_assistant/config/theme.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatelessWidget باسم QuizOptionWidget
//         - class QuizOptionWidget extends StatelessWidget { ... }

// Step 2: تعريف الخصائص (Props)
//         - final String text;             // نص الخيار بالعربي
//         - final bool isSelected;          // هل تم اختياره؟
//         - final bool? isCorrect;          // هل صحيح؟ (null = لم يُجب بعد)
//         - final VoidCallback onTap;       // دالة عند الضغط

// Step 3: إنشاء Constructor
//         - const QuizOptionWidget({
//             required this.text,
//             required this.isSelected,
//             this.isCorrect,
//             required this.onTap,
//           });

// Step 4: تحديد لون الحدود حسب الحالة
//         - Color borderColor:
//           * إذا لم يُختار (isSelected = false): Colors.grey[300]
//           * إذا اختير ولم يُصحح (isCorrect = null): AppTheme.primaryBlue (أزرق)
//           * إذا اختير وصحيح (isCorrect = true): AppTheme.successColor (أخضر)
//           * إذا اختير وخطأ (isCorrect = false): AppTheme.errorColor (أحمر)

// Step 5: بناء بطاقة الخيار
//         - return InkWell(
//             onTap: isCorrect != null ? null : onTap,  // تعطيل بعد الإجابة
//             child: Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(16),
//               margin: EdgeInsets.symmetric(vertical: 4),
//               decoration: BoxDecoration(
//                 color: _getBackgroundColor(),
//                 border: Border.all(color: borderColor, width: 2),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(children: [
//                 // أيقونة الحالة
//                 if (isCorrect == true) Icon(Icons.check_circle, color: Colors.green, size: 24),
//                 if (isCorrect == false && isSelected) Icon(Icons.cancel, color: Colors.red, size: 24),
//                 if (isCorrect == null && !isSelected) Icon(Icons.radio_button_unchecked, size: 24),
//                 if (isCorrect == null && isSelected) Icon(Icons.radio_button_checked, color: Colors.blue, size: 24),
//                 SizedBox(width: 12),
//                 // نص الخيار
//                 Expanded(
//                   child: Text(
//                     text,
//                     style: TextStyle(fontSize: 18, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
//                     textDirection: TextDirection.rtl,
//                   ),
//                 ),
//               ]),
//             ),
//           );

// Step 6: إنشاء method _getBackgroundColor()
//         - إذا isCorrect == true: Colors.green.withOpacity(0.1)
//         - إذا isCorrect == false && isSelected: Colors.red.withOpacity(0.1)
//         - إذا isSelected: Colors.blue.withOpacity(0.1)
//         - افتراضي: Colors.white

// --- Notes ---
// - ارتفاع كافي (padding 16) لسهولة اللمس (>= 48dp)
// - تغيير اللون عند الاختيار: أزرق (محدد)، أخضر (صحيح)، أحمر (خطأ)
// - تعطيل الضغط بعد الإجابة (isCorrect != null)
// - أيقونات واضحة: دائرة فارغة، دائرة محددة، صح، خطأ
// - نص كبير (18px) للأطفال
// - RTL: النص والأيقونة من اليمين لليسار
