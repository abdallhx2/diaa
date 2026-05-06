import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/quiz_provider.dart';
import 'package:edu_smart_assistant/providers/lesson_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/quiz_option_widget.dart';
import 'package:edu_smart_assistant/widgets/progress_bar_widget.dart';
import 'package:edu_smart_assistant/widgets/loading_widget.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';

class ComprehensionQuizScreen extends StatefulWidget {
  const ComprehensionQuizScreen({super.key});

  @override
  State<ComprehensionQuizScreen> createState() =>
      _ComprehensionQuizScreenState();
}

class _ComprehensionQuizScreenState extends State<ComprehensionQuizScreen> {
  String? _selectedAnswer;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    final lessonId =
        context.read<LessonProvider>().currentLesson?.id ?? '';
    Future.microtask(() =>
        context.read<QuizProvider>().loadQuizzes(lessonId, 'comprehension'));
  }

  Future<void> _selectAnswer(String answer, String quizId) async {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswer = answer;
      _isAnswered = true;
    });

    await context.read<QuizProvider>().submitAnswer(quizId, answer);

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final quizProvider = context.read<QuizProvider>();
    if (quizProvider.currentQuizIndex < quizProvider.totalQuestions - 1) {
      quizProvider.nextQuestion();
      setState(() {
        _selectedAnswer = null;
        _isAnswered = false;
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
      body: Column(
        children: [
          DiyaaInnerNav(
            title: 'اختبار الاستيعاب',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: Consumer<QuizProvider>(
              builder: (_, quizProvider, __) {
                if (quizProvider.isLoading) {
                  return const Center(
                    child: LoadingWidget(message: 'جاري تحميل الأسئلة...'),
                  );
                }

                if (quizProvider.errorMessage != null) {
                  return Center(
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
                  );
                }

                final quiz = quizProvider.currentQuiz;
                if (quiz == null) {
                  return Center(
                    child: Text(
                      'لا توجد أسئلة متاحة',
                      style: GoogleFonts.tajawal(
                          fontSize: 18, color: AppTheme.text200),
                    ),
                  );
                }

                // Split question text by '---' for passage and question
                final parts = quiz.questionText.split('---');
                final passage = parts.isNotEmpty ? parts[0].trim() : '';
                final question =
                    parts.length > 1 ? parts[1].trim() : quiz.questionText;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'سؤال ${quizProvider.currentQuizIndex + 1} من ${quizProvider.totalQuestions}',
                            style: GoogleFonts.tajawal(
                              fontSize: 16,
                              color: AppTheme.text200,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 8),
                          ProgressBarWidget(
                            value: quizProvider.progress,
                            label: 'التقدم',
                            color: AppTheme.primary200,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            if (passage.isNotEmpty)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(AppTheme.radius),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x148B5FBF),
                                      blurRadius: 12,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  passage,
                                  style: GoogleFonts.tajawal(
                                    fontSize: 18,
                                    height: 1.6,
                                    color: AppTheme.text100,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.primary100.withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(AppTheme.radiusSm),
                              ),
                              child: Text(
                                question,
                                style: GoogleFonts.tajawal(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.text100,
                                ),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...quiz.options.map((option) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: QuizOptionWidget(
                                    text: option,
                                    isSelected: _selectedAnswer == option,
                                    isCorrect: _isAnswered &&
                                            _selectedAnswer == option
                                        ? option == quiz.correctAnswer
                                        : _isAnswered &&
                                                option == quiz.correctAnswer
                                            ? true
                                            : _isAnswered
                                                ? null
                                                : null,
                                    onTap: () =>
                                        _selectAnswer(option, quiz.id),
                                  ),
                                )),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
