import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/diyaa_top_bar.dart';

class StudentResultsTab extends StatelessWidget {
  const StudentResultsTab({super.key});

  // Demo data until a results provider is available
  static const List<Map<String, dynamic>> _demoResults = [
    {
      'title': '\u0627\u062E\u062A\u0628\u0627\u0631 \u0627\u0644\u0642\u0631\u0627\u0621\u0629',
      'subtitle': '\u0627\u0644\u062F\u0631\u0633 \u0627\u0644\u0623\u0648\u0644 - \u0627\u0644\u0648\u062D\u062F\u0629 \u0661',
      'score': 9,
      'total': 10,
    },
    {
      'title': '\u0627\u062E\u062A\u0628\u0627\u0631 \u0627\u0644\u0641\u0647\u0645',
      'subtitle': '\u0627\u0644\u062F\u0631\u0633 \u0627\u0644\u062B\u0627\u0646\u064A - \u0627\u0644\u0648\u062D\u062F\u0629 \u0661',
      'score': 7,
      'total': 10,
    },
    {
      'title': '\u0627\u062E\u062A\u0628\u0627\u0631 \u0627\u0644\u0643\u062A\u0627\u0628\u0629',
      'subtitle': '\u0627\u0644\u062F\u0631\u0633 \u0627\u0644\u0623\u0648\u0644 - \u0627\u0644\u0648\u062D\u062F\u0629 \u0662',
      'score': 5,
      'total': 10,
    },
  ];

  Color _scoreColor(int score) {
    if (score >= 8) return const Color(0xFF4CAF50);
    if (score >= 6) return const Color(0xFFFFA726);
    return const Color(0xFFE53935);
  }

  @override
  Widget build(BuildContext context) {
    final latestResult = _demoResults.isNotEmpty ? _demoResults.first : null;

    return Column(
      children: [
        const DiyaaTopBar(
          greeting: '\u{1F3C6} \u0646\u062A\u0627\u0626\u062C\u064A',
          name: '',
          subtitle: '\u0633\u062C\u0644 \u0627\u062E\u062A\u0628\u0627\u0631\u0627\u062A\u0643 \u0648\u062F\u0631\u062C\u0627\u062A\u0643',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Latest result card
                if (latestResult != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x148B5FBF),
                          blurRadius: 12,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Text(
                          '\u2B50',
                          style: TextStyle(fontSize: 30),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\u0622\u062E\u0631 \u0646\u062A\u064A\u062C\u0629',
                                style: GoogleFonts.tajawal(
                                  color: AppTheme.text200,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                latestResult['title'] as String,
                                style: GoogleFonts.tajawal(
                                  color: AppTheme.text100,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${latestResult['score']}/${latestResult['total']}',
                                style: GoogleFonts.tajawal(
                                  color: AppTheme.primary200,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 14),
                // All results section title
                Text(
                  '\u062C\u0645\u064A\u0639 \u0627\u0644\u0646\u062A\u0627\u0626\u062C',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text200,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                // Result items list
                ...List.generate(_demoResults.length, (index) {
                  final result = _demoResults[index];
                  final score = result['score'] as int;
                  final total = result['total'] as int;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 13),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  result['title'] as String,
                                  style: GoogleFonts.tajawal(
                                    color: AppTheme.text100,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  result['subtitle'] as String,
                                  style: GoogleFonts.tajawal(
                                    color: AppTheme.text200,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              color: _scoreColor(score),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$score/$total',
                              style: GoogleFonts.tajawal(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
