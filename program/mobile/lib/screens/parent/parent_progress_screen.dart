import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';
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
            const DiyaaInnerNav(title: '\u0627\u0644\u062a\u0642\u062f\u0645 \u0648\u0627\u0644\u0645\u0633\u062a\u0648\u0649'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildLevelIndicator(),
                    _buildWeeklyChart(),
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

  Widget _buildLevelIndicator() {
    final levels = [
      '\u0636\u0639\u064a\u0641',
      '\u0645\u062a\u0648\u0633\u0637 \u25C4',
      '\u062c\u064a\u062f',
      '\u0645\u062a\u0642\u062f\u0645',
    ];

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
            '\u0627\u0644\u0645\u0633\u062a\u0648\u0649 \u0627\u0644\u062d\u0627\u0644\u064a',
            style: GoogleFonts.tajawal(
              color: AppTheme.text100,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // Level dots
          Row(
            children: List.generate(4, (index) {
              final isFilled = index < 2;
              return Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(
                    left: index < 3 ? 4 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: isFilled ? AppTheme.primary100 : AppTheme.bg200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          // Level labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: levels.map((label) {
              final isActive = label.contains('\u0645\u062a\u0648\u0633\u0637');
              return Text(
                label,
                style: GoogleFonts.tajawal(
                  color: isActive ? AppTheme.primary200 : AppTheme.text200,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    final days = [
      '\u0627\u0644\u0623\u062d\u062f',
      '\u0627\u0644\u0627\u062b\u0646\u064a\u0646',
      '\u0627\u0644\u062b\u0644\u0627\u062b\u0627\u0621',
      '\u0627\u0644\u0623\u0631\u0628\u0639\u0627\u0621',
      '\u0627\u0644\u062e\u0645\u064a\u0633',
      '\u0627\u0644\u062c\u0645\u0639\u0629',
      '\u0627\u0644\u0633\u0628\u062a',
    ];
    final heights = [38.0, 20.0, 62.0, 28.0, 50.0, 42.0, 10.0];
    const highlightedIndex = 2;

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
            '\uD83D\uDCC5 \u0645\u062d\u0627\u0648\u0644\u0627\u062a \u0647\u0630\u0627 \u0627\u0644\u0623\u0633\u0628\u0648\u0639',
            style: GoogleFonts.tajawal(
              color: AppTheme.text100,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final isHighlighted = index == highlightedIndex;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: index < 6 ? 4 : 0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          height: heights[index],
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppTheme.primary100,
                                AppTheme.primary200,
                              ],
                            ),
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
}
