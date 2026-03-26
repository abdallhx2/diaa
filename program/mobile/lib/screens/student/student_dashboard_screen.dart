import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/providers/student_provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';

class AppRoutes {
  static const String roleSelection = '/role-selection';
  static const String scanPage      = '/scan-page';
  static const String scanQR        = '/scan-qr';
  static const String uploadFile    = '/upload-file';
  static const String quizSelection = '/quiz-selection';
}

class _CardColors {
  final Color base;
  final Color shadow;
  final Color splash;
  final Color highlight;
  final Color gradHigh;
  final Color gradLow;
  final Color iconBg;
  const _CardColors({
    required this.base,
    required this.shadow,
    required this.splash,
    required this.highlight,
    required this.gradHigh,
    required this.gradLow,
    required this.iconBg,
  });
}

const _CardColors _blueCard = _CardColors(
  base:      Color(0xFF4A90D9),
  shadow:    Color(0x404A90D9),
  splash:    Color(0x264A90D9),
  highlight: Color(0x144A90D9),
  gradHigh:  Color(0x144A90D9),
  gradLow:   Color(0x054A90D9),
  iconBg:    Color(0x1F4A90D9),
);

const _CardColors _greenCard = _CardColors(
  base:      Color(0xFF66BB6A),
  shadow:    Color(0x4066BB6A),
  splash:    Color(0x2666BB6A),
  highlight: Color(0x1466BB6A),
  gradHigh:  Color(0x1466BB6A),
  gradLow:   Color(0x0566BB6A),
  iconBg:    Color(0x1F66BB6A),
);

const _CardColors _orangeCard = _CardColors(
  base:      Color(0xFFFFA726),
  shadow:    Color(0x40FFA726),
  splash:    Color(0x26FFA726),
  highlight: Color(0x14FFA726),
  gradHigh:  Color(0x14FFA726),
  gradLow:   Color(0x05FFA726),
  iconBg:    Color(0x1FFFA726),
);

const _CardColors _purpleCard = _CardColors(
  base:      Color(0xFF9C27B0),
  shadow:    Color(0x409C27B0),
  splash:    Color(0x269C27B0),
  highlight: Color(0x149C27B0),
  gradHigh:  Color(0x149C27B0),
  gradLow:   Color(0x059C27B0),
  iconBg:    Color(0x1F9C27B0),
);

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentProvider>().fetchDashboard();
    });
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.watch<StudentProvider>();
    final studentName     = studentProvider.studentData?.name ?? 'الطالب';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: Text('مرحباً $studentName 👋'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon:     const Icon(Icons.logout_rounded),
              tooltip: 'تسجيل الخروج',
              onPressed: _logout,
            ),
          ],
        ),
        body: studentProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                      child: Text(
                        'ماذا تريد أن تتعلم اليوم؟',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: Text(
                        'اختر نشاطاً للبدء',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppTheme.textSecondary),
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount:  2,
                        padding:          const EdgeInsets.all(16),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _buildDashboardCard(
                            title:  'مسح صفحة',
                            icon:   Icons.camera_alt_rounded,
                            colors: _blueCard,
                            onTap:  () => Navigator.pushNamed(
                                context, AppRoutes.scanPage),
                          ),
                          _buildDashboardCard(
                            title:  'مسح QR',
                            icon:   Icons.qr_code_scanner_rounded,
                            colors: _greenCard,
                            onTap:  () => Navigator.pushNamed(
                                context, AppRoutes.scanQR),
                          ),
                          _buildDashboardCard(
                            title:  'رفع ملف',
                            icon:   Icons.upload_file_rounded,
                            colors: _orangeCard,
                            onTap:  () => Navigator.pushNamed(
                                context, AppRoutes.uploadFile),
                          ),
                          _buildDashboardCard(
                            title:  'حل اختبار',
                            icon:   Icons.quiz_rounded,
                            colors: _purpleCard,
                            onTap:  () => Navigator.pushNamed(
                                context, AppRoutes.quizSelection),
                          ),
                        ],
                      ),
                    ),
                    if (studentProvider.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor10,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.errorColor40),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  color: AppTheme.errorColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  studentProvider.errorMessage!,
                                  style: const TextStyle(
                                    color:     AppTheme.errorColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String     title,
    required IconData   icon,
    required _CardColors  colors,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation:   4,
      shadowColor: colors.shadow,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap:           onTap,
        borderRadius:    BorderRadius.circular(16),
        splashColor:     colors.splash,
        highlightColor: colors.highlight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin:  Alignment.topRight,
              end:    Alignment.bottomLeft,
              colors: [colors.gradHigh, colors.gradLow],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width:  80,
                height: 80,
                decoration: BoxDecoration(
                  color: colors.iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 44, color: colors.base),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize:   20,
                  fontWeight: FontWeight.bold,
                  color:       AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}