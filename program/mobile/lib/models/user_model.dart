class UserModel {
  final String   id;
  final String   firebaseUid;
  final String   role;
  final String   name;
  final String   email;
  final String   phone;
  final DateTime createdAt;
  final bool     isActive;
 
  UserModel({
    required this.id,
    required this.firebaseUid,
    required this.role,
    required this.name,
    required this.email,
    this.phone     = '',
    required this.createdAt,
    this.isActive  = true,
  });
 
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id:          json['id']           ?? '',
    firebaseUid: json['firebase_uid'] ?? '',
    role:        json['role']         ?? 'student',
    name:        json['name']         ?? '',
    email:       json['email']        ?? '',
    phone:       json['phone']        ?? '',
    createdAt:   DateTime.parse(json['created_at']),
    isActive:    json['is_active']    ?? true,
  );
 
  Map<String, dynamic> toJson() => {
    'id':           id,
    'firebase_uid': firebaseUid,
    'role':         role,
    'name':         name,
    'email':        email,
    'phone':        phone,
    'created_at':   createdAt.toIso8601String(),
    'is_active':    isActive,
  };
}
 











