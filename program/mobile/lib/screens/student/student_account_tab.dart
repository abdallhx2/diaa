import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/providers/student_provider.dart';
import 'package:edu_smart_assistant/widgets/diyaa_top_bar.dart';

class StudentAccountTab extends StatelessWidget {
  const StudentAccountTab({super.key});

  Future<void> _logout(BuildContext context) async {
    await context.read<AuthProvider>().logout();
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
  }

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
        const DiyaaTopBar(
          greeting: '\u{1F464} \u062D\u0633\u0627\u0628\u064A',
          name: '',
          subtitle: '\u0628\u064A\u0627\u0646\u0627\u062A \u062D\u0633\u0627\u0628\u0643 \u0627\u0644\u0634\u062E\u0635\u064A',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              children: [
                // Profile avatar
                Center(
                  child: Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary100, AppTheme.primary200],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary200.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '\u{1F467}',
                      style: TextStyle(fontSize: 36),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Name
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text100,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                // Grade
                Text(
                  grade.isNotEmpty
                      ? '\u0627\u0644\u0635\u0641 $grade \u0627\u0644\u0627\u0628\u062A\u062F\u0627\u0626\u064A'
                      : '',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text200,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                // Info card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x148B5FBF),
                        blurRadius: 12,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      // Row 1: Name
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppTheme.bg200, width: 1),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              '\u{1F467}',
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '\u0627\u0644\u0627\u0633\u0645',
                                    style: GoogleFonts.tajawal(
                                      color: AppTheme.text200,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    name,
                                    style: GoogleFonts.tajawal(
                                      color: AppTheme.text100,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Row 2: Grade
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 16),
                        child: Row(
                          children: [
                            const Text(
                              '\u{1F3EB}',
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '\u0627\u0644\u0635\u0641 \u0627\u0644\u062F\u0631\u0627\u0633\u064A',
                                    style: GoogleFonts.tajawal(
                                      color: AppTheme.text200,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    grade.isNotEmpty
                                        ? '\u0627\u0644\u0635\u0641 $grade \u0627\u0644\u0627\u0628\u062A\u062F\u0627\u0626\u064A'
                                        : '-',
                                    style: GoogleFonts.tajawal(
                                      color: AppTheme.text100,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Logout button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _logout(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(
                          color: Color(0xFFE53935), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      '\u{1F6AA} \u062A\u0633\u062C\u064A\u0644 \u0627\u0644\u062E\u0631\u0648\u062C',
                      style: GoogleFonts.tajawal(
                        color: const Color(0xFFE53935),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
