import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/providers/parent_provider.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';

class ParentProgressScreen extends StatelessWidget {
  const ParentProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: SafeArea(
        child: Column(
          children: [
            const DiyaaInnerNav(title: 'التقدم والمستوى'),
            Expanded(
              child: Consumer<ParentProvider>(
                builder: (_, parentProvider, __) {
                  final report = parentProvider.weeklyReport;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildLevelIndicator(report?.progressScore ?? 0.0),
                        _buildWeeklyChart(
                            _buildHeightsFromActivities(
                                report?.recentActivities)),
                        _buildSummaryStats(report),
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

  /// progress 0..100 → 0..4 filled buckets
  int _scoreBucket(double score) {
    if (score >= 90) return 4;
    if (score >= 70) return 3;
    if (score >= 40) return 2;
    if (score > 0) return 1;
    return 0;
  }

  Widget _buildLevelIndicator(double score) {
    final levels = ['ضعيف', 'متوسط', 'جيد', 'متقدم'];
    final bucket = _scoreBucket(score);
    final activeLabelIndex = (bucket - 1).clamp(0, 3);

    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المستوى الحالي',
            style: GoogleFonts.tajawal(
              color: AppTheme.text100,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(4, (index) {
              final isFilled = index < bucket;
              return Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(left: index < 3 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: isFilled ? AppTheme.primary100 : AppTheme.bg200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(levels.length, (index) {
              final isActive = bucket > 0 && index == activeLabelIndex;
              return Text(
                isActive ? '${levels[index]} ◄' : levels[index],
                style: GoogleFonts.tajawal(
                  color: isActive ? AppTheme.primary200 : AppTheme.text200,
                  fontSize: 11,
                  fontWeight:
                      isActive ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }),
          ),
          if (bucket == 0) ...[
            const SizedBox(height: 12),
            Text(
              'لا توجد بيانات كافية لتقييم المستوى بعد',
              style: GoogleFonts.tajawal(
                color: AppTheme.text200,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build 7 daily heights from recent activities.
  /// Empty list → all zeros (chart shows empty bars).
  List<double> _buildHeightsFromActivities(List<dynamic>? activities) {
    final heights = List<double>.filled(7, 0);
    if (activities == null || activities.isEmpty) return heights;

    // Map weekday string -> index 0..6 (Sunday-first)
    const dayMap = {
      'الأحد': 0,
      'الاثنين': 1,
      'الإثنين': 1,
      'الثلاثاء': 2,
      'الأربعاء': 3,
      'الخميس': 4,
      'الجمعة': 5,
      'السبت': 6,
    };

    for (final a in activities) {
      if (a is! Map) continue;
      final day = a['date']?.toString() ?? '';
      final idx = dayMap[day];
      if (idx != null) {
        final scoreNum = (a['score'] is num)
            ? (a['score'] as num).toDouble()
            : double.tryParse(a['score']?.toString() ?? '') ?? 0.0;
        // map 0..100 to 0..70 px so bars fit the 80px row
        final h = (scoreNum * 0.7).clamp(0.0, 70.0);
        if (h > heights[idx]) heights[idx] = h;
      }
    }
    return heights;
  }

  Widget _buildWeeklyChart(List<double> heights) {
    final days = [
      'الأحد',
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
    ];
    final hasData = heights.any((h) => h > 0);
    int? highlightedIndex;
    if (hasData) {
      double maxH = -1;
      for (var i = 0; i < heights.length; i++) {
        if (heights[i] > maxH) {
          maxH = heights[i];
          highlightedIndex = i;
        }
      }
    }

    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📅 محاولات هذا الأسبوع',
            style: GoogleFonts.tajawal(
              color: AppTheme.text100,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          if (!hasData)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  'لا توجد محاولات هذا الأسبوع',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text200,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  final isHighlighted = index == highlightedIndex;
                  final h = heights[index];
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: index < 6 ? 4 : 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: double.infinity,
                            height: h > 0 ? h : 4,
                            decoration: BoxDecoration(
                              gradient: h > 0
                                  ? const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppTheme.primary100,
                                        AppTheme.primary200,
                                      ],
                                    )
                                  : null,
                              color: h > 0 ? null : AppTheme.bg200,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                              boxShadow: isHighlighted
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.primary200
                                            .withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            days[index],
                            style: GoogleFonts.tajawal(
                              color: isHighlighted
                                  ? AppTheme.primary200
                                  : AppTheme.text200,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryStats(dynamic report) {
    if (report == null) return const SizedBox.shrink();
    final lessons = report.lessonsCompleted ?? 0;
    final quizzes = report.quizzesCompleted ?? 0;
    final minutes = report.totalStudyMinutes ?? 0;
    final avg = (report.averageQuizScore ?? 0.0);
    final avgInt = avg is num ? avg.round() : 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ملخص الأداء',
            style: GoogleFonts.tajawal(
              color: AppTheme.text100,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _statRow('📚 دروس مكتملة', '$lessons'),
          _statRow('🧪 اختبارات', '$quizzes'),
          _statRow('⏱️ دقائق تعلم', '$minutes'),
          _statRow('🎯 متوسط الدرجات', '$avgInt%'),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.tajawal(
              color: AppTheme.text200,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.tajawal(
              color: AppTheme.primary200,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
