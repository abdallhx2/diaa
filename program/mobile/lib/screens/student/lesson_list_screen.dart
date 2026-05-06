import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';
import 'package:edu_smart_assistant/screens/student/lesson_detail_screen.dart';

class LessonListScreen extends StatelessWidget {
  final String subjectName;
  final String subjectGrade;

  const LessonListScreen({
    super.key,
    required this.subjectName,
    required this.subjectGrade,
  });

  @override
  Widget build(BuildContext context) {
    // Static demo data
    final lessons = [
      {'title': 'الأسرة', 'done': true},
      {'title': 'المدرسة', 'done': true},
      {'title': 'الطبيعة', 'done': false},
      {'title': 'الألوان', 'done': false},
      {'title': 'الحيوانات', 'done': false},
    ];

    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: Column(
        children: [
          DiyaaInnerNav(title: '$subjectName — $subjectGrade'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title
                  Text(
                    'اختر الدرس',
                    style: GoogleFonts.tajawal(
                      color: AppTheme.text200,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Lesson items
                  ...lessons.map((lesson) {
                    final title = lesson['title'] as String;
                    final done = lesson['done'] as bool;
                    return _buildLessonItem(context, title: title, done: done);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonItem(
    BuildContext context, {
    required String title,
    required bool done,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        boxShadow: const [
          BoxShadow(
            color: Color(0x108B5FBF),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LessonDetailScreen(lessonName: title),
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Status circle
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: done
                        ? const Color(0xFFE8F5E9)
                        : AppTheme.bg200,
                    shape: BoxShape.circle,
                    border: done
                        ? null
                        : Border.all(color: AppTheme.text200, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    done ? '✓' : '○',
                    style: TextStyle(
                      color: done
                          ? const Color(0xFF2E7D32)
                          : AppTheme.text200,
                      fontSize: done ? 14 : 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Text column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.tajawal(
                          color: AppTheme.text100,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        done ? 'مكتمل' : 'غير مكتمل',
                        style: GoogleFonts.tajawal(
                          color: AppTheme.text200,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Action button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            LessonDetailScreen(lessonName: title),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: done ? AppTheme.bg200 : AppTheme.primary200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      done ? 'فتح' : 'ابدأ',
                      style: GoogleFonts.tajawal(
                        color: done ? AppTheme.primary200 : Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
