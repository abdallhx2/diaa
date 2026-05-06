import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:edu_smart_assistant/config/theme.dart';

class ChatBubbleWidget extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  const ChatBubbleWidget({
    super.key,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser
              ? AppTheme.primary200.withValues(alpha: 0.12)
              : AppTheme.accent100.withValues(alpha: 0.5),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
                isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight:
                isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isUser ? 'أنت' : 'المساعد الذكي',
              style: GoogleFonts.tajawal(
                fontSize: 12,
                color: AppTheme.text200,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: GoogleFonts.tajawal(
                fontSize: 16,
                height: 1.4,
                color: AppTheme.text100,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(timestamp),
              style: GoogleFonts.tajawal(
                fontSize: 10,
                color: AppTheme.text200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
