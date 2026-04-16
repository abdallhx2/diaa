import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
// Step 1: الاتصال بـ Firebase Storage
final FirebaseStorage _storage = FirebaseStorage.instance;

// Step 2: رفع صورة
Future<String> uploadImage(File file, String path) async {
// تحديد مكان الحفظ في Firebase
Reference ref = _storage.ref().child(path);

// بدء الرفع
UploadTask uploadTask = ref.putFile(file);

// متابعة نسبة الرفع
uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
double progress = snapshot.bytesTransferred / snapshot.totalBytes;
print('نسبة الرفع: ${(progress * 100).toStringAsFixed(0)}%');
});

// انتظار اكتمال الرفع
TaskSnapshot snapshot = await uploadTask;

// إرجاع رابط الصورة
String downloadUrl = await snapshot.ref.getDownloadURL();
return downloadUrl;
}

// Step 3: جلب رابط ملف
Future<String> getFileUrl(String path) async {
Reference ref = _storage.ref().child(path);
String url = await ref.getDownloadURL();
return url;
}

// Step 4: حذف ملف
Future<void> deleteFile(String path) async {
Reference ref = _storage.ref().child(path);
await ref.delete();
}
}