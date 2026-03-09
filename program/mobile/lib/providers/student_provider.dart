import 'package:flutter/material.dart';

class StudentModel {
  final String  id;
  final String  name;
  final String? role;
  const StudentModel({required this.id, required this.name, this.role});

  factory StudentModel.fromMap(Map<String, dynamic> map) => StudentModel(
    id:   map['id']   as String? ?? '',
    name: map['name'] as String? ?? '',
    role: map['role'] as String?,
  );
}

class SessionModel {
  final String   id;
  final String   lessonId;
  final DateTime date;
  const SessionModel({required this.id, required this.lessonId, required this.date});
}

class StudentService {
  Future<Map<String, dynamic>> getDashboard() async => {};
  Future<List<SessionModel>>   getSessions()  async => [];
  Future<Map<String, dynamic>> getProgress()  async => {};
}

class StudentProvider extends ChangeNotifier {
  StudentModel?         _studentData;
  List<SessionModel>    _sessions    = [];
  Map<String, dynamic>? _progress;
  bool                  _isLoading   = false;
  String?               _errorMessage;
  final StudentService  _studentService = StudentService();

  StudentModel?         get studentData  => _studentData;
  List<SessionModel>    get sessions     => List.unmodifiable(_sessions);
  Map<String, dynamic>? get progress     => _progress;
  bool                  get isLoading    => _isLoading;
  String?               get errorMessage => _errorMessage;
  bool                  get hasData      => _studentData != null;
  bool                  get hasSessions  => _sessions.isNotEmpty;

  Future<void> fetchDashboard() async {
    _errorMessage = null;
    _isLoading    = true;
    notifyListeners();

    try {
      final Map<String, dynamic> response = await _studentService.getDashboard();
      _studentData = StudentModel.fromMap(response);
    } catch (e) {
      _errorMessage = 'تعذّر تحميل بيانات لوحة التحكم. يرجى المحاولة مجدداً.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSessions() async {
    _errorMessage = null;

    try {
      _sessions = await _studentService.getSessions();
    } catch (e) {
      _errorMessage = 'تعذّر تحميل سجل الجلسات. يرجى المحاولة مجدداً.';
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchProgress() async {
    _errorMessage = null;

    try {
      _progress = await _studentService.getProgress();
    } catch (e) {
      _errorMessage = 'تعذّر تحميل بيانات التقدم. يرجى المحاولة مجدداً.';
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchAll() async {
    _errorMessage = null;
    _isLoading    = true;
    notifyListeners();

    await Future.wait([
      fetchDashboard(),
      fetchSessions(),
      fetchProgress(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  void reset() {
    _studentData  = null;
    _sessions     = [];
    _progress     = null;
    _isLoading    = false;
    _errorMessage = null;
    notifyListeners();
  }
}
