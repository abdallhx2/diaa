// ============================================================
// File: student_model.dart
// Purpose: نموذج الطالب — بيانات الطالب ومستوى تقدمه
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// (لا يحتاج imports خارجية)

// --- Implementation Steps ---
// Step 1: إنشاء class StudentModel
//         - class StudentModel { ... }

// Step 2: تعريف الحقول (Fields)
//         - final String id;              // معرف الطالب
//         - final String userId;          // معرف المستخدم المرتبط (UserModel)
//         - final String parentId;        // معرف ولي الأمر
//         - final String name;            // اسم الطالب بالعربي
//         - final int age;               // عمر الطالب
//         - final String grade;           // الصف الدراسي (الأول - السادس)
//         - final String learningLevel;   // مستوى التعلم: 'مبتدئ' / 'متوسط' / 'متقدم'
//         - final double progressScore;   // نسبة التقدم (0.0 - 100.0)

// Step 3: إنشاء Constructor
//         - StudentModel({
//             required this.id,
//             required this.userId,
//             required this.parentId,
//             required this.name,
//             required this.age,
//             required this.grade,
//             this.learningLevel = 'مبتدئ',
//             this.progressScore = 0.0,
//           });

// Step 4: إنشاء factory fromJson(Map<String, dynamic> json)
//         - factory StudentModel.fromJson(Map<String, dynamic> json) {
//             return StudentModel(
//               id: json['id'] ?? '',
//               userId: json['user_id'] ?? '',
//               parentId: json['parent_id'] ?? '',
//               name: json['name'] ?? '',
//               age: json['age'] ?? 0,
//               grade: json['grade'] ?? '',
//               learningLevel: json['learning_level'] ?? 'مبتدئ',
//               progressScore: (json['progress_score'] ?? 0).toDouble(),
//             );
//           }

// Step 5: إنشاء toJson() method
//         - Map<String, dynamic> toJson() => {
//             'id': id,
//             'user_id': userId,
//             'parent_id': parentId,
//             'name': name,
//             'age': age,
//             'grade': grade,
//             'learning_level': learningLevel,
//             'progress_score': progressScore,
//           };

// --- Notes ---
// - grade يكون: 'الأول', 'الثاني', 'الثالث', 'الرابع', 'الخامس', 'السادس'
// - learningLevel يتغير بناءً على أداء الطالب في الاختبارات
// - progressScore هو نسبة مئوية تحسب من الـ Backend
// - parentId يربط الطالب بولي أمره
