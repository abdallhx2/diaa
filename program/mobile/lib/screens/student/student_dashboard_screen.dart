import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/student_provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/diyaa_bottom_nav.dart';
import 'package:edu_smart_assistant/screens/student/student_home_tab.dart';
import 'package:edu_smart_assistant/screens/student/student_results_tab.dart';
import 'package:edu_smart_assistant/screens/student/student_account_tab.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StudentProvider>().fetchDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          StudentHomeTab(),
          StudentResultsTab(),
          StudentAccountTab(),
        ],
      ),
      bottomNavigationBar: DiyaaBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          DiyaaNavItem(icon: '\u{1F3E0}', label: '\u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629'),
          DiyaaNavItem(icon: '\u{1F3C6}', label: '\u0646\u062A\u0627\u0626\u062C\u064A'),
          DiyaaNavItem(icon: '\u{1F464}', label: '\u062D\u0633\u0627\u0628\u064A'),
        ],
      ),
    );
  }
}
