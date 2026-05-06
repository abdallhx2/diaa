import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';

class PracticeSelectionScreen extends StatelessWidget {
  const PracticeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DiyaaInnerNav(title: '\u062A\u0645\u0631\u0651\u0646'),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\u0627\u062E\u062A\u0631 \u0646\u0648\u0639 \u0627\u0644\u062A\u0645\u0631\u064A\u0646',
                    style: GoogleFonts.tajawal(
                      color: AppTheme.text200,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Reading card
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    elevation: 2,
                    shadowColor: Colors.black.withValues(alpha: 0.06),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.readingQuiz,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 22,
                          horizontal: 20,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF4776E6),
                                    Color(0xFF8E54E9),
                                  ],
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '\uD83D\uDCD6',
                                style: GoogleFonts.tajawal(fontSize: 24),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '\u062A\u0645\u0631\u0651\u0646 \u0627\u0644\u0642\u0631\u0627\u0621\u0629',
                                    style: GoogleFonts.tajawal(
                                      color: AppTheme.text100,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\u0627\u062E\u062A\u0631 \u0627\u0644\u0643\u0644\u0645\u0629 \u0627\u0644\u0635\u062D\u064A\u062D\u0629',
                                    style: GoogleFonts.tajawal(
                                      color: AppTheme.text200,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '\u2039',
                              style: GoogleFonts.tajawal(
                                color: AppTheme.text200,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Writing card
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    elevation: 2,
                    shadowColor: Colors.black.withValues(alpha: 0.06),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.writingQuiz,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 22,
                          horizontal: 20,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFF093FB),
                                    Color(0xFFF5576C),
                                  ],
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '\u270F\uFE0F',
                                style: GoogleFonts.tajawal(fontSize: 24),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '\u062A\u0645\u0631\u0651\u0646 \u0627\u0644\u0643\u062A\u0627\u0628\u0629',
                                    style: GoogleFonts.tajawal(
                                      color: AppTheme.text100,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\u0623\u0643\u0645\u0644 \u0627\u0644\u062D\u0631\u0648\u0641 \u0627\u0644\u0646\u0627\u0642\u0635\u0629',
                                    style: GoogleFonts.tajawal(
                                      color: AppTheme.text200,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '\u2039',
                              style: GoogleFonts.tajawal(
                                color: AppTheme.text200,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
