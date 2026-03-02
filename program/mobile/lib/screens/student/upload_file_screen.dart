// ============================================================
// File: upload_file_screen.dart
// Purpose: شاشة رفع ملف/صورة — اختيار صورة من المعرض واستخراج النص
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 2-3 — شاشات المسح والاستخراج
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:edu_smart_assistant/providers/lesson_provider.dart';
// import 'package:edu_smart_assistant/services/scan_service.dart';
// import 'package:edu_smart_assistant/config/routes.dart';
// import 'package:edu_smart_assistant/config/constants.dart';
// import 'package:edu_smart_assistant/widgets/custom_button.dart';
// import 'package:edu_smart_assistant/widgets/loading_widget.dart';
// import 'dart:io';

// --- Implementation Steps ---
// Step 1: إنشاء StatefulWidget باسم UploadFileScreen
//         - class UploadFileScreen extends StatefulWidget { ... }

// Step 2: تعريف المتغيرات
//         - File? _selectedImage;        // الصورة المختارة
//         - bool _isLoading = false;     // حالة التحميل
//         - final ImagePicker _picker = ImagePicker();

// Step 3: بناء الواجهة
//         - Scaffold مع AppBar: "رفع ملف"
//         - إذا لم تُختر صورة:
//           * أيقونة كبيرة upload (64px)
//           * نص "اختر صورة من الجهاز"
//           * CustomButton: "اختيار صورة" → _pickImage()
//         - إذا اختيرت صورة:
//           * Image.file(_selectedImage!) مع حدود مستديرة
//           * CustomButton: "استخراج النص" → _uploadAndExtract()
//           * CustomButton ثانوي: "اختيار صورة أخرى" → _pickImage()

// Step 4: إنشاء method _pickImage()
//         - XFile? image = await _picker.pickImage(
//             source: ImageSource.gallery,
//             maxWidth: 1920,
//             maxHeight: 1920,
//             imageQuality: 85,
//           );
//         - التحقق من الحجم: image.length() <= AppConstants.imageMaxSizeBytes
//         - إذا كبيرة: عرض "حجم الصورة كبير جداً (الحد 10 ميغابايت)"
//         - setState(() => _selectedImage = File(image.path));

// Step 5: إنشاء method _uploadAndExtract()
//         - setState(() => _isLoading = true);
//         - استدعاء ScanService().uploadFile(_selectedImage!)
//         - عند النجاح:
//           * context.read<LessonProvider>().setLesson(lessonData)
//           * Navigator.pushNamed(context, AppRoutes.textDisplay)
//         - عند الفشل:
//           * عرض SnackBar: "لم نتمكن من استخراج النص، حاول مرة أخرى"
//         - setState(() => _isLoading = false);

// --- Notes ---
// - الحد الأقصى لحجم الصورة 10 ميغابايت (من constants.dart)
// - يمكن إضافة image cropping لاحقاً
// - عرض حالة التحميل أثناء الرفع والاستخراج
// - تصميم بسيط وواضح مناسب للأطفال
// - يمكن إضافة اختيار من الكاميرا أيضاً (ImageSource.camera)
