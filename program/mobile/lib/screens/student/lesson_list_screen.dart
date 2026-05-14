import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/providers/lessons_provider.dart';
import 'package:edu_smart_assistant/models/lesson_model.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';
import 'package:edu_smart_assistant/screens/student/lesson_detail_screen.dart';

class LessonListScreen extends StatefulWidget {
  final String subjectName;
  final String subjectGrade;

  const LessonListScreen({
    super.key,
    required this.subjectName,
    required this.subjectGrade,
  });

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<LessonsProvider>()
          .loadLessons(widget.subjectGrade, widget.subjectName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: Column(
        children: [
          DiyaaInnerNav(title: '${widget.subjectName} — ${widget.subjectGrade}'),
          Expanded(
            child: Consumer<LessonsProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.lessons.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد دروس متاحة لصفك حالياً',
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
                        'اختر الدرس',
                        style: GoogleFonts.tajawal(
                          color: AppTheme.text200,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ...provider.lessons
                          .map((lesson) => _buildLessonItem(context, lesson)),
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

  Widget _buildLessonItem(BuildContext context, LessonModel lesson) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: InkWell(
          onTap: () => _openLesson(context, lesson),
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: AppTheme.bg200,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '○',
                    style: TextStyle(
                      color: AppTheme.text200,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: GoogleFonts.tajawal(
                          color: AppTheme.text100,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lesson.subject,
                        style: GoogleFonts.tajawal(
                          color: AppTheme.text200,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _openLesson(context, lesson),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'ابدأ',
                      style: GoogleFonts.tajawal(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openLesson(BuildContext context, LessonModel lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonDetailScreen(
          lessonId: lesson.id,
          lessonName: lesson.title,
        ),
      ),
    );
  }
}
