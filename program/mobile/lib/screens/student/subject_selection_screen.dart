import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/providers/subjects_provider.dart';
import 'package:edu_smart_assistant/providers/student_provider.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';
import 'package:edu_smart_assistant/screens/student/lesson_list_screen.dart';

class SubjectSelectionScreen extends StatefulWidget {
  const SubjectSelectionScreen({super.key});

  @override
  State<SubjectSelectionScreen> createState() =>
      _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState extends State<SubjectSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final grade =
          context.read<StudentProvider>().studentData?.grade ?? 'الثالث';
      context.read<SubjectsProvider>().loadSubjects(grade);
    });
  }

  static const List<List<Color>> _subjectGradients = [
    [Color(0xFF6B8CFF), Color(0xFFA78BFA)],
    [Color(0xFF43E97B), Color(0xFF38F9D7)],
    [Color(0xFFF093FB), Color(0xFFF5576C)],
    [Color(0xFF4776E6), Color(0xFF8E54E9)],
    [Color(0xFFFA8231), Color(0xFFF7B731)],
    [Color(0xFF00B09B), Color(0xFF96C93D)],
  ];

  static const List<String> _subjectIcons = [
    '📖', '🔬', '🔢', '🌍', '🎨', '📚',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: Column(
        children: [
          const DiyaaInnerNav(title: 'ابدأ التعلم'),
          Expanded(
            child: Consumer<SubjectsProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.subjects.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد مواد متاحة لصفك حالياً',
                      style: GoogleFonts.tajawal(
                        color: AppTheme.text200,
                        fontSize: 15,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  );
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اختر المادة الدراسية',
                        style: GoogleFonts.tajawal(
                          color: AppTheme.text200,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ...provider.subjects.asMap().entries.map((entry) {
                        final index = entry.key;
                        final subject = entry.value;
                        final grade =
                            context.read<StudentProvider>().studentData?.grade ??
                                'الثالث';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildSubjectCard(
                            context,
                            icon: _subjectIcons[index % _subjectIcons.length],
                            gradientColors: _subjectGradients[
                                index % _subjectGradients.length],
                            title: subject,
                            subtitle: 'الصف $grade',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LessonListScreen(
                                    subjectName: subject,
                                    subjectGrade: grade,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
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
                child: Text(icon, style: const TextStyle(fontSize: 26)),
              ),
              const SizedBox(width: 14),
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
