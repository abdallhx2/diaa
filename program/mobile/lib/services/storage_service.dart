import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// رفع صورة إلى Firebase Storage
  Future<String> uploadImage(File file, {String? path}) async {
    try {
      final storagePath =
          path ?? 'images/uploads/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child(storagePath);

      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('فشل في رفع الصورة');
    }
  }

  /// جلب رابط تحميل ملف
  Future<String> getDownloadUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('فشل في جلب رابط الملف');
    }
  }

  /// حذف ملف من Storage
  Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      throw Exception('فشل في حذف الملف');
    }
  }
}
