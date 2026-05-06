import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';

class DiyaaMenuCard extends StatelessWidget {
  final String icon;
  final List<Color> iconColors;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const DiyaaMenuCard({
    super.key,
    required this.icon,
    required this.iconColors,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radius),
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
              // Icon container with gradient
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: iconColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              // Text column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.tajawal(
                        color: AppTheme.text100,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: GoogleFonts.tajawal(
                        color: AppTheme.text200,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow
              const Text(
                '\u2039',
                style: TextStyle(
                  color: AppTheme.accent200,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
