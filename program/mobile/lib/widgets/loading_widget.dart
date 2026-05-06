import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppTheme.primary100),
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: GoogleFonts.tajawal(
                fontSize: 16,
                color: AppTheme.text200,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ],
      ),
    );
  }
}
