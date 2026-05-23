import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/providers/student_provider.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/providers/achievement_provider.dart';
import 'package:edu_smart_assistant/widgets/diyaa_top_bar.dart';
import 'package:edu_smart_assistant/widgets/diyaa_menu_card.dart';

class StudentHomeTab extends StatefulWidget {
  const StudentHomeTab({super.key});

  @override
  State<StudentHomeTab> createState() => _StudentHomeTabState();
}

class _StudentHomeTabState extends State<StudentHomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<AchievementProvider>();
      provider.loadProgress().then((_) {
        if (!mounted) return;
        _showUnlockToasts(provider);
      });
    });
  }

  void _showUnlockToasts(AchievementProvider provider) {
    for (final achievement in provider.newlyUnlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: AppTheme.primary200,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Text(achievement.iconEmoji,
                    style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '🎉 فتحت إنجاز: ${achievement.nameAr}',
                    style: GoogleFonts.tajawal(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.watch<StudentProvider>();
    final authProvider = context.watch<AuthProvider>();
    final achievementProvider = context.watch<AchievementProvider>();

    final name = studentProvider.studentData?.name ??
        authProvider.currentUser?.name ??
        'طالب';
    final grade = studentProvider.studentData?.grade ?? '';
    final currentStreak = achievementProvider.streak.currentStreak;

    return Column(
      children: [
        DiyaaTopBar(
          greeting: 'مرحباً 🌟',
          name: name,
          subtitle: grade.isNotEmpty
              ? 'الصف $grade الابتدائي'
              : 'مرحباً بك',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Streak chip
                if (currentStreak > 0)
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.achievements),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFFFB300),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔥',
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            '$currentStreak أيام متتالية',
                            style: GoogleFonts.tajawal(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE65100),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.chevron_left,
                              size: 16, color: Color(0xFFE65100)),
                        ],
                      ),
                    ),
                  ),
                Text(
                  'ماذا تريد أن تفعل؟',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text100,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                DiyaaMenuCard(
                  icon: '📚',
                  iconColors: const [AppTheme.primary200, AppTheme.primary200],
                  title: 'ابدأ التعلم',
                  description: 'دروس الفيديو والملخصات',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.subjects),
                ),
                const SizedBox(height: 12),
                DiyaaMenuCard(
                  icon: '🔊',
                  iconColors: const [Color(0xFF2193B0), Color(0xFF6DD5ED)],
                  title: 'اقرأ لي',
                  description: 'صوّر أي نص وأسمعه لك',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.scanPage),
                ),
                const SizedBox(height: 12),
                DiyaaMenuCard(
                  icon: '✏️',
                  iconColors: const [Color(0xFFEE0979), Color(0xFFFF6A00)],
                  title: 'تمرّن',
                  description: 'اختبر نفسك وتحسّن',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.practiceSelect),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
