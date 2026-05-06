import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';

class QuizOptionWidget extends StatelessWidget {
  final String text;
  final String? letter;
  final bool isSelected;
  final bool? isCorrect;
  final VoidCallback onTap;

  const QuizOptionWidget({
    super.key,
    required this.text,
    this.letter,
    required this.isSelected,
    this.isCorrect,
    required this.onTap,
  });

  Color get _borderColor {
    if (!isSelected) return AppTheme.bg200;
    if (isCorrect == null) return AppTheme.primary200;
    if (isCorrect == true) return AppTheme.successColor;
    return AppTheme.errorColor;
  }

  Color get _backgroundColor {
    if (isCorrect == true && isSelected) {
      return AppTheme.successColor.withValues(alpha: 0.1);
    }
    if (isCorrect == false && isSelected) {
      return AppTheme.errorColor.withValues(alpha: 0.1);
    }
    if (isSelected) return AppTheme.primary200.withValues(alpha: 0.1);
    return Colors.white;
  }

  Widget get _icon {
    if (isCorrect == true) {
      return const Icon(Icons.check_circle, color: AppTheme.successColor, size: 24);
    }
    if (isCorrect == false && isSelected) {
      return const Icon(Icons.cancel, color: AppTheme.errorColor, size: 24);
    }
    if (isSelected) {
      return const Icon(Icons.radio_button_checked,
          color: AppTheme.primary200, size: 24);
    }
    return const Icon(Icons.radio_button_unchecked,
        color: AppTheme.bg200, size: 24);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isCorrect != null ? null : onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(color: _borderColor, width: 2),
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        child: Row(
          children: [
            _icon,
            if (letter != null) ...[
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? _borderColor.withValues(alpha: 0.15)
                      : AppTheme.bg100,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  letter!,
                  style: GoogleFonts.tajawal(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? _borderColor : AppTheme.text200,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.tajawal(
                  fontSize: 18,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  color: AppTheme.text100,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
