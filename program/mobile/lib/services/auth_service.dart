import 'package:firebase_auth/firebase_auth.dart';
import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:edu_smart_assistant/models/user_model.dart';

class AuthService {
// Step 1: الاتصال بـ Firebase Auth و ApiService
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final ApiService _apiService = ApiService();

// Step 2: تسجيل الدخول
Future<UserModel> signInWithEmail(String email, String password) async {
try {
UserCredential credential = await _firebaseAuth
.signInWithEmailAndPassword(email: email, password: password);

// جلب بيانات المستخدم من Backend
final response = await _apiService.get('/auth/me');
return UserModel.fromJson(response.data);

} on FirebaseAuthException catch (e) {
switch (e.code) {
case 'wrong-password':
throw Exception('كلمة المرور غير صحيحة');
case 'user-not-found':
throw Exception('لا يوجد حساب بهذا البريد');
case 'user-disabled':
throw Exception('هذا الحساب معطل');
default:
throw Exception('حدث خطأ في تسجيل الدخول');
}
}
}

// Step 3: إنشاء حساب جديد
Future<UserModel> registerWithEmail(
String email, String password, String name, String phone) async {
try {
// الخطوة 1: إنشاء حساب في Firebase
UserCredential credential = await _firebaseAuth
.createUserWithEmailAndPassword(email: email, password: password);

// الخطوة 2: حفظ البيانات في Backend
final response = await _apiService.post('/auth/register', data: {
'firebase_uid': credential.user!.uid,
'name': name,
'email': email,
'phone': phone,
'role': 'parent',
});
return UserModel.fromJson(response.data);

} on FirebaseAuthException catch (e) {
switch (e.code) {
case 'email-already-in-use':
throw Exception('هذا البريد مستخدم بالفعل');
case 'weak-password':
throw Exception('كلمة المرور ضعيفة جداً');
default:
throw Exception('حدث خطأ في إنشاء الحساب');
}
}
}

// Step 4: تسجيل الخروج
Future<void> signOut() async {
await _firebaseAuth.signOut();
}

// Step 5: جلب المستخدم الحالي
Future<UserModel?> getCurrentUser() async {
User? user = _firebaseAuth.currentUser;
if (user != null) {
final response = await _apiService.get('/auth/me');
return UserModel.fromJson(response.data);
}
return null;
}

// Step 6: جلب التوكن
Future<String?> getIdToken() async {
return await _firebaseAuth.currentUser?.getIdToken();
}

// Step 7: نسيت كلمة المرور
Future<void> resetPassword(String email) async {
await _firebaseAuth.sendPasswordResetEmail(email: email);
}
}