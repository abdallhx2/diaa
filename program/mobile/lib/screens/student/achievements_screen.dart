import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/config/design_tokens.dart';
import 'package:edu_smart_assistant/models/achievement_model.dart';
import 'package:edu_smart_assistant/providers/achievement_provider.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';
import 'package:edu_smart_assistant/widgets/feedback/skeleton_list.dart';
import 'package:edu_smart_assistant/widgets/feedback/empty_state.dart';
import 'package:edu_smart_assistant/widgets/feedback/error_state.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AchievementProvider>().loadProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        backgroundColor: AppTheme.bg100,
        body: Column(
          children: [
            const DiyaaInnerNav(title: 'إنجازاتي'),
            Expanded(
              child: Consumer<AchievementProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const SkeletonList(count: 4, cardHeight: 88);
                  }
                  if (provider.errorMessage != null) {
                    return ErrorState(
                      onRetry: () =>
                          context.read<AchievementProvider>().loadProgress(),
                    );
                  }
                  if (provider.achievements.isEmpty) {
                    return const EmptyState(
                      emoji: '🏆',
                      title: 'ما عندك إنجازات بعد',
                      subtitle: 'تابع التعلم وستظهر هنا',
                    );
                  }
                  return _buildContent(provider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AchievementProvider provider) {
    final streak = provider.streak;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStreakSummary(streak.currentStreak, streak.longestStreak),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'الإنجازات',
            style: GoogleFonts.tajawal(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.text200,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.1,
            ),
            itemCount: provider.achievements.length,
            itemBuilder: (context, i) =>
                _buildAchievementCard(provider.achievements[i]),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakSummary(int current, int longest) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary200, AppTheme.primary100],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadow.elevated,
      ),
      child: Column(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 40)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$current يوم متتالي',
            style: GoogleFonts.tajawal(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'أطول سلسلة: $longest أيام',
            style: GoogleFonts.tajawal(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(AchievementModel achievement) {
    return Container(
      decoration: BoxDecoration(
        color: achievement.isUnlocked ? Colors.white : AppTheme.bg200,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: achievement.isUnlocked ? AppShadow.card : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: achievement.isUnlocked
                  ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                  : const ColorFilter.matrix([
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0,      0,      0,      1, 0,
                    ]),
              child: Text(
                achievement.iconEmoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              achievement.nameAr,
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: achievement.isUnlocked
                    ? AppTheme.text100
                    : AppTheme.text200,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              achievement.descriptionAr,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.tajawal(
                fontSize: 10,
                color: AppTheme.text200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
