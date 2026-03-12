class StudentModel {
  final String id;
  final String userId;
  final String parentId;
  final String name;
  final int    age;
  final String grade;
  final String learningLevel;
  final double progressScore;
 
  StudentModel({
    required this.id,
    required this.userId,
    required this.parentId,
    required this.name,
    required this.age,
    required this.grade,
    this.learningLevel = 'مبتدئ',
    this.progressScore = 0.0,
  });
 
  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
    id:            json['id']             ?? '',
    userId:        json['user_id']        ?? '',
    parentId:      json['parent_id']      ?? '',
    name:          json['name']           ?? '',
    age:           json['age']            ?? 0,
    grade:         json['grade']          ?? '',
    learningLevel: json['learning_level'] ?? 'مبتدئ',
    progressScore: (json['progress_score'] ?? 0).toDouble(),
  );
 
  Map<String, dynamic> toJson() => {
    'id':             id,
    'user_id':        userId,
    'parent_id':      parentId,
    'name':           name,
    'age':            age,
    'grade':          grade,
    'learning_level': learningLevel,
    'progress_score': progressScore,
  };
}