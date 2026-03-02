// ============================================================
// File: lesson_provider.dart
// Purpose: إدارة حالة الدرس الحالي — النص المستخرج والصوت
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 2 — شاشات الطالب الأساسية
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:edu_smart_assistant/models/lesson_model.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class LessonProvider extends ChangeNotifier
//         - class LessonProvider extends ChangeNotifier { ... }

// Step 2: تعريف الحقول (Fields)
//         - LessonModel? _currentLesson;      // الدرس الحالي
//         - String? _extractedText;            // النص المستخرج من OCR
//         - String? _audioUrl;                 // رابط الصوت المولد
//         - bool _isLoading = false;

// Step 3: إنشاء Getters
//         - LessonModel? get currentLesson => _currentLesson;
//         - String? get extractedText => _extractedText;
//         - String? get audioUrl => _audioUrl;
//         - bool get isLoading => _isLoading;

// Step 4: إنشاء method setLesson(LessonModel lesson)
//         - _currentLesson = lesson;
//         - _extractedText = lesson.originalText;
//         - _audioUrl = lesson.audioUrl;
//         - notifyListeners();

// Step 5: إنشاء method setExtractedText(String text)
//         - _extractedText = text;
//         - notifyListeners();

// Step 6: إنشاء method setAudioUrl(String url)
//         - _audioUrl = url;
//         - notifyListeners();

// Step 7: إنشاء method clearLesson()
//         - _currentLesson = null;
//         - _extractedText = null;
//         - _audioUrl = null;
//         - notifyListeners();

// --- Notes ---
// - يحفظ حالة الدرس أثناء التنقل بين الشاشات
// - يستخدم في: scan_page_screen → text_display_screen → ai_chat_screen
// - clearLesson() يُستدعى عند العودة للوحة الطالب
// - النص المستخرج يمكن أن يأتي من: مسح كاميرا، QR، أو رفع ملف
