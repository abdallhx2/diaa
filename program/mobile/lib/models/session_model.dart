class SessionModel {
  final String    id;
  final String    studentId;
  final String    lessonId;
  final String    sessionType;
  final DateTime  startedAt;
  final DateTime? endedAt;
  final int       durationMinutes;
 
  SessionModel({
    required this.id,
    required this.studentId,
    required this.lessonId,
    required this.sessionType,
    required this.startedAt,
    this.endedAt,
    this.durationMinutes = 0,
  });
 
  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
    id:              json['id']               ?? '',
    studentId:       json['student_id']       ?? '',
    lessonId:        json['lesson_id']        ?? '',
    sessionType:     json['session_type']     ?? '',
    startedAt:       DateTime.parse(json['started_at']),
    endedAt:         json['ended_at'] != null
                       ? DateTime.parse(json['ended_at'])
                       : null,
    durationMinutes: json['duration_minutes'] ?? 0,
  );
 
  Map<String, dynamic> toJson() => {
    'id':               id,
    'student_id':       studentId,
    'lesson_id':        lessonId,
    'session_type':     sessionType,
    'started_at':       startedAt.toIso8601String(),
    'ended_at':         endedAt?.toIso8601String(),
    'duration_minutes': durationMinutes,
  };
}