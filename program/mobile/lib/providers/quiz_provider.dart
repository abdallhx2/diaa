import 'package:flutter/material.dart';

class QuizModel {
  final String id;
  final String question;
  final List<String> options;
  const QuizModel({required this.id, required this.question, required this.options});
}

class QuizResultModel {
  final double score;
  final Map<String, dynamic> details;
  const QuizResultModel({required this.score, this.details = const {}});
}

class QuizService {
  Future<List<QuizModel>> getByType({required String lessonId, required String type}) async => [];
  Future<QuizResultModel> submitQuiz({
    required List<String> quizIds,
    required Map<String, String> answers,
  }) async => const QuizResultModel(score: 0.0);
}

class QuizProvider extends ChangeNotifier {
  List<QuizModel>     _quizzes          = [];
  int                 _currentQuizIndex = 0;
  Map<String, String> _answers          = {};
  double              _score            = 0.0;
  bool                _isCompleted      = false;
  bool                _isLoading        = false;
  String?             _errorMessage;
  QuizResultModel?    _lastResult;
  final QuizService   _quizService      = QuizService();

  List<QuizModel>     get quizzes          => List.unmodifiable(_quizzes);
  int                 get currentQuizIndex => _currentQuizIndex;
  Map<String, String> get answers          => Map.unmodifiable(_answers);
  double              get score            => _score;
  bool                get isCompleted      => _isCompleted;
  bool                get isLoading        => _isLoading;
  String?             get errorMessage     => _errorMessage;
  QuizResultModel?    get lastResult       => _lastResult;
  int                 get totalQuestions   => _quizzes.length;

  QuizModel? get currentQuiz =>
      _quizzes.isNotEmpty ? _quizzes[_currentQuizIndex] : null;

  double get progress =>
      _quizzes.isEmpty ? 0.0 : (_currentQuizIndex + 1) / _quizzes.length;

  bool get currentQuizAnswered =>
      currentQuiz != null && _answers.containsKey(currentQuiz!.id);

  Future<void> loadQuizzes(String lessonId, String type) async {
    _errorMessage = null;
    _isLoading    = true;
    notifyListeners();

    try {
      final List<QuizModel> result =
          await _quizService.getByType(lessonId: lessonId, type: type);
      _quizzes          = result;
      _currentQuizIndex = 0;
      _answers          = {};
      _isCompleted      = false;
      _score            = 0.0;
      _lastResult       = null;
    } catch (e) {
      _errorMessage = 'تعذّر تحميل أسئلة الاختبار. يرجى المحاولة مجدداً.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitAnswer(String quizId, String answer) async {
    _answers[quizId] = answer;

    if (_currentQuizIndex < _quizzes.length - 1) {
      _currentQuizIndex++;
      notifyListeners();
    } else {
      notifyListeners();
      await calculateResult();
    }
  }

  Future<void> calculateResult() async {
    _errorMessage = null;
    _isLoading    = true;
    notifyListeners();

    try {
      final QuizResultModel result = await _quizService.submitQuiz(
        quizIds: _quizzes.map((q) => q.id).toList(),
        answers: _answers,
      );
      _lastResult  = result;
      _score       = result.score;
      _isCompleted = true;
    } catch (e) {
      _errorMessage = 'تعذّر إرسال إجاباتك. يرجى التحقق من الاتصال والمحاولة مجدداً.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _quizzes          = [];
    _currentQuizIndex = 0;
    _answers          = {};
    _score            = 0.0;
    _isCompleted      = false;
    _isLoading        = false;
    _errorMessage     = null;
    _lastResult       = null;
    notifyListeners();
  }
}