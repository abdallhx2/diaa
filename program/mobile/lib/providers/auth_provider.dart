import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edu_smart_assistant/models/user_model.dart';
import 'package:edu_smart_assistant/services/auth_service.dart';
import 'package:edu_smart_assistant/services/fcm_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _userRole;
  String? _errorMessage;
  final AuthService _authService = AuthService();

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get userRole => _userRole;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password,
      {String role = 'student'}) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final user =
          await _authService.signInWithEmail(email, password, role: role);
      _currentUser = user;
      _isAuthenticated = true;
      _userRole = user.role;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userRole', user.role);
      await prefs.setString('userId', user.id);

      if (user.role == 'parent') {
        FcmService.instance.initForParent();
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
    } catch (_) {}

    _currentUser = null;
    _isAuthenticated = false;
    _userRole = null;
    _errorMessage = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userRole');
    await prefs.remove('userId');

    notifyListeners();
  }

  Future<void> checkAuthState() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      final savedRole = prefs.getString('userRole');

      if (isLoggedIn && _authService.isSignedIn) {
        final user = await _authService.getCurrentUser();
        if (user != null) {
          // استخدام الدور المحفوظ إذا كان متاحاً
          _currentUser = savedRole != null
              ? user.copyWith(role: savedRole)
              : user;
          _isAuthenticated = true;
          _userRole = savedRole ?? user.role;
          if (_userRole == 'parent') {
            FcmService.instance.initForParent();
          }
        } else {
          _isAuthenticated = false;
          _userRole = null;
        }
      } else {
        _isAuthenticated = false;
        _userRole = null;
      }
    } catch (_) {
      _isAuthenticated = false;
      _userRole = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> registerParent(Map<String, dynamic> data) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.registerWithEmail(
        email: data['email'],
        password: data['password'],
        name: data['name'],
        phone: data['phone'],
      );
      _currentUser = user;
      _isAuthenticated = true;
      _userRole = 'parent';

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userRole', 'parent');
      await prefs.setString('userId', user.id);

      FcmService.instance.initForParent();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
