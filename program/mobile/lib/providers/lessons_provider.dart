import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/models/lesson_model.dart';
import 'package:edu_smart_assistant/models/lesson_detail_model.dart';
import 'package:edu_smart_assistant/services/lesson_service.dart';

class LessonsProvider extends ChangeNotifier {
  List<LessonModel> _lessons = [];
  LessonDetailModel? _detail;
  bool _isLoading = false;
  bool _isLoadingDetail = false;
  String? _errorMessage;
  final LessonService _lessonService = LessonService();

  List<LessonModel> get lessons => _lessons;
  LessonDetailModel? get detail => _detail;
  bool get isLoading => _isLoading;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get errorMessage => _errorMessage;

  Future<void> loadLessons(String grade, String subject) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lessons = await _lessonService.getLessons(grade, subject);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _lessons = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadDetail(String id) async {
    _isLoadingDetail = true;
    _detail = null;
    _errorMessage = null;
    notifyListeners();

    try {
      _detail = await _lessonService.getLessonDetail(id);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    _isLoadingDetail = false;
    notifyListeners();
  }

  void clearDetail() {
    _detail = null;
    notifyListeners();
  }

  void cleanup() {
    _detail = null;
    _errorMessage = null;
    notifyListeners();
  }
}
