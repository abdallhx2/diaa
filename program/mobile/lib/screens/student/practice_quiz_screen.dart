import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/providers/quiz_provider.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';
import 'package:edu_smart_assistant/widgets/custom_button.dart';

class PracticeQuizScreen extends StatefulWidget {
  final String lessonId;
  final String lessonTitle;

  const PracticeQuizScreen({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  State<PracticeQuizScreen> createState() => _PracticeQuizScreenState();
}

class _PracticeQuizScreenState extends State<PracticeQuizScreen> {
  int _selectedOption = -1;
  bool _showResult = false;
  bool _lastAnswerCorrect = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().loadQuizzes(widget.lessonId, 'multiple_choice');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: Column(
        children: [
          DiyaaInnerNav(title: 'تمرّن — ${widget.lessonTitle}'),
          Expanded(
            child: Consumer<QuizProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.isCompleted) {
                  return _buildResult(context, provider);
                }
                if (provider.quizzes.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد أسئلة لهذا الدرس',
                      style: GoogleFonts.tajawal(
                        color: AppTheme.text200,
                        fontSize: 14,
                      ),
                    ),
                  );
                }
                return _buildQuestion(context, provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(BuildContext context, QuizProvider provider) {
    final quiz = provider.currentQuiz!;
    final total = provider.totalQuestions;
    final current = provider.currentQuizIndex + 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'السؤال $current من $total',
                style: GoogleFonts.tajawal(
                  color: AppTheme.text200,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Row(
                children: List.generate(total, (i) {
                  return Container(
                    width: 24,
                    height: 6,
                    margin: EdgeInsets.only(left: i < total - 1 ? 4 : 0),
                    decoration: BoxDecoration(
                      color: i < current ? AppTheme.primary100 : AppTheme.bg200,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x108B5FBF),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.questionText,
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text100,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 14),
                if (_showResult)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: _lastAnswerCorrect
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _lastAnswerCorrect
                          ? 'أحسنت! إجابة صحيحة'
                          : 'إجابة خاطئة، حاول مرة أخرى',
                      style: GoogleFonts.tajawal(
                        color: _lastAnswerCorrect
                            ? const Color(0xFF2E7D32)
                            : AppTheme.errorColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ...List.generate(quiz.options.length, (i) {
                  final isSelected = _selectedOption == i;
                  return GestureDetector(
                    onTap: _showResult
                        ? null
                        : () => setState(() => _selectedOption = i),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primary100.withValues(alpha: 0.08)
                            : AppTheme.bg100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isSelected ? AppTheme.primary100 : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        quiz.options[i],
                        style: GoogleFonts.tajawal(
                          color: isSelected
                              ? AppTheme.primary200
                              : AppTheme.text100,
                          fontSize: 13.5,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                if (_showResult)
                  CustomButton(
                    text: current < total ? 'السؤال التالي' : 'عرض النتيجة',
                    onPressed: () {
                      setState(() {
                        _selectedOption = -1;
                        _showResult = false;
                      });
                      provider.nextQuestion();
                    },
                  )
                else
                  CustomButton(
                    text: 'تأكيد الإجابة',
                    onPressed: _selectedOption >= 0
                        ? () async {
                            final answer = quiz.options[_selectedOption];
                            await provider.submitAnswer(quiz.id, answer);
                            final result = provider.results.isNotEmpty
                                ? provider.results.last
                                : null;
                            if (mounted) {
                              setState(() {
                                _showResult = true;
                                _lastAnswerCorrect = result?.isCorrect ?? false;
                              });
                            }
                          }
                        : null,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(BuildContext context, QuizProvider provider) {
    final correct = provider.correctCount;
    final total = provider.totalQuestions;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'أحسنت!',
              style: GoogleFonts.tajawal(
                color: AppTheme.primary200,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'نتيجتك $correct/$total',
              style: GoogleFonts.tajawal(
                color: AppTheme.text100,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'إعادة التمرين',
              onPressed: () {
                setState(() {
                  _selectedOption = -1;
                  _showResult = false;
                  _lastAnswerCorrect = false;
                });
                provider.reset();
                provider.loadQuizzes(widget.lessonId, 'multiple_choice');
              },
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'اختر مادة أخرى',
                style: GoogleFonts.tajawal(
                  color: AppTheme.primary200,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
