class ChatMessageModel {
  final String   id;
  final String   studentId;
  final String   lessonId;
  final String   userMessage;
  final String   botResponse;
  final String   audioUrl;
  final DateTime createdAt;
 
  ChatMessageModel({
    required this.id,
    required this.studentId,
    required this.lessonId,
    required this.userMessage,
    required this.botResponse,
    this.audioUrl  = '',
    required this.createdAt,
  });
 
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
    id:          json['id']           ?? '',
    studentId:   json['student_id']   ?? '',
    lessonId:    json['lesson_id']    ?? '',
    userMessage: json['user_message'] ?? '',
    botResponse: json['bot_response'] ?? '',
    audioUrl:    json['audio_url']    ?? '',
    createdAt:   DateTime.parse(json['created_at']),
  );
 
  Map<String, dynamic> toJson() => {
    'id':           id,
    'student_id':   studentId,
    'lesson_id':    lessonId,
    'user_message': userMessage,
    'bot_response': botResponse,
    'audio_url':    audioUrl,
    'created_at':   createdAt.toIso8601String(),
  };
}