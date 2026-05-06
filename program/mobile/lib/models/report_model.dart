class ReportModel {
  final int lessonsCompleted;
  final int quizzesCompleted;
  final int totalStudyMinutes;
  final double progressScore;
  final double averageQuizScore;
  final int streak;
  final List<dynamic> recentActivities;

  const ReportModel({
    this.lessonsCompleted = 0,
    this.quizzesCompleted = 0,
    this.totalStudyMinutes = 0,
    this.progressScore = 0.0,
    this.averageQuizScore = 0.0,
    this.streak = 0,
    this.recentActivities = const [],
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      lessonsCompleted: json['lessons_completed'] ?? 0,
      quizzesCompleted: json['quizzes_completed'] ?? 0,
      totalStudyMinutes: json['total_study_minutes'] ?? 0,
      progressScore: (json['progress_score'] ?? 0).toDouble(),
      averageQuizScore: (json['average_quiz_score'] ?? 0).toDouble(),
      streak: json['streak'] ?? 0,
      recentActivities: json['recent_activities'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'lessons_completed': lessonsCompleted,
        'quizzes_completed': quizzesCompleted,
        'total_study_minutes': totalStudyMinutes,
        'progress_score': progressScore,
        'average_quiz_score': averageQuizScore,
        'streak': streak,
        'recent_activities': recentActivities,
      };

  ReportModel copyWith({
    int? lessonsCompleted,
    int? quizzesCompleted,
    int? totalStudyMinutes,
    double? progressScore,
    double? averageQuizScore,
    int? streak,
    List<dynamic>? recentActivities,
  }) {
    return ReportModel(
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      progressScore: progressScore ?? this.progressScore,
      averageQuizScore: averageQuizScore ?? this.averageQuizScore,
      streak: streak ?? this.streak,
      recentActivities: recentActivities ?? this.recentActivities,
    );
  }
}
