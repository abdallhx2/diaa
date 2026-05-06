class SessionModel {
  final String id;
  final String studentId;
  final String lessonId;
  final String sessionType;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int? durationMinutes;

  const SessionModel({
    required this.id,
    required this.studentId,
    required this.lessonId,
    required this.sessionType,
    required this.startedAt,
    this.endedAt,
    this.durationMinutes,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '',
      lessonId: json['lesson_id']?.toString() ?? '',
      sessionType: json['session_type'] ?? '',
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'])
          : DateTime.now(),
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'])
          : null,
      durationMinutes: json['duration_minutes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'lesson_id': lessonId,
        'session_type': sessionType,
        'started_at': startedAt.toIso8601String(),
        'ended_at': endedAt?.toIso8601String(),
        'duration_minutes': durationMinutes,
      };

  SessionModel copyWith({
    String? id,
    String? studentId,
    String? lessonId,
    String? sessionType,
    DateTime? startedAt,
    DateTime? endedAt,
    int? durationMinutes,
  }) {
    return SessionModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      lessonId: lessonId ?? this.lessonId,
      sessionType: sessionType ?? this.sessionType,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}
