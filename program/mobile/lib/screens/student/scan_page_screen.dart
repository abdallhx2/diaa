// ============================================================
// File: scan_page_screen.dart
// Purpose: شاشة مسح الصفحة بالكاميرا — التقاط صورة واستخراج النص بـ OCR
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 2-3 — شاشات المسح والاستخراج
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:provider/provider.dart';
// import 'package:edu_smart_assistant/providers/lesson_provider.dart';
// import 'package:edu_smart_assistant/services/scan_service.dart';
// import 'package:edu_smart_assistant/config/routes.dart';
// import 'package:edu_smart_assistant/widgets/loading_widget.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatefulWidget باسم ScanPageScreen
//         - class ScanPageScreen extends StatefulWidget { ... }

// Step 2: في initState — تهيئة الكاميرا
//         - الحصول على قائمة الكاميرات: availableCameras()
//         - إنشاء CameraController مع الكاميرا الخلفية
//         - تهيئة: _cameraController.initialize()
//         - التعامل مع أذونات الكاميرا

// Step 3: في dispose — التخلص من الكاميرا
//         - _cameraController.dispose();

// Step 4: بناء واجهة الكاميرا
//         - إذا لم تتهيأ الكاميرا: عرض LoadingWidget
//         - عرض CameraPreview بملء الشاشة
//         - زر التقاط دائري كبير في الأسفل (FloatingActionButton 72dp)

// Step 5: إنشاء method _captureAndScan()
//         - التقاط الصورة: XFile image = await _cameraController.takePicture()
//         - عرض حالة التحميل
//         - إرسال الصورة: ScanService().scanPage(image)
//         - عند النجاح:
//           * context.read<LessonProvider>().setLesson(lessonData)
//           * Navigator.pushNamed(context, AppRoutes.textDisplay)
//         - عند الفشل:
//           * عرض SnackBar: "لم نتمكن من استخراج النص، حاول مرة أخرى"

// Step 6: التعامل مع أذونات الكاميرا
//         - إذا رُفضت الأذونات: عرض رسالة "يجب السماح بالوصول للكاميرا"
//         - زر "فتح الإعدادات" لفتح إعدادات التطبيق

// --- Notes ---
// - يجب إضافة أذونات الكاميرا في AndroidManifest.xml و Info.plist
// - حزمة camera تحتاج إعداد خاص لـ Android (minSdkVersion 21)
// - عرض إطار توجيهي فوق الكاميرا لمساعدة الطفل في توجيه الكاميرا
// - يمكن إضافة flash control لاحقاً
// - رسائل الخطأ بالعربي دائماً
