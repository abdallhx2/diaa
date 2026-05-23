import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/services/lesson_service.dart';

class SubjectsProvider extends ChangeNotifier {
  List<String> _subjects = [];
  bool _isLoading = false;
  String? _errorMessage;
  final LessonService _lessonService = LessonService();

  List<String> get subjects => _subjects;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadSubjects(String grade) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _subjects = await _lessonService.getSubjects(grade);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _subjects = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void cleanup() {
    _subjects = [];
    _errorMessage = null;
    notifyListeners();
  }
}
