class StudentModel {
  final String id;
  final String userId;
  final String? parentId;
  final String name;
  final int? age;
  final String grade;
  final String? learningLevel;
  final double progressScore;
  final DateTime? createdAt;

  const StudentModel({
    required this.id,
    required this.userId,
    this.parentId,
    required this.name,
    this.age,
    required this.grade,
    this.learningLevel,
    this.progressScore = 0.0,
    this.createdAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      parentId: json['parent_id']?.toString(),
      name: json['name'] ?? '',
      age: json['age'],
      grade: json['grade'] ?? '',
      learningLevel: json['learning_level'],
      progressScore: (json['progress_score'] ?? 0).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'parent_id': parentId,
        'name': name,
        'age': age,
        'grade': grade,
        'learning_level': learningLevel,
        'progress_score': progressScore,
        'created_at': createdAt?.toIso8601String(),
      };

  StudentModel copyWith({
    String? id,
    String? userId,
    String? parentId,
    String? name,
    int? age,
    String? grade,
    String? learningLevel,
    double? progressScore,
    DateTime? createdAt,
  }) {
    return StudentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      age: age ?? this.age,
      grade: grade ?? this.grade,
      learningLevel: learningLevel ?? this.learningLevel,
      progressScore: progressScore ?? this.progressScore,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
