// ============================================================
// File: auth_service.dart
// Purpose: خدمة المصادقة — Firebase Auth + تسجيل Backend
// Owner: حياة — Integration Developer
// Branch: feature/flutter-services
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:edu_smart_assistant/services/api_service.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class AuthService
//         - class AuthService {
//             final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//             final ApiService _apiService = ApiService();
//           }

// Step 2: إنشاء method signInWithEmail(String email, String password)
//         - UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
//             email: email, password: password,
//           );
//         - // بعد النجاح: جلب بيانات المستخدم من Backend
//         - final response = await _apiService.get('/auth/me');
//         - return UserModel.fromJson(response.data);
//         - // التعامل مع الأخطاء:
//           * FirebaseAuthException 'wrong-password' → "كلمة المرور غير صحيحة"
//           * FirebaseAuthException 'user-not-found' → "لا يوجد حساب بهذا البريد"
//           * FirebaseAuthException 'user-disabled' → "هذا الحساب معطل"

// Step 3: إنشاء method registerWithEmail(String email, String password, String name, String phone)
//         - // الخطوة 1: إنشاء حساب في Firebase Auth
//         - UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
//             email: email, password: password,
//           );
//         - // الخطوة 2: إنشاء سجل في Backend
//         - final response = await _apiService.post('/auth/register', data: {
//             'firebase_uid': credential.user!.uid,
//             'name': name,
//             'email': email,
//             'phone': phone,
//             'role': 'parent',
//           });
//         - return UserModel.fromJson(response.data);
//         - // التعامل مع الأخطاء:
//           * 'email-already-in-use' → "هذا البريد مستخدم بالفعل"
//           * 'weak-password' → "كلمة المرور ضعيفة جداً"

// Step 4: إنشاء method signOut()
//         - await _firebaseAuth.signOut();

// Step 5: إنشاء method getCurrentUser()
//         - User? user = _firebaseAuth.currentUser;
//         - إذا user != null: جلب البيانات من Backend
//         - return UserModel أو null

// Step 6: إنشاء method getIdToken()
//         - return await _firebaseAuth.currentUser?.getIdToken();

// Step 7: إنشاء method resetPassword(String email)
//         - await _firebaseAuth.sendPasswordResetEmail(email: email);

// --- Notes ---
// - Firebase Auth يتعامل مع المصادقة (email/password)
// - Backend API يتعامل مع بيانات المستخدم (الملف الشخصي)
// - كل عملية تسجيل تُنشئ حساب Firebase + سجل Backend
// - getIdToken() يُستخدم في ApiService لإرسال التوكن مع كل طلب
// - أخطاء Firebase Auth لها رسائل عربية محددة
// - resetPassword يرسل رابط إعادة التعيين للبريد
