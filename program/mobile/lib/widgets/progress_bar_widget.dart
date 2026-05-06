import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';

class ProgressBarWidget extends StatelessWidget {
  final double value;
  final String? label;
  final Color? color;

  const ProgressBarWidget({
    super.key,
    required this.value,
    this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (label != null)
              Text(
                label!,
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.text100,
                ),
              ),
            Text(
              '${(value * 100).round()}%',
              style: GoogleFonts.tajawal(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.text100,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: 12,
            backgroundColor: AppTheme.bg200,
            valueColor: AlwaysStoppedAnimation(
              color ?? AppTheme.primary200,
            ),
          ),
        ),
      ],
    );
  }
}
