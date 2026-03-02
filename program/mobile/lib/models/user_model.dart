// ============================================================
// File: user_model.dart
// Purpose: نموذج المستخدم العام — يمثل بيانات أي مستخدم (طالب/ولي أمر/مدير)
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// (لا يحتاج imports خارجية)

// --- Implementation Steps ---
// Step 1: إنشاء class UserModel
//         - class UserModel { ... }

// Step 2: تعريف الحقول (Fields)
//         - final String id;            // معرف المستخدم من الـ Backend
//         - final String firebaseUid;   // معرف Firebase Auth
//         - final String role;          // الدور: 'student' أو 'parent' أو 'admin'
//         - final String name;          // اسم المستخدم بالعربي
//         - final String email;         // البريد الإلكتروني
//         - final String phone;         // رقم الهاتف
//         - final DateTime createdAt;   // تاريخ إنشاء الحساب
//         - final bool isActive;        // هل الحساب مفعل؟

// Step 3: إنشاء Constructor
//         - UserModel({
//             required this.id,
//             required this.firebaseUid,
//             required this.role,
//             required this.name,
//             required this.email,
//             this.phone = '',
//             required this.createdAt,
//             this.isActive = true,
//           });

// Step 4: إنشاء factory fromJson(Map<String, dynamic> json)
//         - factory UserModel.fromJson(Map<String, dynamic> json) {
//             return UserModel(
//               id: json['id'] ?? '',
//               firebaseUid: json['firebase_uid'] ?? '',
//               role: json['role'] ?? 'student',
//               name: json['name'] ?? '',
//               email: json['email'] ?? '',
//               phone: json['phone'] ?? '',
//               createdAt: DateTime.parse(json['created_at']),
//               isActive: json['is_active'] ?? true,
//             );
//           }

// Step 5: إنشاء toJson() method
//         - Map<String, dynamic> toJson() => {
//             'id': id,
//             'firebase_uid': firebaseUid,
//             'role': role,
//             'name': name,
//             'email': email,
//             'phone': phone,
//             'created_at': createdAt.toIso8601String(),
//             'is_active': isActive,
//           };

// --- Notes ---
// - الأسماء في JSON تستخدم snake_case (من الـ Backend)
// - الأسماء في Dart تستخدم camelCase
// - role يجب أن يكون واحد من: 'student', 'parent', 'admin'
// - يمكن إضافة copyWith() method لاحقاً للتعديل
// - firebaseUid يربط بين حساب Firebase وحساب الـ Backend
