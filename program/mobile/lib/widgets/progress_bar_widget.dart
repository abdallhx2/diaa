import 'package:flutter/material.dart';
import '../config/theme.dart';

class ProgressBarWidget extends StatelessWidget {
  final double progress;
  final String label;
  final Color? color;

  const ProgressBarWidget({
    required this.progress,
    required this.label,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 12,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(color ?? AppTheme.primaryBlue),
          ),
        ),
      ],
    );
  }
}
