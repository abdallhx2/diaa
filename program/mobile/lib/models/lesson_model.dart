class LessonModel {
  final String   id;
  final String   title;
  final String   subject;
  final String   gradeLevel;
  final String   originalText;
  final String   qrCode;
  final String   audioUrl;
  final DateTime createdAt;
 
  LessonModel({
    required this.id,
    required this.title,
    this.subject      = '',
    this.gradeLevel   = '',
    required this.originalText,
    this.qrCode       = '',
    this.audioUrl     = '',
    required this.createdAt,
  });
 
  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
    id:           json['id']           ?? '',
    title:        json['title']        ?? '',
    subject:      json['subject']      ?? '',
    gradeLevel:   json['grade_level']  ?? '',
    originalText: json['original_text'] ?? '',
    qrCode:       json['qr_code']      ?? '',
    audioUrl:     json['audio_url']    ?? '',
    createdAt:    DateTime.parse(json['created_at']),
  );
 
  Map<String, dynamic> toJson() => {
    'id':            id,
    'title':         title,
    'subject':       subject,
    'grade_level':   gradeLevel,
    'original_text': originalText,
    'qr_code':       qrCode,
    'audio_url':     audioUrl,
    'created_at':    createdAt.toIso8601String(),
  };
}
