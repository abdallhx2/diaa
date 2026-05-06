import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';
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
            const DiyaaInnerNav(title: '\u0627\u0644\u062f\u0631\u0648\u0633 \u0627\u0644\u0645\u0643\u062a\u0645\u0644\u0629'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _buildSummaryBadge(),
                    const SizedBox(height: 10),
                    _buildLessonCards(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primary200.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text('\u2705', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\u0625\u062c\u0645\u0627\u0644\u064a \u0627\u0644\u062f\u0631\u0648\u0633 \u0627\u0644\u0645\u0643\u062a\u0645\u0644\u0629',
                style: GoogleFonts.tajawal(
                  color: AppTheme.primary200,
                  fontSize: 13,
                ),
              ),
              Text(
                '\u0666 \u0645\u0646 \u0661\u0660 \u062f\u0631\u0648\u0633',
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

  Widget _buildLessonCards() {
    const lessons = [
      _Lesson(
          name: '\u0627\u0644\u062d\u0631\u0648\u0641 \u0648\u0627\u0644\u0623\u0635\u0648\u0627\u062a',
          subject: '\u0644\u063a\u0629 \u0639\u0631\u0628\u064a\u0629',
          day: '\u0627\u0644\u0623\u062d\u062f'),
      _Lesson(
          name: '\u0627\u0644\u062c\u0645\u0639 \u0648\u0627\u0644\u0637\u0631\u062d',
          subject: '\u0631\u064a\u0627\u0636\u064a\u0627\u062a',
          day: '\u0627\u0644\u0627\u062b\u0646\u064a\u0646'),
      _Lesson(
          name: '\u0627\u0644\u0643\u0627\u0626\u0646\u0627\u062a \u0627\u0644\u062d\u064a\u0629',
          subject: '\u0639\u0644\u0648\u0645',
          day: '\u0627\u0644\u062b\u0644\u0627\u062b\u0627\u0621'),
      _Lesson(
          name: '\u0627\u0644\u0642\u0631\u0627\u0621\u0629 \u0648\u0627\u0644\u0641\u0647\u0645',
          subject: '\u0644\u063a\u0629 \u0639\u0631\u0628\u064a\u0629',
          day: '\u0627\u0644\u0623\u0631\u0628\u0639\u0627\u0621'),
      _Lesson(
          name: '\u0627\u0644\u0623\u0634\u0643\u0627\u0644 \u0627\u0644\u0647\u0646\u062f\u0633\u064a\u0629',
          subject: '\u0631\u064a\u0627\u0636\u064a\u0627\u062a',
          day: '\u0627\u0644\u062e\u0645\u064a\u0633'),
      _Lesson(
          name: '\u0627\u0644\u0645\u0627\u0621 \u0648\u0627\u0644\u0628\u064a\u0626\u0629',
          subject: '\u0639\u0644\u0648\u0645',
          day: '\u0627\u0644\u062c\u0645\u0639\u0629'),
    ];

    return Column(
      children: lessons
          .map((lesson) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildLessonCard(lesson),
              ))
          .toList(),
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
          // Check icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Text('\u2705', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          // Lesson info
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
                Text(
                  '${lesson.subject} \u00B7 ${lesson.day}',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text200,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // "مكتمل" badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '\u0645\u0643\u062a\u0645\u0644',
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
