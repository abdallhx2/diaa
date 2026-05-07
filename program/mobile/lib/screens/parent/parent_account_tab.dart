import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/providers/auth_provider.dart';
import 'package:edu_smart_assistant/providers/parent_provider.dart';
import 'package:edu_smart_assistant/widgets/diyaa_top_bar.dart';

class ParentAccountTab extends StatelessWidget {
  const ParentAccountTab({super.key});

  Future<void> _logout(BuildContext context) async {
    await context.read<AuthProvider>().logout();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.roleSelection,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final parentProvider = context.watch<ParentProvider>();
    final user = authProvider.currentUser;
    final name = user?.name ?? 'ولي الأمر';
    final email = user?.email ?? '';
    final phone = user?.phone ?? '';
    final childrenCount = parentProvider.children.length;

    return Column(
      children: [
        const DiyaaTopBar(
          greeting: '👤 حسابي',
          name: '',
          subtitle: 'بيانات حسابك الشخصي',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              children: [
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
                      '👨‍👧',
                      style: TextStyle(fontSize: 36),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
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
                Text(
                  'ولي أمر · $childrenCount ${childrenCount == 1 ? "طفل" : "أطفال"}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text200,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                _buildInfoCard([
                  _InfoRow(
                    emoji: '👤',
                    label: 'الاسم',
                    value: name,
                  ),
                  if (email.isNotEmpty)
                    _InfoRow(
                      emoji: '📧',
                      label: 'البريد الإلكتروني',
                      value: email,
                    ),
                  if (phone.isNotEmpty)
                    _InfoRow(
                      emoji: '📱',
                      label: 'الهاتف',
                      value: phone,
                    ),
                ]),
                const SizedBox(height: 18),
                _buildActionTile(
                  emoji: '👧',
                  title: 'أبنائي',
                  subtitle: 'إدارة قائمة الأطفال',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.myChildren),
                ),
                const SizedBox(height: 10),
                _buildActionTile(
                  emoji: '➕',
                  title: 'إضافة طفل',
                  subtitle: 'سجّل طفلاً جديداً',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.addChild),
                ),
                const SizedBox(height: 18),
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
                      '🚪 تسجيل الخروج',
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

  Widget _buildInfoCard(List<_InfoRow> rows) {
    final visibleRows = rows.where((r) => r.value.isNotEmpty).toList();
    if (visibleRows.isEmpty) return const SizedBox.shrink();
    return Container(
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
          for (var i = 0; i < visibleRows.length; i++) ...[
            _buildInfoRow(visibleRows[i]),
            if (i < visibleRows.length - 1)
              const Divider(height: 1, color: AppTheme.bg200, indent: 18, endIndent: 18),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(_InfoRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Text(row.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.label,
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text200,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  row.value,
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
    );
  }

  Widget _buildActionTile({
    required String emoji,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x148B5FBF),
                blurRadius: 12,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.primary100.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.tajawal(
                        color: AppTheme.text100,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
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

class _InfoRow {
  final String emoji;
  final String label;
  final String value;

  const _InfoRow({
    required this.emoji,
    required this.label,
    required this.value,
  });
}
