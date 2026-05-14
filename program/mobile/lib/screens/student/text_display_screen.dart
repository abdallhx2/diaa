import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _audioReady = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) setState(() => _isPlaying = state.playing);
    });

    final lessonProvider = context.read<LessonProvider>();
    if (lessonProvider.audioUrl != null) {
      _loadAudio(lessonProvider.audioUrl!);
    } else if (lessonProvider.extractedText != null) {
      Future.microtask(() async {
        await lessonProvider.generateAudio();
        if (mounted && lessonProvider.audioUrl != null) {
          await _loadAudio(lessonProvider.audioUrl!);
        }
      });
    }
  }

  Future<void> _loadAudio(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      if (mounted) setState(() => _audioReady = true);
    } catch (_) {}
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
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
                const DiyaaInnerNav(title: 'نتيجة اقرأ لي'),

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
                      const Text('✅', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(
                        'تم استخراج النص بنجاح',
                        style: GoogleFonts.tajawal(
                          color: const Color(0xFF2E7D32),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تشغيل الصوت',
                        style: GoogleFonts.tajawal(
                          color: AppTheme.primary200,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      if (lessonProvider.isProcessing)
                        const Center(
                          child: LoadingWidget(message: 'جاري توليد الصوت...'),
                        )
                      else
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
                              GestureDetector(
                                onTap: _audioReady ? _togglePlay : null,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _audioReady
                                        ? AppTheme.primary200
                                        : AppTheme.text200,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _audioReady
                                        ? (_isPlaying ? '⏸' : '▶')
                                        : '🔇',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (!_audioReady && lessonProvider.audioUrl == null)
                                Text(
                                  'الصوت غير متاح حالياً',
                                  style: GoogleFonts.tajawal(
                                    color: AppTheme.text200,
                                    fontSize: 12,
                                  ),
                                )
                              else
                                Row(
                                  children: List.generate(6, (i) {
                                    final heights = [
                                      12.0, 18.0, 10.0, 22.0, 14.0, 8.0
                                    ];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      child: Container(
                                        width: 3,
                                        height: heights[i],
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
                            ],
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
