import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/quiz_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/custom_button.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.read<QuizProvider>();
    final score = quizProvider.correctCount;
    final total = quizProvider.totalQuestions;
    final wrong = total - score;

    return Scaffold(
      backgroundColor: AppTheme.primary200,
      body: SafeArea(
        child: Column(
          children: [
            // Top nav
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '\u203A',
                        style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '\u0646\u062A\u064A\u062C\u0629 \u0627\u0644\u0627\u062E\u062A\u0628\u0627\u0631',
                    style: GoogleFonts.tajawal(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Expanded center content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Trophy
                    Text(
                      '\uD83C\uDFC6',
                      style: GoogleFonts.tajawal(fontSize: 32),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\u0623\u062D\u0633\u0646\u062A!',
                      style: GoogleFonts.tajawal(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\u0644\u0642\u062F \u0623\u0646\u0647\u064A\u062A \u0627\u0644\u0627\u062E\u062A\u0628\u0627\u0631',
                      style: GoogleFonts.tajawal(
                        color: AppTheme.accent100,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Score circle
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.30),
                          width: 6,
                        ),
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$score',
                            style: GoogleFonts.tajawal(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            '\u0645\u0646 \u0663',
                            style: GoogleFonts.tajawal(
                              color: Colors.white.withValues(alpha: 0.70),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Breakdown row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  '\u2705',
                                  style: GoogleFonts.tajawal(fontSize: 18),
                                ),
                                Text(
                                  '$score',
                                  style: GoogleFonts.tajawal(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  '\u0625\u062C\u0627\u0628\u0627\u062A \u0635\u062D\u064A\u062D\u0629',
                                  style: GoogleFonts.tajawal(
                                    color: Colors.white.withValues(alpha: 0.70),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  '\u274C',
                                  style: GoogleFonts.tajawal(fontSize: 18),
                                ),
                                Text(
                                  '$wrong',
                                  style: GoogleFonts.tajawal(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  '\u0625\u062C\u0627\u0628\u0627\u062A \u062E\u0627\u0637\u0626\u0629',
                                  style: GoogleFonts.tajawal(
                                    color: Colors.white.withValues(alpha: 0.70),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Encouraging message
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      child: Text(
                        '\uD83C\uDF1F \u0639\u0645\u0644 \u0631\u0627\u0626\u0639! \u0623\u0646\u062A \u062A\u062A\u062D\u0633\u0646 \u0643\u0644 \u064A\u0648\u0645.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Buttons
                    CustomButton(
                      text: '\uD83D\uDD01 \u0625\u0639\u0627\u062F\u0629 \u0627\u0644\u0627\u062E\u062A\u0628\u0627\u0631',
                      variant: ButtonVariant.white,
                      onPressed: () {
                        quizProvider.reset();
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: '\uD83C\uDFE0 \u0627\u0644\u0639\u0648\u062F\u0629 \u0644\u0644\u0631\u0626\u064A\u0633\u064A\u0629',
                      variant: ButtonVariant.ghost,
                      onPressed: () {
                        quizProvider.reset();
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.studentDashboard,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
