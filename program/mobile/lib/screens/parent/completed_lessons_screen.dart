import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/providers/parent_provider.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';

class CompletedLessonsScreen extends StatelessWidget {
  const CompletedLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: SafeArea(
        child: Column(
          children: [
            const DiyaaInnerNav(title: 'الدروس المكتملة'),
            Expanded(
              child: Consumer<ParentProvider>(
                builder: (_, parentProvider, __) {
                  final report = parentProvider.weeklyReport;
                  final lessons = _extractLessons(report?.recentActivities);
                  final total = report?.lessonsCompleted ?? lessons.length;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        _buildSummaryBadge(total),
                        const SizedBox(height: 10),
                        if (lessons.isEmpty)
                          _buildEmptyState()
                        else
                          ...lessons.map((lesson) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _buildLessonCard(lesson),
                              )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_Lesson> _extractLessons(List<dynamic>? activities) {
    if (activities == null) return const [];
    return activities
        .whereType<Map>()
        .map((a) => _Lesson(
              name: a['lesson_name']?.toString() ?? 'درس',
              subject: a['subject']?.toString() ?? '',
              day: a['date']?.toString() ?? '',
            ))
        .toList();
  }

  Widget _buildSummaryBadge(int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primary200.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text('✅', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إجمالي الدروس المكتملة',
                style: GoogleFonts.tajawal(
                  color: AppTheme.primary200,
                  fontSize: 13,
                ),
              ),
              Text(
                '$total درس',
                style: GoogleFonts.tajawal(
                  color: AppTheme.text100,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          const Text('📚', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'لم يكمل الطالب أي درس بعد',
            style: GoogleFonts.tajawal(
              color: AppTheme.text100,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'ستظهر الدروس هنا فور إكمالها',
            style: GoogleFonts.tajawal(
              color: AppTheme.text200,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(_Lesson lesson) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Text('✅', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.name,
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text100,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (lesson.subject.isNotEmpty || lesson.day.isNotEmpty)
                  Text(
                    [
                      if (lesson.subject.isNotEmpty) lesson.subject,
                      if (lesson.day.isNotEmpty) lesson.day,
                    ].join(' · '),
                    style: GoogleFonts.tajawal(
                      color: AppTheme.text200,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'مكتمل',
              style: GoogleFonts.tajawal(
                color: const Color(0xFF2E7D32),
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Lesson {
  final String name;
  final String subject;
  final String day;

  const _Lesson({
    required this.name,
    required this.subject,
    required this.day,
  });
}
