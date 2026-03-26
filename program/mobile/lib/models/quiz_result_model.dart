class QuizResultModel {
  final String              id;
  final String              studentId;
  final String              quizId;
  final double              score;
  final Map<String, dynamic> answersDetail;
  final DateTime            takenAt;
 
  QuizResultModel({
    required this.id,
    required this.studentId,
    required this.quizId,
    required this.score,
    required this.answersDetail,
    required this.takenAt,
  });
 
  factory QuizResultModel.fromJson(Map<String, dynamic> json) => QuizResultModel(
    id:            json['id']         ?? '',
    studentId:     json['student_id'] ?? '',
    quizId:        json['quiz_id']    ?? '',
    score:         (json['score']     ?? 0).toDouble(),
    answersDetail: Map<String, dynamic>.from(json['answers_detail'] ?? {}),
    takenAt:       DateTime.parse(json['taken_at']),
  );
 
  Map<String, dynamic> toJson() => {
    'id':             id,
    'student_id':     studentId,
    'quiz_id':        quizId,
    'score':          score,
    'answers_detail': answersDetail,
    'taken_at':       takenAt.toIso8601String(),
  };
}