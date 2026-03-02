// ============================================================
// File: chat_bubble_widget.dart
// Purpose: فقاعة محادثة — عرض رسائل الطالب ورد المساعد الذكي
// Owner: رهف — UI Developer
// Branch: feature/flutter-parent
// Week: 2 — ويدجت المحادثة
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:edu_smart_assistant/config/theme.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatelessWidget باسم ChatBubbleWidget
//         - class ChatBubbleWidget extends StatelessWidget { ... }

// Step 2: تعريف الخصائص (Props)
//         - final String message;          // نص الرسالة
//         - final bool isUser;             // true = رسالة المستخدم، false = رسالة البوت
//         - final DateTime timestamp;      // وقت الرسالة

// Step 3: إنشاء Constructor
//         - const ChatBubbleWidget({
//             required this.message,
//             required this.isUser,
//             required this.timestamp,
//           });

// Step 4: بناء فقاعة المحادثة
//         - return Align(
//             // RTL: رسالة المستخدم على اليسار، رسالة البوت على اليمين
//             alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
//             child: Container(
//               constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
//               margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: isUser
//                   ? AppTheme.primaryBlue.withOpacity(0.15)    // فقاعة المستخدم: أزرق فاتح
//                   : AppTheme.primaryGreen.withOpacity(0.15),   // فقاعة البوت: أخضر فاتح
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(16),
//                   topRight: Radius.circular(16),
//                   bottomLeft: isUser ? Radius.zero : Radius.circular(16),
//                   bottomRight: isUser ? Radius.circular(16) : Radius.zero,
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // اسم المرسل
//                   Text(
//                     isUser ? 'أنت' : 'المساعد الذكي',
//                     style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 4),
//                   // نص الرسالة
//                   Text(
//                     message,
//                     style: TextStyle(fontSize: 16, height: 1.4),
//                     textDirection: TextDirection.rtl,
//                   ),
//                   SizedBox(height: 4),
//                   // الوقت
//                   Text(
//                     DateFormat('HH:mm').format(timestamp),
//                     style: TextStyle(fontSize: 10, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           );

// --- Notes ---
// - في RTL: رسالة المستخدم تظهر على اليسار، رسالة البوت على اليمين
// - ألوان مختلفة: أزرق فاتح للمستخدم، أخضر فاتح للبوت
// - أقصى عرض 75% من الشاشة
// - حدود مستديرة مع زاوية حادة عند المرسل
// - يعرض: اسم المرسل + النص + الوقت
// - يُستخدم في ai_chat_screen.dart
// - يحتاج حزمة intl لتنسيق الوقت
