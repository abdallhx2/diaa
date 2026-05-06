import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.tajawal(
            color: AppTheme.text100,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          textDirection: TextDirection.rtl,
          style: GoogleFonts.tajawal(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.tajawal(
              color: AppTheme.text200,
              fontSize: 14,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppTheme.text200, size: 20)
                : null,
            filled: true,
            fillColor: AppTheme.bg100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              borderSide: const BorderSide(color: AppTheme.bg200, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              borderSide: const BorderSide(color: AppTheme.bg200, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              borderSide:
                  const BorderSide(color: AppTheme.primary100, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              borderSide:
                  const BorderSide(color: AppTheme.errorColor, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              borderSide:
                  const BorderSide(color: AppTheme.errorColor, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
            errorStyle: GoogleFonts.tajawal(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
