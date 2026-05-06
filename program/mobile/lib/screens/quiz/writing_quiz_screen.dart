import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/quiz_provider.dart';
import 'package:edu_smart_assistant/providers/lesson_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';
import 'package:edu_smart_assistant/widgets/custom_button.dart';
import 'package:edu_smart_assistant/widgets/loading_widget.dart';

class WritingQuizScreen extends StatefulWidget {
  const WritingQuizScreen({super.key});

  @override
  State<WritingQuizScreen> createState() => _WritingQuizScreenState();
}

class _WritingQuizScreenState extends State<WritingQuizScreen> {
  bool _isAnswered = false;

  // Static demo data
  final String _fullWord = '\u0645\u064E\u062F\u0652\u0631\u064E\u0633\u064E\u0629';
  final List<String> _displayLetters = ['\u0645', '_', '\u0631', '\u0633', '\u0629'];
  final List<String> _letterChoices = ['\u062F', '\u0630', '\u0631', '\u0632', '\u0633', '\u0635'];
  String? _selectedLetter;

  @override
  void initState() {
    super.initState();
    final lessonId =
        context.read<LessonProvider>().currentLesson?.id ?? '';
    Future.microtask(
        () => context.read<QuizProvider>().loadQuizzes(lessonId, 'writing'));
  }

  Future<void> _selectAnswer(String answer, String quizId) async {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
    });

    await context.read<QuizProvider>().submitAnswer(quizId, answer);

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final quizProvider = context.read<QuizProvider>();
    if (quizProvider.currentQuizIndex < quizProvider.totalQuestions - 1) {
      quizProvider.nextQuestion();
      setState(() {
        _isAnswered = false;
        _selectedLetter = null;
      });
    } else {
      quizProvider.nextQuestion();
      Navigator.pushReplacementNamed(context, AppRoutes.quizResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: SafeArea(
        child: Consumer<QuizProvider>(
          builder: (_, quizProvider, __) {
            if (quizProvider.isLoading) {
              return Column(
                children: [
                  DiyaaInnerNav(title: '\u062A\u0645\u0631\u0651\u0646 \u0627\u0644\u0643\u062A\u0627\u0628\u0629'),
                  const Expanded(
                    child: Center(
                      child: LoadingWidget(message: '\u062C\u0627\u0631\u064A \u062A\u062D\u0645\u064A\u0644 \u0627\u0644\u0623\u0633\u0626\u0644\u0629...'),
                    ),
                  ),
                ],
              );
            }

            if (quizProvider.errorMessage != null) {
              return Column(
                children: [
                  DiyaaInnerNav(title: '\u062A\u0645\u0631\u0651\u0646 \u0627\u0644\u0643\u062A\u0627\u0628\u0629'),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 64, color: AppTheme.errorColor),
                          const SizedBox(height: 16),
                          Text(
                            quizProvider.errorMessage!,
                            style: GoogleFonts.tajawal(
                                fontSize: 18, color: AppTheme.text200),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            final quiz = quizProvider.currentQuiz;
            if (quiz == null) {
              return Column(
                children: [
                  DiyaaInnerNav(title: '\u062A\u0645\u0631\u0651\u0646 \u0627\u0644\u0643\u062A\u0627\u0628\u0629'),
                  Expanded(
                    child: Center(
                      child: Text(
                        '\u0644\u0627 \u062A\u0648\u062C\u062F \u0623\u0633\u0626\u0644\u0629 \u0645\u062A\u0627\u062D\u0629',
                        style: GoogleFonts.tajawal(
                            fontSize: 18, color: AppTheme.text200),
                      ),
                    ),
                  ),
                ],
              );
            }

            final current = quizProvider.currentQuizIndex + 1;
            final total = quizProvider.totalQuestions;
            final progressPercent = ((current / total) * 100).round();

            return Column(
              children: [
                DiyaaInnerNav(
                  title: '\u062A\u0645\u0631\u0651\u0646 \u0627\u0644\u0643\u062A\u0627\u0628\u0629',
                  trailing: Text(
                    '${_toArabicDigit(current.toString())}/${_toArabicDigit(total.toString())}',
                    style: GoogleFonts.tajawal(
                      color: AppTheme.text200,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Progress label
                        Row(
                          children: [
                            Text(
                              '\u0627\u0644\u062A\u0642\u062F\u0645',
                              style: GoogleFonts.tajawal(
                                color: AppTheme.text200,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${_toArabicDigit(progressPercent.toString())}\u066A',
                              style: GoogleFonts.tajawal(
                                color: AppTheme.text200,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Progress bar
                        Container(
                          height: 6,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppTheme.bg200,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            alignment: AlignmentDirectional.centerStart,
                            widthFactor: current / total,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.primary200,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Top actions
                        Row(
                          children: [
                            Text(
                              '\u270F\uFE0F \u0623\u0643\u0645\u0644 \u0627\u0644\u062D\u0631\u0648\u0641 \u0627\u0644\u0646\u0627\u0642\u0635\u0629',
                              style: GoogleFonts.tajawal(
                                color: AppTheme.text100,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0DDE4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '\uD83D\uDD0A',
                                    style: GoogleFonts.tajawal(fontSize: 14),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '\u0627\u0633\u062A\u0645\u0639',
                                    style: GoogleFonts.tajawal(
                                      color: const Color(0xFF5A5A5A),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Fill blank area
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                '\u0627\u0633\u062A\u0645\u0639 \u062B\u0645 \u0623\u0643\u0645\u0644 \u0627\u0644\u0643\u0644\u0645\u0629',
                                style: GoogleFonts.tajawal(
                                  color: AppTheme.text200,
                                  fontSize: 12.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              // Word display
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _displayLetters.map((letter) {
                                    if (letter == '_') {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 2),
                                        child: Container(
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppTheme.primary100,
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                            color: AppTheme.primary100.withValues(alpha: 0.06),
                                          ),
                                          alignment: Alignment.center,
                                          child: _selectedLetter != null
                                              ? Text(
                                                  _selectedLetter!,
                                                  style: GoogleFonts.tajawal(
                                                    color: AppTheme.text100,
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                )
                                              : null,
                                        ),
                                      );
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: Text(
                                        letter,
                                        style: GoogleFonts.tajawal(
                                          color: AppTheme.text100,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Hint word
                              Text(
                                _fullWord,
                                style: GoogleFonts.tajawal(
                                  color: AppTheme.text200,
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Letter choice label
                        Text(
                          '\u0627\u062E\u062A\u0631 \u0627\u0644\u062D\u0631\u0641 \u0627\u0644\u0645\u0646\u0627\u0633\u0628:',
                          style: GoogleFonts.tajawal(
                            color: AppTheme.text200,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Letter keyboard
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: _letterChoices.map((letter) {
                            final isHighlighted = _selectedLetter == letter;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedLetter = letter;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isHighlighted
                                      ? AppTheme.primary100
                                      : AppTheme.bg200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                child: Text(
                                  letter,
                                  style: GoogleFonts.tajawal(
                                    color: isHighlighted
                                        ? Colors.white
                                        : AppTheme.text100,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        // Next button
                        CustomButton(
                          text: '\u0627\u0644\u062A\u0627\u0644\u064A \u2190',
                          onPressed: _selectedLetter != null
                              ? () => _selectAnswer(
                                  _selectedLetter!, quiz.id)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _toArabicDigit(String input) {
    const arabic = ['\u0660', '\u0661', '\u0662', '\u0663', '\u0664', '\u0665', '\u0666', '\u0667', '\u0668', '\u0669'];
    return input.replaceAllMapped(
      RegExp(r'\d'),
      (match) => arabic[int.parse(match.group(0)!)],
    );
  }
}
