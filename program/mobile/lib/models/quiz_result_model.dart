class QuizResultModel {
  final String id;
  final String studentId;
  final String quizId;
  final String selectedAnswer;
  final bool isCorrect;
  final DateTime? answeredAt;

  const QuizResultModel({
    required this.id,
    required this.studentId,
    required this.quizId,
    required this.selectedAnswer,
    this.isCorrect = false,
    this.answeredAt,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      id: json['id']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '',
      quizId: json['quiz_id']?.toString() ?? '',
      selectedAnswer: json['selected_answer'] ?? '',
      isCorrect: json['is_correct'] ?? false,
      answeredAt: json['answered_at'] != null
          ? DateTime.parse(json['answered_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'quiz_id': quizId,
        'selected_answer': selectedAnswer,
        'is_correct': isCorrect,
        'answered_at': answeredAt?.toIso8601String(),
      };

  QuizResultModel copyWith({
    String? id,
    String? studentId,
    String? quizId,
    String? selectedAnswer,
    bool? isCorrect,
    DateTime? answeredAt,
  }) {
    return QuizResultModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      quizId: quizId ?? this.quizId,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }
}
