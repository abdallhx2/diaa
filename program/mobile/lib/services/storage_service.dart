// ============================================================
// File: storage_service.dart
// Purpose: خدمة Firebase Storage — رفع وجلب وحذف الملفات
// Owner: حياة — Integration Developer
// Branch: feature/flutter-services
// Week: 2 — خدمات التخزين السحابي
// ============================================================

// --- Required Imports ---
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class StorageService
//         - class StorageService {
//             final FirebaseStorage _storage = FirebaseStorage.instance;
//           }

// Step 2: إنشاء method uploadImage(File file, String path)
//         - // رفع صورة إلى Firebase Storage
//         - Reference ref = _storage.ref().child(path);
//         - // path مثال: 'images/scans/scan_1234567890.jpg'
//         - UploadTask uploadTask = ref.putFile(file);
//         - // متابعة نسبة الرفع (اختياري):
//           uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//             double progress = snapshot.bytesTransferred / snapshot.totalBytes;
//           });
//         - TaskSnapshot snapshot = await uploadTask;
//         - String downloadUrl = await snapshot.ref.getDownloadURL();
//         - return downloadUrl;

// Step 3: إنشاء method getFileUrl(String path)
//         - // جلب رابط تحميل ملف
//         - Reference ref = _storage.ref().child(path);
//         - String url = await ref.getDownloadURL();
//         - return url;

// Step 4: إنشاء method deleteFile(String path)
//         - // حذف ملف من Storage
//         - Reference ref = _storage.ref().child(path);
//         - await ref.delete();

// --- Notes ---
// - يستخدم لرفع الصور المُلتقطة قبل إرسالها للـ OCR (اختياري)
// - يستخدم لتخزين ملفات الصوت المولدة من TTS
// - path يجب أن يكون فريد (استخدام timestamp أو UUID)
// - Firebase Storage rules يجب تعديلها للسماح بالرفع للمستخدمين المُوثقين فقط
// - يمكن متابعة نسبة الرفع لعرض progress bar
// - getDownloadURL تعيد رابط عام يمكن استخدامه في أي مكان
// - في الإنتاج: تأكد من Firebase Storage rules الصحيحة
