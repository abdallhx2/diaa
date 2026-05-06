import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';

enum ButtonVariant { primary, outline, white, ghost }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final ButtonVariant variant;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.isLoading = false,
    this.icon,
    this.width,
    this.variant = ButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    final bgColor = _backgroundColor;
    final fgColor = _foregroundColor;
    final border = _border;
    final shadow = _shadow;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: shadow != null ? [shadow] : [],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: border ?? BorderSide.none,
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: fgColor,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Color get _backgroundColor {
    if (color != null && variant == ButtonVariant.primary) return color!;
    switch (variant) {
      case ButtonVariant.primary:
        return AppTheme.primary200;
      case ButtonVariant.outline:
        return Colors.transparent;
      case ButtonVariant.white:
        return Colors.white;
      case ButtonVariant.ghost:
        return Colors.white.withValues(alpha: 0.15);
    }
  }

  Color get _foregroundColor {
    switch (variant) {
      case ButtonVariant.primary:
        return Colors.white;
      case ButtonVariant.outline:
        return AppTheme.primary200;
      case ButtonVariant.white:
        return AppTheme.primary200;
      case ButtonVariant.ghost:
        return Colors.white;
    }
  }

  BorderSide? get _border {
    switch (variant) {
      case ButtonVariant.outline:
        return const BorderSide(color: AppTheme.primary100, width: 2);
      default:
        return null;
    }
  }

  BoxShadow? get _shadow {
    switch (variant) {
      case ButtonVariant.primary:
        return const BoxShadow(
          color: Color(0x668B5FBF),
          blurRadius: 16,
          offset: Offset(0, 4),
        );
      default:
        return null;
    }
  }
}
