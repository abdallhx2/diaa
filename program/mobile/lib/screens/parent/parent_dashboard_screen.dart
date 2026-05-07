import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/parent_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/custom_button.dart';
import 'package:edu_smart_assistant/widgets/diyaa_bottom_nav.dart';
import 'package:edu_smart_assistant/screens/parent/parent_home_tab.dart';
import 'package:edu_smart_assistant/screens/parent/parent_reports_tab.dart';
import 'package:edu_smart_assistant/screens/parent/parent_account_tab.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  int _currentIndex = 0;

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
          if (parentProvider.isLoading && parentProvider.children.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primary200,
              ),
            );
          }

          if (!parentProvider.hasChildren) {
            return _buildEmptyState();
          }

          return IndexedStack(
            index: _currentIndex,
            children: const [
              ParentHomeTab(),
              ParentReportsTab(),
              ParentAccountTab(),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<ParentProvider>(
        builder: (_, parentProvider, __) {
          if (!parentProvider.hasChildren) return const SizedBox.shrink();
          return DiyaaBottomNav(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            items: const [
              DiyaaNavItem(icon: '🏠', label: 'الرئيسية'),
              DiyaaNavItem(icon: '📊', label: 'التقارير'),
              DiyaaNavItem(icon: '👤', label: 'حسابي'),
            ],
          );
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
              'لم تقم بإضافة أطفال بعد',
              style: GoogleFonts.tajawal(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.text100,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            Text(
              'أضف طفلك لمتابعة تقدمه الدراسي',
              style: GoogleFonts.tajawal(
                fontSize: 16,
                color: AppTheme.text200,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'أضف طفلك الأول',
              icon: Icons.add,
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.addChild),
            ),
          ],
        ),
      ),
    );
  }
}
