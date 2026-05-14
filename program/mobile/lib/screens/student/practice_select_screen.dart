import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/providers/subjects_provider.dart';
import 'package:edu_smart_assistant/providers/lessons_provider.dart';
import 'package:edu_smart_assistant/providers/student_provider.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';
import 'package:edu_smart_assistant/screens/student/practice_quiz_screen.dart';

class PracticeSelectScreen extends StatefulWidget {
  const PracticeSelectScreen({super.key});

  @override
  State<PracticeSelectScreen> createState() => _PracticeSelectScreenState();
}

class _PracticeSelectScreenState extends State<PracticeSelectScreen> {
  String? _loadingSubject;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final grade =
          context.read<StudentProvider>().studentData?.grade ?? 'الثالث';
      context.read<SubjectsProvider>().loadSubjects(grade);
    });
  }

  Future<void> _startPractice(String subject) async {
    final grade =
        context.read<StudentProvider>().studentData?.grade ?? 'الثالث';
    setState(() => _loadingSubject = subject);

    try {
      final lessonsProvider = context.read<LessonsProvider>();
      await lessonsProvider.loadLessons(grade, subject);

      if (!mounted) return;

      final lessons = lessonsProvider.lessons;
      if (lessons.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'لا توجد دروس في هذه المادة',
                style: GoogleFonts.tajawal(),
                textDirection: TextDirection.rtl,
              ),
            ),
          );
        }
        return;
      }

      final lesson = lessons.first;
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PracticeQuizScreen(
            lessonId: lesson.id,
            lessonTitle: lesson.title,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loadingSubject = null);
    }
  }

  static const List<List<Color>> _gradients = [
    [Color(0xFF6B8CFF), Color(0xFFA78BFA)],
    [Color(0xFF43E97B), Color(0xFF38F9D7)],
    [Color(0xFFF093FB), Color(0xFFF5576C)],
    [Color(0xFF4776E6), Color(0xFF8E54E9)],
    [Color(0xFFFA8231), Color(0xFFF7B731)],
    [Color(0xFF00B09B), Color(0xFF96C93D)],
  ];

  static const List<String> _icons = ['📖', '🔬', '🔢', '🌍', '🎨', '📚'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: Column(
        children: [
          const DiyaaInnerNav(title: 'تمرّن'),
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
                        'اختر مادة للتمرين',
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
                        final isLoading = _loadingSubject == subject;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Material(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radius),
                            child: InkWell(
                              onTap: isLoading
                                  ? null
                                  : () => _startPractice(subject),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radius),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
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
                                child: Row(
                                  children: [
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16),
                                        gradient: LinearGradient(
                                          colors: _gradients[
                                              index % _gradients.length],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        _icons[index % _icons.length],
                                        style:
                                            const TextStyle(fontSize: 26),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        subject,
                                        style: GoogleFonts.tajawal(
                                          color: AppTheme.text100,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (isLoading)
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    else
                                      const Icon(
                                        Icons.arrow_back_ios_new,
                                        size: 16,
                                        color: AppTheme.text200,
                                      ),
                                  ],
                                ),
                              ),
                            ),
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
}
