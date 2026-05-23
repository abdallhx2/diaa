import 'dart:io';
import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/models/lesson_model.dart';
import 'package:edu_smart_assistant/services/scan_service.dart';
import 'package:edu_smart_assistant/services/tts_service.dart';

class LessonProvider extends ChangeNotifier {
  LessonModel? _currentLesson;
  String? _extractedText;
  String? _audioUrl;
  bool _isProcessing = false;
  String? _errorMessage;
  final ScanService _scanService = ScanService();
  final TtsService _ttsService = TtsService();

  // Getters
  LessonModel? get currentLesson => _currentLesson;
  String? get extractedText => _extractedText;
  String? get audioUrl => _audioUrl;
  bool get isProcessing => _isProcessing;
  bool get isLoading => _isProcessing;
  String? get errorMessage => _errorMessage;

  /// معالجة صورة ملتقطة بالكاميرا — OCR
  /// Backend يعيد النص المستخرج فقط (ليس درس كامل)
  Future<void> processImage(File imageFile) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final extractedText = await _scanService.sendImageForOcr(imageFile);
      _extractedText = extractedText;
      _currentLesson = null;
      _audioUrl = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    _isProcessing = false;
    notifyListeners();
  }

  /// معالجة كود QR
  Future<void> processQr(String qrData) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final lesson = await _scanService.sendQrData(qrData);
      _currentLesson = lesson;
      _extractedText = lesson.originalText;
      _audioUrl = lesson.audioUrl.isNotEmpty ? lesson.audioUrl : null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    _isProcessing = false;
    notifyListeners();
  }

  /// تعيين درس مباشرة
  void loadLesson(LessonModel lesson) {
    _currentLesson = lesson;
    _extractedText = lesson.originalText;
    _audioUrl = lesson.audioUrl.isNotEmpty ? lesson.audioUrl : null;
    notifyListeners();
  }

  /// تعيين درس (alias لـ loadLesson)
  void setLesson(LessonModel lesson) => loadLesson(lesson);

  /// توليد صوت من النص الحالي
  Future<void> generateAudio() async {
    if (_extractedText == null || _extractedText!.isEmpty) return;

    _isProcessing = true;
    notifyListeners();

    try {
      final url = await _ttsService.generateSpeech(_extractedText!);
      _audioUrl = url;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    _isProcessing = false;
    notifyListeners();
  }

  /// تعيين النص المستخرج يدوياً
  void setExtractedText(String text) {
    _extractedText = text;
    notifyListeners();
  }

  /// تعيين رابط الصوت يدوياً
  void setAudioUrl(String url) {
    _audioUrl = url;
    notifyListeners();
  }

  /// تعيين حالة التحميل
  void setLoading(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  /// مسح بيانات الدرس الحالي
  void clearLesson() {
    _currentLesson = null;
    _extractedText = null;
    _audioUrl = null;
    _isProcessing = false;
    _errorMessage = null;
    notifyListeners();
  }

  void cleanup() {
    _currentLesson = null;
    _extractedText = null;
    _audioUrl = null;
    _isProcessing = false;
    _errorMessage = null;
    notifyListeners();
  }
}
