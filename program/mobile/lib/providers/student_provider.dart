import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/models/student_model.dart';
import 'package:edu_smart_assistant/models/session_model.dart';
import 'package:edu_smart_assistant/services/student_service.dart';

class StudentProvider extends ChangeNotifier {
  StudentModel? _studentData;
  List<SessionModel> _sessions = [];
  Map<String, dynamic>? _progress;
  bool _isLoading = false;
  String? _errorMessage;
  final StudentService _studentService = StudentService();

  StudentModel? get studentData => _studentData;
  List<SessionModel> get sessions => _sessions;
  Map<String, dynamic>? get progress => _progress;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDashboard() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _studentService.getDashboard();
      // Backend يعيد student_info بدلاً من student
      if (data.containsKey('student_info')) {
        _studentData = StudentModel.fromJson(data['student_info']);
      }
      _progress = {
        'completed_lessons': data['completed_lessons'],
        'quiz_score_average': data['quiz_score_average'],
        'study_time_minutes': data['study_time_minutes'],
        'progress_score': data['progress_score'],
      };
    } catch (e) {
      _errorMessage = null;
      // Fallback: provide default progress when backend is unavailable
      _progress ??= {
        'completed_lessons': 0,
        'quiz_score_average': 0,
        'study_time_minutes': 0,
        'progress_score': 0,
      };
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSessions() async {
    try {
      _sessions = await _studentService.getSessions();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل في تحميل الجلسات';
    }
  }

  Future<void> fetchProgress() async {
    try {
      _progress = await _studentService.getProgress();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل في تحميل بيانات التقدم';
    }
  }
}
