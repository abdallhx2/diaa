// ============================================================
// File: report_model.dart
// Purpose: نموذج التقرير — إحصائيات وتقدم الطالب لولي الأمر
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 1 — إعداد البنية الأساسية للتطبيق
// ============================================================

// --- Required Imports ---
// (لا يحتاج imports خارجية)

// --- Implementation Steps ---
// Step 1: إنشاء class ReportModel
//         - class ReportModel { ... }

// Step 2: تعريف الحقول (Fields)
//         - final int lessonsCompleted;            // عدد الدروس المكتملة
//         - final int quizzesTaken;                // عدد الاختبارات المنجزة
//         - final double studyTimeHours;           // ساعات الدراسة الإجمالية
//         - final double progressPercentage;       // نسبة التقدم العامة (0-100)
//         - final double avgQuizScore;             // متوسط درجات الاختبارات
//         - final int dailyStreak;                 // أيام الدراسة المتتالية
//         - final List<dynamic> recentActivities;  // آخر النشاطات

// Step 3: إنشاء Constructor
//         - ReportModel({
//             this.lessonsCompleted = 0,
//             this.quizzesTaken = 0,
//             this.studyTimeHours = 0.0,
//             this.progressPercentage = 0.0,
//             this.avgQuizScore = 0.0,
//             this.dailyStreak = 0,
//             this.recentActivities = const [],
//           });

// Step 4: إنشاء factory fromJson(Map<String, dynamic> json)
//         - factory ReportModel.fromJson(Map<String, dynamic> json) {
//             return ReportModel(
//               lessonsCompleted: json['lessons_completed'] ?? 0,
//               quizzesTaken: json['quizzes_taken'] ?? 0,
//               studyTimeHours: (json['study_time_hours'] ?? 0).toDouble(),
//               progressPercentage: (json['progress_percentage'] ?? 0).toDouble(),
//               avgQuizScore: (json['avg_quiz_score'] ?? 0).toDouble(),
//               dailyStreak: json['daily_streak'] ?? 0,
//               recentActivities: json['recent_activities'] ?? [],
//             );
//           }

// --- Notes ---
// - هذا النموذج للقراءة فقط (لا يحتاج toJson) — البيانات تأتي من السيرفر
// - recentActivities قائمة بآخر النشاطات (دروس، اختبارات)
// - كل عنصر في recentActivities يحتوي على: lesson_name, quiz_type, score, date
// - يستخدم في parent_dashboard_screen.dart و reports_screen.dart
// - يعرض بواسطة ReportCardWidget
// - progressPercentage هي نسبة تقدم الطفل الإجمالية
// - dailyStreak يحفز الطفل على الدراسة اليومية
