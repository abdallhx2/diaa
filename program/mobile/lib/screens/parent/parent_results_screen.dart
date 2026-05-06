import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';
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
            const DiyaaInnerNav(title: '\u0646\u062a\u0627\u0626\u062c \u0627\u0644\u0627\u062e\u062a\u0628\u0627\u0631\u0627\u062a'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildLastResultSummary(),
                    _buildResultsTable(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastResultSummary() {
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primary200.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text('\uD83C\uDFC6', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u0622\u062e\u0631 \u0646\u062a\u064a\u062c\u0629',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.primary200,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\u062a\u0645\u0631\u0651\u0646 \u0627\u0644\u0642\u0631\u0627\u0621\u0629 \u00B7 \u0668/\u0661\u0660',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text100,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\u0627\u0644\u064a\u0648\u0645',
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

  Widget _buildResultsTable() {
    const results = [
      _ResultRow(
          type: '\u0627\u062e\u062a\u0628\u0631', score: '\u0669/\u0661\u0660', scoreValue: 9, date: '\u0623\u0645\u0633'),
      _ResultRow(
          type: '\u062a\u0645\u0631\u0651\u0646 \u0642\u0631\u0627\u0621\u0629',
          score: '\u0668/\u0661\u0660',
          scoreValue: 8,
          date: '\u0627\u0644\u064a\u0648\u0645'),
      _ResultRow(
          type: '\u062a\u0645\u0631\u0651\u0646 \u0643\u062a\u0627\u0628\u0629',
          score: '\u0667/\u0661\u0660',
          scoreValue: 7,
          date: '\u0627\u0644\u0623\u062d\u062f'),
      _ResultRow(
          type: '\u0627\u062e\u062a\u0628\u0631', score: '\u0666/\u0661\u0660', scoreValue: 6, date: '\u0627\u0644\u0633\u0628\u062a'),
      _ResultRow(
          type: '\u062a\u0645\u0631\u0651\u0646 \u0642\u0631\u0627\u0621\u0629',
          score: '\u0661\u0660/\u0661\u0660',
          scoreValue: 10,
          date: '\u0627\u0644\u062c\u0645\u0639\u0629'),
    ];

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
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppTheme.bg100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\u0627\u0644\u0646\u0648\u0639',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text200,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\u0627\u0644\u062f\u0631\u062c\u0629',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text200,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\u0627\u0644\u062a\u0627\u0631\u064a\u062e',
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
          // Data rows
          ...results.map((result) => _buildResultRow(result)),
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
            width: 50,
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

  const _ResultRow({
    required this.type,
    required this.score,
    required this.scoreValue,
    required this.date,
  });
}
