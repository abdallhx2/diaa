class ReportModel {
  final int          lessonsCompleted;
  final int          quizzesTaken;
  final double       studyTimeHours;
  final double       progressPercentage;
  final double       avgQuizScore;
  final int          dailyStreak;
  final List<dynamic> recentActivities;
 
  ReportModel({
    this.lessonsCompleted   = 0,
    this.quizzesTaken       = 0,
    this.studyTimeHours     = 0.0,
    this.progressPercentage = 0.0,
    this.avgQuizScore       = 0.0,
    this.dailyStreak        = 0,
    this.recentActivities   = const [],
  });
 
  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    lessonsCompleted:   json['lessons_completed']   ?? 0,
    quizzesTaken:       json['quizzes_taken']       ?? 0,
    studyTimeHours:     (json['study_time_hours']   ?? 0).toDouble(),
    progressPercentage: (json['progress_percentage'] ?? 0).toDouble(),
    avgQuizScore:       (json['avg_quiz_score']     ?? 0).toDouble(),
    dailyStreak:        json['daily_streak']        ?? 0,
    recentActivities:   json['recent_activities']   ?? [],
  );
}
 