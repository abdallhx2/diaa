import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/parent_provider.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/screens/parent/my_children_screen.dart';
import 'package:edu_smart_assistant/screens/parent/completed_lessons_screen.dart';
import 'package:edu_smart_assistant/screens/parent/parent_progress_screen.dart';
import 'package:edu_smart_assistant/screens/parent/parent_results_screen.dart';

class ParentHomeTab extends StatelessWidget {
  const ParentHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final parentProvider = context.watch<ParentProvider>();
    final authProvider = context.watch<AuthProvider>();
    final parentName =
        authProvider.currentUser?.name ?? 'ولي الأمر';
    final child = parentProvider.selectedChild;
    final report = parentProvider.weeklyReport;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopBar(
              context,
              parentName,
              child?.name ?? '-',
              child?.grade ?? '-',
            ),
            _buildChildSummaryCard(
              child?.name ?? '-',
              child?.grade ?? '-',
              report,
            ),
            _buildMenuItems(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    String parentName,
    String childName,
    String childGrade,
  ) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
              left: 20, right: 20, top: 16, bottom: 32),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A0F30), AppTheme.primary200],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً،',
                  style: GoogleFonts.tajawal(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  parentName,
                  style: GoogleFonts.tajawal(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '👧 الطالب: $childName · الصف $childGrade',
                        style: GoogleFonts.tajawal(
                          color: AppTheme.accent100,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyChildrenScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 11, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'أبنائي',
                          style: GoogleFonts.tajawal(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 20,
            decoration: const BoxDecoration(
              color: AppTheme.bg100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChildSummaryCard(
      String childName, String childGrade, dynamic report) {
    final lessons = report?.lessonsCompleted ?? 0;
    final avgScoreRaw = report?.averageQuizScore ?? 0.0;
    final avgScore = (avgScoreRaw is num) ? avgScoreRaw.round() : 0;
    final streak = report?.streak ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14).copyWith(top: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0x148B5FBF), Color(0x0A61398F)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1F8B5FBF)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppTheme.primary100, AppTheme.primary200],
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  childName.isNotEmpty ? childName[0] : '👧',
                  style: GoogleFonts.tajawal(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    childName,
                    style: GoogleFonts.tajawal(
                      color: AppTheme.text100,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'الصف $childGrade',
                    style: GoogleFonts.tajawal(
                      color: AppTheme.text200,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'نشطة ✓',
                  style: GoogleFonts.tajawal(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildStatCard(
                '$lessons',
                'دروس مكتملة',
              ),
              const SizedBox(width: 8),
              _buildStatCard(
                '$avgScore%',
                'متوسط الاختبارات',
              ),
              const SizedBox(width: 8),
              _buildStatCard(
                '🔥 $streak',
                'أيام متتالية',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: GoogleFonts.tajawal(
                color: AppTheme.primary200,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.tajawal(
                color: AppTheme.text200,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final items = [
      _MenuItem(
        emoji: '✅',
        title: 'الدروس المكتملة',
        description: 'عرض تفاصيل كل درس',
        gradientColors: [const Color(0xFFA18CD1), const Color(0xFFFBC2EB)],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompletedLessonsScreen()),
        ),
      ),
      _MenuItem(
        emoji: '📊',
        title: 'التقدم والمستوى',
        description: 'متابعة أداء الطالب',
        gradientColors: [const Color(0xFF89F7FE), const Color(0xFF66A6FF)],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ParentProgressScreen()),
        ),
      ),
      _MenuItem(
        emoji: '🏆',
        title: 'نتائج الاختبارات',
        description: 'سجل كامل للدرجات',
        gradientColors: [const Color(0xFFFDDB92), const Color(0xFFD1FDFF)],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ParentResultsScreen()),
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14).copyWith(top: 14),
      child: Column(
        children: items
            .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildMenuItem(item),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  gradient: LinearGradient(colors: item.gradientColors),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.tajawal(
                        color: AppTheme.text100,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.description,
                      style: GoogleFonts.tajawal(
                        color: AppTheme.text200,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '‹',
                style: GoogleFonts.tajawal(
                  color: AppTheme.accent200,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final String emoji;
  final String title;
  final String description;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _MenuItem({
    required this.emoji,
    required this.title,
    required this.description,
    required this.gradientColors,
    required this.onTap,
  });
}
