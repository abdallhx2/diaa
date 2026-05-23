class AchievementModel {
  final String id;
  final String code;
  final String nameAr;
  final String descriptionAr;
  final String iconEmoji;
  final int threshold;
  final String kind;
  final bool isUnlocked;
  final String? unlockedAt;

  const AchievementModel({
    required this.id,
    required this.code,
    required this.nameAr,
    required this.descriptionAr,
    required this.iconEmoji,
    required this.threshold,
    required this.kind,
    required this.isUnlocked,
    this.unlockedAt,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      descriptionAr: json['description_ar'] as String? ?? '',
      iconEmoji: json['icon_emoji'] as String? ?? '🏆',
      threshold: (json['threshold'] as num?)?.toInt() ?? 0,
      kind: json['kind'] as String? ?? '',
      isUnlocked: json['unlocked'] as bool? ?? false,
      unlockedAt: json['unlocked_at'] as String?,
    );
  }
}
