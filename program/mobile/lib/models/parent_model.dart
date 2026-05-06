import 'package:edu_smart_assistant/models/student_model.dart';

class ParentModel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final List<StudentModel> children;
  final DateTime? createdAt;

  const ParentModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    this.phone = '',
    this.children = const [],
    this.createdAt,
  });

  /// عدد الأطفال — محسوب من القائمة بدلاً من حقل منفصل
  int get numChildren => children.length;

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => StudentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'email': email,
        'phone': phone,
        'children': children.map((e) => e.toJson()).toList(),
        'created_at': createdAt?.toIso8601String(),
      };

  ParentModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? email,
    String? phone,
    List<StudentModel>? children,
    DateTime? createdAt,
  }) {
    return ParentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      children: children ?? this.children,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
