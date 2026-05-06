class ChatMessageModel {
  final String id;
  final String studentId;
  final String? lessonId;
  final String role;
  final String content;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    this.studentId = '',
    this.lessonId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '',
      lessonId: json['lesson_id']?.toString(),
      role: json['role'] ?? 'user',
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'lesson_id': lessonId,
        'role': role,
        'content': content,
        'created_at': createdAt.toIso8601String(),
      };

  ChatMessageModel copyWith({
    String? id,
    String? studentId,
    String? lessonId,
    String? role,
    String? content,
    DateTime? createdAt,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      lessonId: lessonId ?? this.lessonId,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
}
