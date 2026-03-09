import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'student' | 'parent'
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}

class AuthService {
  Future<UserModel?> signInWithEmail(String email, String password) async => null;
  Future<void>       signOut() async {}
  Future<UserModel?> getCurrentUser() async => null;
  Future<UserModel?> registerWithEmail(
      String email, String password, String name, String phone) async => null;
}

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool       _isLoading        = false;
  bool       _isAuthenticated  = false;
  String?    _userRole;
  String?    _errorMessage;
  final AuthService _authService = AuthService();

  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserRole   = 'userRole';
  static const String _keyUserId     = 'userId';

  UserModel? get currentUser     => _currentUser;
  bool       get isLoading       => _isLoading;
  bool       get isAuthenticated => _isAuthenticated;
  String?    get userRole        => _userRole;
  String?    get errorMessage    => _errorMessage;

  Future<bool> login(String email, String password) async {
    _errorMessage = null;
    _isLoading    = true;
    notifyListeners();

    try {
      final UserModel? user =
          await _authService.signInWithEmail(email, password);

      if (user != null) {
        _currentUser     = user;
        _isAuthenticated = true;
        _userRole        = user.role;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_keyIsLoggedIn, true);
        await prefs.setString(_keyUserRole, _userRole ?? '');
        await prefs.setString(_keyUserId,   user.id);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'فشل تسجيل الدخول. يرجى المحاولة مجدداً.';
        _isLoading    = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = _mapFirebaseAuthError(e.toString());
      _isLoading    = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try { await _authService.signOut(); } catch (_) {}

    _currentUser     = null;
    _isAuthenticated = false;
    _userRole        = null;
    _errorMessage    = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserRole);
    await prefs.remove(_keyUserId);

    notifyListeners();
  }

  Future<void> checkAuthState() async {
    final prefs      = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

    if (isLoggedIn) {
      try {
        final UserModel? user = await _authService.getCurrentUser();
        if (user != null) {
          _currentUser     = user;
          _isAuthenticated = true;
          _userRole        = prefs.getString(_keyUserRole);
        } else {
          await _clearLocalSession(prefs);
        }
      } catch (_) {
        await _clearLocalSession(prefs);
      }
    } else {
      _isAuthenticated = false;
      _userRole        = null;
      _currentUser     = null;
    }
    notifyListeners();
  }

  Future<bool> registerParent(Map<String, dynamic> data) async {
    _errorMessage = null;
    _isLoading    = true;
    notifyListeners();

    try {
      final user = await _authService.registerWithEmail(
        data['email']    as String,
        data['password'] as String,
        data['name']     as String,
        data['phone']    as String,
      );

      if (user != null) {
        _currentUser     = user;
        _isAuthenticated = true;
        _userRole        = 'parent';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_keyIsLoggedIn, true);
        await prefs.setString(_keyUserRole, 'parent');
        await prefs.setString(_keyUserId,   user.id);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'فشل إنشاء الحساب. يرجى المحاولة مجدداً.';
        _isLoading    = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = _mapFirebaseAuthError(e.toString());
      _isLoading    = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _clearLocalSession(SharedPreferences prefs) async {
    _currentUser     = null;
    _isAuthenticated = false;
    _userRole        = null;
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserRole);
    await prefs.remove(_keyUserId);
  }

  String _mapFirebaseAuthError(String errorCode) {
    if (errorCode.contains('wrong-password') ||
        errorCode.contains('invalid-credential')) {
      return 'كلمة المرور غير صحيحة. يرجى المحاولة مجدداً.';
    } else if (errorCode.contains('user-not-found')) {
      return 'لا يوجد حساب مرتبط بهذا البريد الإلكتروني.';
    } else if (errorCode.contains('email-already-in-use')) {
      return 'البريد الإلكتروني مستخدم بالفعل.';
    } else if (errorCode.contains('invalid-email')) {
      return 'صيغة البريد الإلكتروني غير صحيحة.';
    } else if (errorCode.contains('weak-password')) {
      return 'كلمة المرور ضعيفة. يجب أن تكون 6 أحرف على الأقل.';
    } else if (errorCode.contains('too-many-requests')) {
      return 'تم حظر الحساب مؤقتاً بسبب كثرة المحاولات.';
    } else if (errorCode.contains('network-request-failed')) {
      return 'تعذّر الاتصال بالإنترنت. يرجى التحقق من الشبكة.';
    } else {
      return 'حدث خطأ غير متوقع. يرجى المحاولة مجدداً.';
    }
  }
}