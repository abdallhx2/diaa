import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/parent_provider.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/custom_button.dart';
import 'package:edu_smart_assistant/screens/parent/my_children_screen.dart';
import 'package:edu_smart_assistant/screens/parent/completed_lessons_screen.dart';
import 'package:edu_smart_assistant/screens/parent/parent_progress_screen.dart';
import 'package:edu_smart_assistant/screens/parent/parent_results_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ParentProvider>().fetchChildren());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: Consumer<ParentProvider>(
        builder: (_, parentProvider, __) {
          if (parentProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primary200,
              ),
            );
          }

          if (!parentProvider.hasChildren) {
            return _buildEmptyState();
          }

          return _buildDashboard(parentProvider);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primary200.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.child_care,
                size: 64,
                color: AppTheme.primary200,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '\u0644\u0645 \u062a\u0642\u0645 \u0628\u0625\u0636\u0627\u0641\u0629 \u0623\u0637\u0641\u0627\u0644 \u0628\u0639\u062f',
              style: GoogleFonts.tajawal(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.text100,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            Text(
              '\u0623\u0636\u0641 \u0637\u0641\u0644\u0643 \u0644\u0645\u062a\u0627\u0628\u0639\u0629 \u062a\u0642\u062f\u0645\u0647 \u0627\u0644\u062f\u0631\u0627\u0633\u064a',
              style: GoogleFonts.tajawal(
                fontSize: 16,
                color: AppTheme.text200,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: '\u0623\u0636\u0641 \u0637\u0641\u0644\u0643 \u0627\u0644\u0623\u0648\u0644',
              icon: Icons.add,
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.addChild),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(ParentProvider parentProvider) {
    final child = parentProvider.selectedChild!;
    final authProvider = context.read<AuthProvider>();
    final parentName = authProvider.currentUser?.name ?? '\u0648\u0644\u064a \u0627\u0644\u0623\u0645\u0631';

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Parent top bar
            _buildTopBar(parentName, child.name, child.grade),

            // 2. Child summary card
            _buildChildSummaryCard(child.name, child.grade),

            // 3. Menu items
            _buildMenuItems(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(String parentName, String childName, String childGrade) {
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
                  '\u0645\u0631\u062d\u0628\u0627\u064b\u060c',
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
                    // Child tag pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '\uD83D\uDC67 \u0627\u0644\u0637\u0627\u0644\u0628: $childName \u00B7 \u0627\u0644\u0635\u0641 $childGrade',
                        style: GoogleFonts.tajawal(
                          color: AppTheme.accent100,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // "أبنائي" button
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
                          '\u0623\u0628\u0646\u0627\u0626\u064a',
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
        // Curved bottom overlay
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

  Widget _buildChildSummaryCard(String childName, String childGrade) {
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
              // Avatar
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
                  childName.isNotEmpty ? childName[0] : '\uD83D\uDC67',
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
                    '\u0627\u0644\u0635\u0641 $childGrade',
                    style: GoogleFonts.tajawal(
                      color: AppTheme.text200,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // "نشطة" badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '\u0646\u0634\u0637\u0629 \u2713',
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
          // Stats row
          Row(
            children: [
              _buildStatCard('\u0666', '\u062f\u0631\u0648\u0633 \u0645\u0643\u062a\u0645\u0644\u0629'),
              const SizedBox(width: 8),
              _buildStatCard('\u0667\u0665\u066A', '\u0645\u062a\u0648\u0633\u0637 \u0627\u0644\u0627\u062e\u062a\u0628\u0627\u0631\u0627\u062a'),
              const SizedBox(width: 8),
              _buildStatCard('\uD83D\uDD25\u0663', '\u0623\u064a\u0627\u0645 \u0645\u062a\u062a\u0627\u0644\u064a\u0629'),
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

  Widget _buildMenuItems() {
    final items = [
      _MenuItem(
        emoji: '\u2705',
        title: '\u0627\u0644\u062f\u0631\u0648\u0633 \u0627\u0644\u0645\u0643\u062a\u0645\u0644\u0629',
        description: '\u0639\u0631\u0636 \u062a\u0641\u0627\u0635\u064a\u0644 \u0643\u0644 \u062f\u0631\u0633',
        gradientColors: [const Color(0xFFA18CD1), const Color(0xFFFBC2EB)],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompletedLessonsScreen()),
        ),
      ),
      _MenuItem(
        emoji: '\uD83D\uDCCA',
        title: '\u0627\u0644\u062a\u0642\u062f\u0645 \u0648\u0627\u0644\u0645\u0633\u062a\u0648\u0649',
        description: '\u0645\u062a\u0627\u0628\u0639\u0629 \u0623\u062f\u0627\u0621 \u0627\u0644\u0637\u0627\u0644\u0628',
        gradientColors: [const Color(0xFF89F7FE), const Color(0xFF66A6FF)],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ParentProgressScreen()),
        ),
      ),
      _MenuItem(
        emoji: '\uD83C\uDFC6',
        title: '\u0646\u062a\u0627\u0626\u062c \u0627\u0644\u0627\u062e\u062a\u0628\u0627\u0631\u0627\u062a',
        description: '\u0633\u062c\u0644 \u0643\u0627\u0645\u0644 \u0644\u0644\u062f\u0631\u062c\u0627\u062a',
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
              // Icon container
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
              // Text
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
              // Arrow
              Text(
                '\u2039',
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
