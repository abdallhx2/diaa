import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';

class QuizSelectionScreen extends StatelessWidget {
  const QuizSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: Column(
        children: [
          DiyaaInnerNav(
            title: 'اختر نوع الاختبار',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildQuizTypeCard(
                    context: context,
                    icon: Icons.menu_book,
                    title: 'اختبار القراءة',
                    description: 'اقرأ الكلمات واختر النطق الصحيح',
                    colors: const [Color(0xFF8B5FBF), Color(0xFF61398F)],
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.readingQuiz),
                  ),
                  const SizedBox(height: 16),
                  _buildQuizTypeCard(
                    context: context,
                    icon: Icons.edit_note,
                    title: 'اختبار الكتابة',
                    description: 'أجب عن أسئلة الكتابة',
                    colors: const [Color(0xFF4CAF50), Color(0xFF388E3C)],
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.writingQuiz),
                  ),
                  const SizedBox(height: 16),
                  _buildQuizTypeCard(
                    context: context,
                    icon: Icons.psychology,
                    title: 'اختبار الاستيعاب',
                    description: 'اقرأ النص وأجب عن الأسئلة',
                    colors: const [Color(0xFFE88D67), Color(0xFFD4724A)],
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.comprehensionQuiz),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizTypeCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            boxShadow: const [
              BoxShadow(
                color: Color(0x148B5FBF),
                blurRadius: 12,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 28, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.tajawal(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.text100,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: GoogleFonts.tajawal(
                        fontSize: 12.5,
                        color: AppTheme.text200,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '\u2039',
                style: TextStyle(
                  color: AppTheme.accent200,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
