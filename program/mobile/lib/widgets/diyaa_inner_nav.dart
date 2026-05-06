import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';

class DiyaaInnerNav extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  const DiyaaInnerNav({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppTheme.bg200, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: onBack ?? () => Navigator.of(context).pop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.bg100,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppTheme.text100,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title
            Text(
              title,
              style: GoogleFonts.tajawal(
                color: AppTheme.text100,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (trailing != null) ...[
              const Spacer(),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
