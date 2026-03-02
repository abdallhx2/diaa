// ============================================================
// File: text_display_screen.dart
// Purpose: شاشة عرض النص والصوت — عرض النص المستخرج مع مشغل صوتي
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 2-3 — شاشات المسح والاستخراج
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:edu_smart_assistant/providers/lesson_provider.dart';
// import 'package:edu_smart_assistant/services/tts_service.dart';
// import 'package:edu_smart_assistant/config/routes.dart';
// import 'package:edu_smart_assistant/widgets/audio_player_widget.dart';
// import 'package:edu_smart_assistant/widgets/custom_button.dart';
// import 'package:edu_smart_assistant/widgets/loading_widget.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatefulWidget باسم TextDisplayScreen
//         - class TextDisplayScreen extends StatefulWidget { ... }

// Step 2: استقبال البيانات من الشاشة السابقة
//         - قراءة النص من LessonProvider: context.read<LessonProvider>().extractedText
//         - أو من arguments: ModalRoute.of(context)!.settings.arguments

// Step 3: في initState — توليد الصوت
//         - إذا لم يكن هناك audioUrl:
//           * استدعاء TtsService().generateAudio(extractedText)
//           * حفظ الرابط: context.read<LessonProvider>().setAudioUrl(url)

// Step 4: بناء الواجهة
//         - Scaffold مع AppBar: "الدرس" أو عنوان الدرس
//         - Column([
//             // منطقة النص (scrollable)
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.all(16),
//                 child: Text(
//                   extractedText,
//                   style: TextStyle(fontSize: 22, height: 1.8),  // خط كبير للأطفال
//                   textDirection: TextDirection.rtl,
//                 ),
//               ),
//             ),
//             // مشغل الصوت
//             if (audioUrl != null)
//               AudioPlayerWidget(audioUrl: audioUrl!),
//             // زر "اسأل المساعد الذكي"
//             Padding(
//               padding: EdgeInsets.all(16),
//               child: CustomButton(
//                 text: 'اسأل المساعد الذكي',
//                 icon: Icons.chat,
//                 onPressed: () => Navigator.pushNamed(
//                   context,
//                   AppRoutes.aiChat,
//                   arguments: {'lessonId': lessonId, 'text': extractedText},
//                 ),
//               ),
//             ),
//           ])

// Step 5: عرض شريط تقدم الصوت
//         - يتم من خلال AudioPlayerWidget (يحتوي play/pause/restart + progress bar)

// --- Notes ---
// - النص يعرض بخط عربي كبير (22px) مع ارتفاع سطر 1.8 لسهولة القراءة
// - الصوت يتم توليده من خدمة TTS على السيرفر
// - زر "اسأل المساعد الذكي" ينقل لشاشة المحادثة مع سياق الدرس
// - إذا فشل توليد الصوت: عرض النص فقط بدون مشغل صوت
// - يمكن إضافة highlight للكلمة أثناء التشغيل لاحقاً
