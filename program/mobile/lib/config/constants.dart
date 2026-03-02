// ============================================================
// File: constants.dart
// Purpose: ثوابت التطبيق — روابط API، أحجام، إعدادات عامة
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// (لا يحتاج imports خارجية)

// --- Implementation Steps ---
// Step 1: إنشاء class AppConstants مع قيم ثابتة static const
//         - class AppConstants { ... }

// Step 2: تعريف ثوابت الـ API
//         - static const String appName = 'Edu Smart Assistant';
//         - static const String appNameAr = 'المساعد التعليمي الذكي';
//         - static const String apiBaseUrl = 'http://localhost:8000/api';  // للتطوير
//         // في الإنتاج: 'https://your-domain.com/api'

// Step 3: تعريف ثوابت الملفات
//         - static const int imageMaxSizeMB = 10;          // أقصى حجم صورة 10 ميغابايت
//         - static const int imageMaxSizeBytes = 10 * 1024 * 1024;

// Step 4: تعريف ثوابت المحادثة
//         - static const int maxChatMessages = 20;         // أقصى عدد رسائل في الجلسة

// Step 5: تعريف ثوابت الاختبارات
//         - static const int quizQuestionsPerSession = 5;  // 5 أسئلة لكل اختبار

// Step 6: تعريف ثوابت التصميم
//         - static const double minButtonSize = 48.0;      // أقل ارتفاع زر 48dp
//         - static const double iconSizeLarge = 64.0;      // أيقونات كبيرة للأطفال
//         - static const double borderRadius = 12.0;       // حدود مستديرة
//         - static const double cardBorderRadius = 16.0;

// Step 7: تعريف ثوابت الـ Timeout
//         - static const int apiTimeoutSeconds = 30;       // مهلة الاتصال 30 ثانية

// Step 8: تعريف ثوابت المسارات في Firebase Storage
//         - static const String storageImagesPath = 'images/';
//         - static const String storageAudioPath = 'audio/';

// --- Notes ---
// - في الإنتاج، يجب تغيير apiBaseUrl للرابط الفعلي
// - يمكن استخدام .env file لتخزين المتغيرات الحساسة
// - الثوابت تساعد في تجنب الـ magic numbers في الكود
// - يمكن إضافة ثوابت جديدة حسب الحاجة
