class UserModel {
  final String id;
  final String firebaseUid;
  final String role;
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;
  final bool isActive;

  const UserModel({
    required this.id,
    required this.firebaseUid,
    required this.role,
    required this.name,
    required this.email,
    this.phone = '',
    required this.createdAt,
    this.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      firebaseUid: json['firebase_uid'] ?? '',
      role: json['role'] ?? 'student',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firebase_uid': firebaseUid,
        'role': role,
        'name': name,
        'email': email,
        'phone': phone,
        'created_at': createdAt.toIso8601String(),
        'is_active': isActive,
      };

  UserModel copyWith({
    String? id,
    String? firebaseUid,
    String? role,
    String? name,
    String? email,
    String? phone,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      role: role ?? this.role,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
