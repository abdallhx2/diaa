class QuizModel {
  final String       id;
  final String       lessonId;
  final String       quizType;
  final String       questionText;
  final List<String> options;
 
  QuizModel({
    required this.id,
    required this.lessonId,
    required this.quizType,
    required this.questionText,
    required this.options,
  });
 
  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
    id:           json['id']            ?? '',
    lessonId:     json['lesson_id']     ?? '',
    quizType:     json['quiz_type']     ?? '',
    questionText: json['question_text'] ?? '',
    options:      List<String>.from(json['options'] ?? []),
  );
 
  Map<String, dynamic> toJson() => {
    'id':            id,
    'lesson_id':     lessonId,
    'quiz_type':     quizType,
    'question_text': questionText,
    'options':       options,
  };
}
 