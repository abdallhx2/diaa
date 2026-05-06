class LessonModel {
  final String id;
  final String title;
  final String subject;
  final String gradeLevel;
  final String originalText;
  final String qrCode;
  final String audioUrl;
  final DateTime createdAt;

  const LessonModel({
    required this.id,
    required this.title,
    this.subject = '',
    this.gradeLevel = '',
    required this.originalText,
    this.qrCode = '',
    this.audioUrl = '',
    required this.createdAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      gradeLevel: json['grade_level'] ?? '',
      originalText: json['original_text'] ?? '',
      qrCode: json['qr_code'] ?? '',
      audioUrl: json['audio_url'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subject': subject,
        'grade_level': gradeLevel,
        'original_text': originalText,
        'qr_code': qrCode,
        'audio_url': audioUrl,
        'created_at': createdAt.toIso8601String(),
      };

  LessonModel copyWith({
    String? id,
    String? title,
    String? subject,
    String? gradeLevel,
    String? originalText,
    String? qrCode,
    String? audioUrl,
    DateTime? createdAt,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      originalText: originalText ?? this.originalText,
      qrCode: qrCode ?? this.qrCode,
      audioUrl: audioUrl ?? this.audioUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
