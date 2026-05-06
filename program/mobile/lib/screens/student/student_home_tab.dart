import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/providers/student_provider.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/widgets/diyaa_top_bar.dart';
import 'package:edu_smart_assistant/widgets/diyaa_menu_card.dart';

class StudentHomeTab extends StatelessWidget {
  const StudentHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.watch<StudentProvider>();
    final authProvider = context.watch<AuthProvider>();
    final name = studentProvider.studentData?.name
        ?? authProvider.currentUser?.name
        ?? '\u0637\u0627\u0644\u0628';
    final grade = studentProvider.studentData?.grade ?? '';

    return Column(
      children: [
        DiyaaTopBar(
          greeting: '\u0645\u0631\u062D\u0628\u0627\u064B \u{1F31F}',
          name: name,
          subtitle: grade.isNotEmpty
              ? '\u0627\u0644\u0635\u0641 $grade \u0627\u0644\u0627\u0628\u062A\u062F\u0627\u0626\u064A'
              : '\u0645\u0631\u062D\u0628\u0627\u064B \u0628\u0643',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u0645\u0627\u0630\u0627 \u062A\u0631\u064A\u062F \u0623\u0646 \u062A\u0641\u0639\u0644\u061F',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text100,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                DiyaaMenuCard(
                  icon: '\u{1F4DA}',
                  iconColors: const [AppTheme.primary200, AppTheme.primary200],
                  title: '\u0627\u0628\u062F\u0623 \u0627\u0644\u062A\u0639\u0644\u0645',
                  description: '\u062F\u0631\u0648\u0633 \u0627\u0644\u0641\u064A\u062F\u064A\u0648 \u0648\u0627\u0644\u0645\u0644\u062E\u0635\u0627\u062A',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.subjects),
                ),
                const SizedBox(height: 12),
                DiyaaMenuCard(
                  icon: '\u{1F50A}',
                  iconColors: const [Color(0xFF2193B0), Color(0xFF6DD5ED)],
                  title: '\u0627\u0642\u0631\u0623 \u0644\u064A',
                  description: '\u0635\u0648\u0651\u0631 \u0623\u064A \u0646\u0635 \u0648\u0623\u0633\u0645\u0639\u0647 \u0644\u0643',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.scanPage),
                ),
                const SizedBox(height: 12),
                DiyaaMenuCard(
                  icon: '\u270F\uFE0F',
                  iconColors: const [Color(0xFFEE0979), Color(0xFFFF6A00)],
                  title: '\u062A\u0645\u0631\u0651\u0646',
                  description: '\u0627\u062E\u062A\u0628\u0631 \u0646\u0641\u0633\u0643 \u0648\u062A\u062D\u0633\u0651\u0646',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.practiceSelect),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
