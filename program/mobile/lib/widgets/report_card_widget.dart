import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';

/// A versatile report card widget that supports two modes:
/// 1. Stats mode (default): compact card showing icon + value + title
///    Used in parent dashboard stats grid.
/// 2. Detailed mode: shows lesson name, quiz type, score %, date
///    with color coding based on score. Activated when [lessonName] is provided.
class ReportCardWidget extends StatelessWidget {
  // Stats mode fields
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  // Detailed mode fields (optional)
  final String? lessonName;
  final String? quizType;
  final double? score;
  final String? date;

  const ReportCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.lessonName,
    this.quizType,
    this.score,
    this.date,
  });

  /// Factory for creating a detailed report card
  factory ReportCardWidget.detailed({
    Key? key,
    required String lessonName,
    required String quizType,
    required double score,
    required String date,
  }) {
    final cardColor = score >= 80
        ? AppTheme.successColor
        : score >= 60
            ? AppTheme.accent200
            : AppTheme.errorColor;

    final cardIcon = _quizTypeIcon(quizType);

    return ReportCardWidget(
      key: key,
      title: lessonName,
      value: '${score.round()}%',
      icon: cardIcon,
      color: cardColor,
      lessonName: lessonName,
      quizType: quizType,
      score: score,
      date: date,
    );
  }

  static IconData _quizTypeIcon(String type) {
    switch (type) {
      case 'reading':
        return Icons.menu_book;
      case 'writing':
        return Icons.edit_note;
      case 'comprehension':
        return Icons.psychology;
      default:
        return Icons.assignment;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detailed report card mode
    if (lessonName != null) {
      return _buildDetailedCard();
    }
    // Stats card mode (backward compatible)
    return _buildStatsCard();
  }

  Widget _buildStatsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x148B5FBF),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.tajawal(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.tajawal(
                fontSize: 14,
                color: AppTheme.text200,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedCard() {
    final scoreColor = (score ?? 0) >= 80
        ? AppTheme.successColor
        : (score ?? 0) >= 60
            ? AppTheme.accent200
            : AppTheme.errorColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x148B5FBF),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            // Quiz type icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scoreColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Icon(icon, color: scoreColor, size: 28),
            ),
            const SizedBox(width: 12),
            // Lesson info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lessonName!,
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.text100,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _quizTypeLabel(quizType ?? ''),
                    style: GoogleFonts.tajawal(
                      fontSize: 13,
                      color: AppTheme.text200,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            // Score + date
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: scoreColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(score ?? 0).round()}%',
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: scoreColor,
                    ),
                  ),
                ),
                if (date != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    date!,
                    style: GoogleFonts.tajawal(
                      fontSize: 11,
                      color: AppTheme.text200,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _quizTypeLabel(String type) {
    switch (type) {
      case 'reading':
        return 'قراءة';
      case 'writing':
        return 'كتابة';
      case 'comprehension':
        return 'استيعاب';
      default:
        return type;
    }
  }
}
