import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/lesson_provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';
import 'package:edu_smart_assistant/widgets/loading_widget.dart';

class TextDisplayScreen extends StatefulWidget {
  const TextDisplayScreen({super.key});

  @override
  State<TextDisplayScreen> createState() => _TextDisplayScreenState();
}

class _TextDisplayScreenState extends State<TextDisplayScreen> {
  @override
  void initState() {
    super.initState();
    final lessonProvider = context.read<LessonProvider>();
    if (lessonProvider.audioUrl == null &&
        lessonProvider.extractedText != null) {
      Future.microtask(() => lessonProvider.generateAudio());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LessonProvider>(
      builder: (context, lessonProvider, _) {
        final text = lessonProvider.extractedText ?? '';

        return Scaffold(
          backgroundColor: AppTheme.bg100,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nav
                const DiyaaInnerNav(
                    title:
                        '\u0646\u062A\u064A\u062C\u0629 \u0627\u0642\u0631\u0623 \u0644\u064A'),

                // Success badge
                Container(
                  margin: const EdgeInsets.all(14),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\u2705',
                        style: GoogleFonts.tajawal(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '\u062A\u0645 \u0627\u0633\u062A\u062E\u0631\u0627\u062C \u0627\u0644\u0646\u0635 \u0628\u0646\u062C\u0627\u062D',
                        style: GoogleFonts.tajawal(
                          color: const Color(0xFF2E7D32),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Text box
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: GoogleFonts.tajawal(
                      color: AppTheme.text100,
                      fontSize: 14,
                      height: 1.8,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(height: 14),

                // Audio section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\uD83D\uDD0A \u062A\u0634\u063A\u064A\u0644 \u0627\u0644\u0635\u0648\u062A',
                        style: GoogleFonts.tajawal(
                          color: AppTheme.primary200,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      if (lessonProvider.isProcessing)
                        const Center(
                          child: LoadingWidget(
                              message:
                                  '\u062C\u0627\u0631\u064A \u062A\u0648\u0644\u064A\u062F \u0627\u0644\u0635\u0648\u062A...'),
                        )
                      else
                        // Audio bar
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Play button
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primary200,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '\u25B6',
                                  style: GoogleFonts.tajawal(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Wave bars
                              Row(
                                children: List.generate(6, (index) {
                                  final heights = [12.0, 18.0, 10.0, 22.0, 14.0, 8.0];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: Container(
                                      width: 3,
                                      height: heights[index],
                                      decoration: BoxDecoration(
                                        color: AppTheme.primary100
                                            .withValues(alpha: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(2),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const Spacer(),
                              // Time text
                              Text(
                                '0:00',
                                style: GoogleFonts.tajawal(
                                  color: AppTheme.text200,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Save button
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.all(13),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.bg200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\uD83D\uDCBE',
                        style: GoogleFonts.tajawal(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\u062D\u0641\u0638 \u0641\u064A \u0627\u0644\u0633\u062C\u0644',
                        style: GoogleFonts.tajawal(
                          color: AppTheme.primary200,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
