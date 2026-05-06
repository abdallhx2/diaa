import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:edu_smart_assistant/services/api_service.dart';
import 'package:edu_smart_assistant/models/user_model.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  /// هل Firebase متاح ومهيّأ؟
  bool get _isFirebaseAvailable {
    try {
      Firebase.app();
      return true;
    } catch (e) {
      debugPrint('Firebase not available: $e');
      return false;
    }
  }

  FirebaseAuth? get _firebaseAuth =>
      _isFirebaseAvailable ? FirebaseAuth.instance : null;

  /// تسجيل الدخول بالبريد وكلمة المرور
  Future<UserModel> signInWithEmail(String email, String password,
      {String role = 'student'}) async {
    if (!_isFirebaseAvailable) {
      throw Exception('Firebase غير متاح');
    }

    try {
      final credential = await _firebaseAuth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final fbUser = credential.user!;

      // محاولة التحقق مع الباك اند (إذا كان متاحاً)
      try {
        final idToken = await fbUser.getIdToken();
        await _apiService.post('/auth/verify-token', data: {
          'token': idToken,
        });

        final response = await _apiService.get('/auth/me');
        final data = response.data;

        if (data['success'] == true) {
          return UserModel.fromJson(data['data']);
        }
      } catch (_) {
        // الباك اند غير متاح — نستخدم بيانات Firebase مباشرة
        debugPrint('Backend unavailable, using Firebase user data');
      }

      // إنشاء UserModel من بيانات Firebase
      return UserModel(
        id: fbUser.uid,
        firebaseUid: fbUser.uid,
        role: role,
        name: fbUser.displayName ?? email.split('@').first,
        email: fbUser.email ?? email,
        createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFirebaseAuthError(e.code));
    }
  }

  /// تسجيل ولي أمر جديد
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    if (!_isFirebaseAvailable) {
      throw Exception('Firebase غير متاح');
    }

    try {
      final credential = await _firebaseAuth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // تحديث الاسم في Firebase
      await credential.user!.updateDisplayName(name);

      final fbUser = credential.user!;

      // محاولة التسجيل في Backend
      try {
        final response = await _apiService.post('/auth/register-parent', data: {
          'name': name,
          'email': email,
          'phone': phone,
        });

        final data = response.data;
        if (data['success'] == true) {
          return UserModel.fromJson(data['data']);
        }
      } catch (_) {
        debugPrint('Backend unavailable, using Firebase user data');
      }

      return UserModel(
        id: fbUser.uid,
        firebaseUid: fbUser.uid,
        role: 'parent',
        name: name,
        email: email,
        phone: phone ?? '',
        createdAt: DateTime.now(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFirebaseAuthError(e.code));
    }
  }

  /// إضافة طفل
  Future<Map<String, dynamic>> addChild({
    required String childFirebaseUid,
    required String childName,
    int? age,
    required String grade,
    String? learningLevel,
  }) async {
    final response = await _apiService.post('/auth/add-child', data: {
      'child_firebase_uid': childFirebaseUid,
      'child_name': childName,
      'age': age,
      'grade': grade,
      'learning_level': learningLevel,
    });

    final data = response.data;
    if (data['success'] == true) {
      return data['data'];
    }
    throw Exception(data['message'] ?? 'فشل في إضافة الطفل');
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    try {
      await _firebaseAuth?.signOut();
    } catch (_) {}
  }

  /// جلب المستخدم الحالي
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth?.currentUser;
    if (user == null) return null;

    // محاولة جلب من Backend
    try {
      final response = await _apiService.get('/auth/me');
      final data = response.data;
      if (data['success'] == true) {
        return UserModel.fromJson(data['data']);
      }
    } catch (_) {
      // Backend غير متاح — نستخدم بيانات Firebase
    }

    // استخدام SharedPreferences للدور المحفوظ
    return UserModel(
      id: user.uid,
      firebaseUid: user.uid,
      role: 'student',
      name: user.displayName ?? user.email?.split('@').first ?? '',
      email: user.email ?? '',
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  /// الحصول على توكن Firebase
  Future<String?> getIdToken() async {
    return await _firebaseAuth?.currentUser?.getIdToken();
  }

  /// إعادة تعيين كلمة المرور
  Future<void> resetPassword(String email) async {
    if (!_isFirebaseAvailable) {
      throw Exception('Firebase غير متاح');
    }
    try {
      await _firebaseAuth!.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFirebaseAuthError(e.code));
    }
  }

  /// هل المستخدم مسجل دخول حالياً؟
  bool get isSignedIn => _firebaseAuth?.currentUser != null;

  /// تحويل أخطاء Firebase Auth لرسائل عربية
  String _getFirebaseAuthError(String code) {
    switch (code) {
      case 'wrong-password':
      case 'invalid-credential':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      case 'user-not-found':
        return 'لا يوجد حساب بهذا البريد الإلكتروني';
      case 'user-disabled':
        return 'هذا الحساب معطل';
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مستخدم بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'too-many-requests':
        return 'محاولات كثيرة، حاول لاحقاً';
      case 'network-request-failed':
        return 'لا يوجد اتصال بالإنترنت';
      default:
        return 'حدث خطأ في المصادقة ($code)';
    }
  }
}
