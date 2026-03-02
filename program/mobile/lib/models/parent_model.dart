// ============================================================
// File: parent_model.dart
// Purpose: نموذج ولي الأمر — بيانات ولي الأمر وقائمة أطفاله
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// import 'package:edu_smart_assistant/models/student_model.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class ParentModel
//         - class ParentModel { ... }

// Step 2: تعريف الحقول (Fields)
//         - final String id;                      // معرف ولي الأمر
//         - final String userId;                   // معرف المستخدم المرتبط
//         - final String name;                     // اسم ولي الأمر
//         - final String email;                    // البريد الإلكتروني
//         - final String phone;                    // رقم الهاتف
//         - final int numChildren;                 // عدد الأطفال المسجلين
//         - final List<StudentModel> children;     // قائمة الأطفال

// Step 3: إنشاء Constructor
//         - ParentModel({
//             required this.id,
//             required this.userId,
//             required this.name,
//             required this.email,
//             this.phone = '',
//             this.numChildren = 0,
//             this.children = const [],
//           });

// Step 4: إنشاء factory fromJson(Map<String, dynamic> json)
//         - factory ParentModel.fromJson(Map<String, dynamic> json) {
//             return ParentModel(
//               id: json['id'] ?? '',
//               userId: json['user_id'] ?? '',
//               name: json['name'] ?? '',
//               email: json['email'] ?? '',
//               phone: json['phone'] ?? '',
//               numChildren: json['num_children'] ?? 0,
//               children: (json['children'] as List<dynamic>?)
//                   ?.map((e) => StudentModel.fromJson(e))
//                   .toList() ?? [],
//             );
//           }

// Step 5: إنشاء toJson() method
//         - Map<String, dynamic> toJson() => {
//             'id': id,
//             'user_id': userId,
//             'name': name,
//             'email': email,
//             'phone': phone,
//             'num_children': numChildren,
//             'children': children.map((e) => e.toJson()).toList(),
//           };

// --- Notes ---
// - children تحتوي على قائمة StudentModel لكل طفل مسجل
// - numChildren يمكن أن يختلف عن children.length إذا لم يتم تحميل كل الأطفال
// - يعتمد على StudentModel — تأكد من import الصحيح
