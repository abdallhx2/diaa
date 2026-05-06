import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';

class DiyaaTopBar extends StatelessWidget {
  final String greeting;
  final String name;
  final String subtitle;
  final String? badgeText;
  final Widget? trailing;

  const DiyaaTopBar({
    super.key,
    required this.greeting,
    required this.name,
    required this.subtitle,
    this.badgeText,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            left: 18,
            right: 18,
            top: 20,
            bottom: 30,
          ),
          decoration: const BoxDecoration(
            color: AppTheme.primary200,
          ),
          child: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                // Badge (top-left in RTL = top-right visually, but since RTL
                // we position at top-left which appears on the leading side)
                if (badgeText != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badgeText!,
                        style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Trailing widget
                if (trailing != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: trailing!,
                  ),
                // Main content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (badgeText != null) const SizedBox(height: 8),
                    Text(
                      greeting,
                      style: GoogleFonts.tajawal(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name,
                      style: GoogleFonts.tajawal(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.tajawal(
                        color: AppTheme.accent100,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
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
}
