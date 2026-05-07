import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/providers/parent_provider.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';

class ParentResultsScreen extends StatelessWidget {
  const ParentResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: SafeArea(
        child: Column(
          children: [
            const DiyaaInnerNav(title: 'نتائج الاختبارات'),
            Expanded(
              child: Consumer<ParentProvider>(
                builder: (_, parentProvider, __) {
                  final report = parentProvider.weeklyReport;
                  final results = _extractResults(report?.recentActivities);

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        if (results.isNotEmpty)
                          _buildLastResultSummary(results.first),
                        if (results.isEmpty)
                          _buildEmptyState()
                        else
                          _buildResultsTable(results),
                        const SizedBox(height: 24),
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

  List<_ResultRow> _extractResults(List<dynamic>? activities) {
    if (activities == null) return const [];
    return activities.whereType<Map>().map((a) {
      final scoreNum = (a['score'] is num)
          ? (a['score'] as num).toDouble()
          : double.tryParse(a['score']?.toString() ?? '') ?? 0.0;
      // assume score in 0..100 — convert to /10 for display
      final tenth = (scoreNum / 10).round().clamp(0, 10);
      return _ResultRow(
        type: _arabicType(a['quiz_type']?.toString() ?? ''),
        score: '$tenth/10',
        scoreValue: tenth,
        date: a['date']?.toString() ?? '',
        lessonName: a['lesson_name']?.toString() ?? '',
      );
    }).toList();
  }

  String _arabicType(String type) {
    switch (type) {
      case 'reading':
        return 'تمرين قراءة';
      case 'writing':
        return 'تمرين كتابة';
      case 'comprehension':
        return 'استيعاب';
      default:
        return type.isEmpty ? 'اختبار' : type;
    }
  }

  Widget _buildLastResultSummary(_ResultRow last) {
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primary200.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text('🏆', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'آخر نتيجة',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.primary200,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  last.lessonName.isNotEmpty
                      ? '${last.type} · ${last.lessonName} · ${last.score}'
                      : '${last.type} · ${last.score}',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text100,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (last.date.isNotEmpty)
                  Text(
                    last.date,
                    style: GoogleFonts.tajawal(
                      color: AppTheme.text200,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          const Text('📝', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'لا توجد نتائج بعد',
            style: GoogleFonts.tajawal(
              color: AppTheme.text100,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'ستظهر درجات الاختبارات هنا فور إجرائها',
            style: GoogleFonts.tajawal(
              color: AppTheme.text200,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsTable(List<_ResultRow> results) {
    return Container(
      margin: const EdgeInsets.all(14),
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppTheme.bg100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'النوع',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text200,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'الدرجة',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text200,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'التاريخ',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text200,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.bg200),
          ...results.map(_buildResultRow),
        ],
      ),
    );
  }

  Widget _buildResultRow(_ResultRow result) {
    final isGreen = result.scoreValue >= 8;
    final bgColor =
        isGreen ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0);
    final textColor =
        isGreen ? const Color(0xFF2E7D32) : const Color(0xFFE65100);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.bg200, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              result.type,
              style: GoogleFonts.tajawal(
                color: AppTheme.text100,
                fontSize: 13,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              result.score,
              style: GoogleFonts.tajawal(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 70,
            child: Text(
              result.date,
              style: GoogleFonts.tajawal(
                color: AppTheme.text200,
                fontSize: 12,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultRow {
  final String type;
  final String score;
  final int scoreValue;
  final String date;
  final String lessonName;

  const _ResultRow({
    required this.type,
    required this.score,
    required this.scoreValue,
    required this.date,
    this.lessonName = '',
  });
}
