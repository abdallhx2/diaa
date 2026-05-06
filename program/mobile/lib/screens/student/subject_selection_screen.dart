import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';
import 'package:edu_smart_assistant/screens/student/lesson_list_screen.dart';

class SubjectSelectionScreen extends StatelessWidget {
  const SubjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: Column(
        children: [
          const DiyaaInnerNav(title: 'ابدأ التعلم'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title
                  Text(
                    'اختر المادة الدراسية',
                    style: GoogleFonts.tajawal(
                      color: AppTheme.text200,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Subject cards
                  _buildSubjectCard(
                    context,
                    icon: '📖',
                    gradientColors: [
                      const Color(0xFF6B8CFF),
                      const Color(0xFFA78BFA),
                    ],
                    title: 'لغتي',
                    subtitle: '١٢ درساً · الصف الثاني',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LessonListScreen(
                            subjectName: 'لغتي',
                            subjectGrade: 'الصف الثاني',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSubjectCard(
                    context,
                    icon: '🔬',
                    gradientColors: [
                      const Color(0xFF43E97B),
                      const Color(0xFF38F9D7),
                    ],
                    title: 'العلوم',
                    subtitle: '١٠ دروس · الصف الثاني',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LessonListScreen(
                            subjectName: 'العلوم',
                            subjectGrade: 'الصف الثاني',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(
    BuildContext context, {
    required String icon,
    required List<Color> gradientColors,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            border: Border.all(color: Colors.transparent, width: 2),
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
              // Icon container with gradient
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 26),
                ),
              ),
              const SizedBox(width: 14),
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.tajawal(
                        color: AppTheme.text100,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.tajawal(
                        color: AppTheme.text200,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow
              const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: AppTheme.text200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
