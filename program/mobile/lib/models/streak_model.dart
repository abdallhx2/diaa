class StreakModel {
  final int currentStreak;
  final int longestStreak;
  final String? lastActivityDate;

  const StreakModel({
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
  });

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longest_streak'] as num?)?.toInt() ?? 0,
      lastActivityDate: json['last_activity_date'] as String?,
    );
  }

  static const StreakModel empty = StreakModel(
    currentStreak: 0,
    longestStreak: 0,
  );
}
