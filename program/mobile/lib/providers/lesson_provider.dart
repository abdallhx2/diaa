import 'package:flutter/material.dart';

class LessonModel {
  final String  id;
  final String  title;
  final String? originalText;
  final String? audioUrl;
  const LessonModel({
    required this.id,
    required this.title,
    this.originalText,
    this.audioUrl,
  });
}

class LessonProvider extends ChangeNotifier {
  LessonModel? _currentLesson;
  String?      _extractedText;
  String?      _audioUrl;
  bool         _isLoading = false;

  LessonModel? get currentLesson   => _currentLesson;
  String?      get extractedText   => _extractedText;
  String?      get audioUrl        => _audioUrl;
  bool         get isLoading       => _isLoading;
  bool         get hasLesson       => _currentLesson != null;
  bool         get hasExtractedText => _extractedText != null && _extractedText!.isNotEmpty;
  bool         get hasAudio         => _audioUrl != null && _audioUrl!.isNotEmpty;

  void setLesson(LessonModel lesson) {
    _currentLesson = lesson;
    _extractedText = lesson.originalText;
    _audioUrl      = lesson.audioUrl;
    _isLoading     = false;
    notifyListeners();
  }

  void setExtractedText(String text) {
    _extractedText = text;
    notifyListeners();
  }

  void setAudioUrl(String url) {
    _audioUrl = url;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearLesson() {
    _currentLesson = null;
    _extractedText = null;
    _audioUrl      = null;
    _isLoading     = false;
    notifyListeners();
  }
}