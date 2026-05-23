import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/models/quiz_model.dart';
import 'package:edu_smart_assistant/models/quiz_result_model.dart';
import 'package:edu_smart_assistant/services/quiz_service.dart';

class QuizProvider extends ChangeNotifier {
  List<QuizModel> _quizzes = [];
  int _currentQuizIndex = 0;
  Map<String, String> _answers = {};
  List<QuizResultModel> _results = [];
  double _score = 0.0;
  bool _isCompleted = false;
  bool _isLoading = false;
  String? _errorMessage;
  final QuizService _quizService = QuizService();

  List<QuizModel> get quizzes => _quizzes;
  int get currentQuizIndex => _currentQuizIndex;
  QuizModel? get currentQuiz =>
      _quizzes.isNotEmpty && _currentQuizIndex < _quizzes.length
          ? _quizzes[_currentQuizIndex]
          : null;
  Map<String, String> get answers => _answers;
  List<QuizResultModel> get results => _results;
  double get score => _score;
  bool get isCompleted => _isCompleted;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalQuestions => _quizzes.length;
  double get progress =>
      _quizzes.isEmpty ? 0 : (_currentQuizIndex + 1) / _quizzes.length;

  Future<void> loadQuizzes(String lessonId, String type) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // استخدام getQuizzesByLesson إذا توفر lessonId، وإلا getQuizzesByType
      if (lessonId.isNotEmpty) {
        _quizzes = await _quizService.getQuizzesByLesson(lessonId);
      } else {
        _quizzes = await _quizService.getQuizzesByType(type);
      }
      _currentQuizIndex = 0;
      _answers = {};
      _results = [];
      _isCompleted = false;
      _score = 0.0;
    } catch (e) {
      _errorMessage = 'فشل في تحميل الاختبار';
      _quizzes = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> submitAnswer(String quizId, String answer) async {
    _answers[quizId] = answer;

    try {
      final result = await _quizService.submitAnswer(quizId, answer);
      _results.add(result);
    } catch (_) {
      // Store answer locally even if server fails
    }

    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuizIndex < _quizzes.length - 1) {
      _currentQuizIndex++;
      notifyListeners();
    } else {
      calculateResult();
    }
  }

  void calculateResult() {
    if (_quizzes.isNotEmpty && _results.isNotEmpty) {
      final correct = _results.where((r) => r.isCorrect).length;
      _score = (correct / _quizzes.length) * 100;
    } else {
      _score = 0;
    }
    _isCompleted = true;
    notifyListeners();
  }

  int get correctCount => _results.where((r) => r.isCorrect).length;

  void reset() {
    _quizzes = [];
    _currentQuizIndex = 0;
    _answers = {};
    _results = [];
    _score = 0.0;
    _isCompleted = false;
    _errorMessage = null;
    notifyListeners();
  }

  void cleanup() {
    reset();
  }
}
