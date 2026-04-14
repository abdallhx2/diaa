import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/lesson_provider.dart';
import 'package:edu_smart_assistant/services/tts_service.dart';
import 'package:edu_smart_assistant/config/theme.dart';

class TextDisplayScreen extends StatefulWidget {
  const TextDisplayScreen({super.key});

  @override
  State<TextDisplayScreen> createState() => _TextDisplayScreenState();
}

class _TextDisplayScreenState extends State<TextDisplayScreen> {
  bool    _isGeneratingAudio = false;
  bool    _isPlaying         = false;
  String? _audioError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateAudioIfNeeded();
    });
  }

  Future<void> _generateAudioIfNeeded() async {
    final lessonProvider = context.read<LessonProvider>();

    if (lessonProvider.hasAudio) { return; }
    if (lessonProvider.extractedText == null) { return; }

    setState(() {
      _isGeneratingAudio = true;
      _audioError        = null;
    });

    try {
      final url = await TtsService()
          .generateAudio(lessonProvider.extractedText!);

      if (!mounted) { return; }

      if (url != null) {
        lessonProvider.setAudioUrl(url);
      }
    } catch (_) {
      if (!mounted) { return; }
      setState(() {
        _audioError = 'تعذّر توليد الصوت. سيتم عرض النص فقط.';
      });
    } finally {
      if (mounted) {
        setState(() { _isGeneratingAudio = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessonProvider = context.watch<LessonProvider>();
    final extractedText  = lessonProvider.extractedText ?? '';
    final audioUrl       = lessonProvider.audioUrl;
    final lessonId       = lessonProvider.currentLesson?.id ?? '';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: Text(lessonProvider.currentLesson?.title ?? 'الدرس'),
          leading: IconButton(
            icon:      const Icon(Icons.arrow_forward_ios_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: extractedText.isEmpty
                    ? const Center(
                        child: Text(
                          'لا يوجد نص لعرضه.',
                          style: TextStyle(
                            fontSize: 18,
                            color:    AppTheme.textSecondary,
                          ),
                        ),
                      )
                    : Text(
                        extractedText,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 22,
                          height:   1.8,
                          color:    AppTheme.textPrimary,
                        ),
                      ),
              ),
            ),

            if (_isGeneratingAudio)
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 20),
                color: Colors.white,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.primaryBlue),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'جاري توليد الصوت...',
                      style: TextStyle(
                        fontSize: 16,
                        color:    AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

            if (_audioError != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                color: AppTheme.errorColor10,
                child: Text(
                  _audioError!,
                  style: const TextStyle(
                    color:    AppTheme.errorColor,
                    fontSize: 14,
                  ),
                ),
              ),

            if (audioUrl != null && !_isGeneratingAudio)
              _AudioPlayerWidget(
                audioUrl:  audioUrl,
                isPlaying: _isPlaying,
                onToggle:  () {
                  setState(() { _isPlaying = !_isPlaying; });
                },
              ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/ai-chat',
                  arguments: {
                    'lessonId': lessonId,
                    'text':     extractedText,
                  },
                ),
                icon:  const Icon(Icons.chat_rounded, size: 22),
                label: const Text('اسأل المساعد الذكي'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioPlayerWidget extends StatelessWidget {
  final String       audioUrl;
  final bool         isPlaying;
  final VoidCallback onToggle;

  const _AudioPlayerWidget({
    required this.audioUrl,
    required this.isPlaying,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color:      AppTheme.shadowColor,
            blurRadius: 8,
            offset:     Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width:  52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppTheme.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size:  30,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'استمع للدرس',
                  style: TextStyle(
                    fontSize:   16,
                    fontWeight: FontWeight.w600,
                    color:      AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value:           isPlaying ? null : 0.0,
                    backgroundColor: AppTheme.dividerColor,
                    color:           AppTheme.primaryBlue,
                    minHeight:       6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          IconButton(
            icon: const Icon(
              Icons.replay_rounded,
              color: AppTheme.textSecondary,
            ),
            onPressed: () {},
            tooltip: 'إعادة التشغيل',
          ),
        ],
      ),
    );
  }
}
