import 'dart:convert';

class QuizModel {
  final String id;
  final String lessonId;
  final String quizType;
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final DateTime? createdAt;

  const QuizModel({
    required this.id,
    required this.lessonId,
    required this.quizType,
    required this.questionText,
    required this.options,
    this.correctAnswer = '',
    this.createdAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id']?.toString() ?? '',
      lessonId: json['lesson_id']?.toString() ?? '',
      quizType: json['quiz_type'] ?? '',
      questionText: json['question_text'] ?? '',
      options: _parseOptions(json['options']),
      correctAnswer: json['correct_answer'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  /// يدعم عدة صيغ: List, Map {"a":"val"}, أو String JSON
  static List<String> _parseOptions(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) return List<String>.from(raw);
    if (raw is Map) return raw.values.map((v) => v.toString()).toList();
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) return List<String>.from(decoded);
        if (decoded is Map) {
          return decoded.values.map((v) => v.toString()).toList();
        }
      } catch (_) {}
      return [raw];
    }
    return [];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'lesson_id': lessonId,
        'quiz_type': quizType,
        'question_text': questionText,
        'options': options,
        'correct_answer': correctAnswer,
        'created_at': createdAt?.toIso8601String(),
      };

  QuizModel copyWith({
    String? id,
    String? lessonId,
    String? quizType,
    String? questionText,
    List<String>? options,
    String? correctAnswer,
    DateTime? createdAt,
  }) {
    return QuizModel(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      quizType: quizType ?? this.quizType,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
