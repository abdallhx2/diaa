class LessonDetailModel {
  final String id;
  final String title;
  final String subject;
  final String gradeLevel;
  final String originalText;
  final String summary;
  final String audioUrl;

  const LessonDetailModel({
    required this.id,
    required this.title,
    this.subject = '',
    this.gradeLevel = '',
    this.originalText = '',
    this.summary = '',
    this.audioUrl = '',
  });

  factory LessonDetailModel.fromJson(Map<String, dynamic> json) {
    return LessonDetailModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      gradeLevel: json['grade_level'] ?? '',
      originalText: json['original_text'] ?? '',
      summary: json['summary'] ?? '',
      audioUrl: json['audio_url'] ?? '',
    );
  }
}
