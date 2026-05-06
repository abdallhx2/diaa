import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:edu_smart_assistant/config/theme.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({super.key, required this.audioUrl});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _audioPlayer.setUrl(widget.audioUrl);
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _hasError = true);
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '0:00';
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          boxShadow: const [AppTheme.shadow],
        ),
        child: Center(
          child: Text(
            'تعذر تحميل الصوت',
            style: GoogleFonts.tajawal(
              color: AppTheme.text200,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(AppTheme.primary100),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        boxShadow: const [AppTheme.shadow],
      ),
      child: Column(
        children: [
          StreamBuilder<Duration>(
            stream: _audioPlayer.positionStream,
            builder: (context, snapshot) {
              return ProgressBar(
                progress: snapshot.data ?? Duration.zero,
                total: _audioPlayer.duration ?? Duration.zero,
                buffered: _audioPlayer.bufferedPosition,
                onSeek: (duration) => _audioPlayer.seek(duration),
                baseBarColor: AppTheme.bg200,
                progressBarColor: AppTheme.primary200,
                bufferedBarColor: AppTheme.primary200.withValues(alpha: 0.3),
                thumbColor: AppTheme.primary200,
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay, size: 32),
                onPressed: () => _audioPlayer.seek(Duration.zero),
                color: AppTheme.text200,
              ),
              const SizedBox(width: 16),
              StreamBuilder<PlayerState>(
                stream: _audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  final isPlaying = snapshot.data?.playing ?? false;
                  return FloatingActionButton(
                    heroTag: 'audio_play_${widget.audioUrl.hashCode}',
                    mini: false,
                    backgroundColor: AppTheme.primary200,
                    onPressed: () {
                      if (isPlaying) {
                        _audioPlayer.pause();
                      } else {
                        _audioPlayer.play();
                      }
                    },
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 32,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              StreamBuilder<Duration>(
                stream: _audioPlayer.positionStream,
                builder: (context, snapshot) {
                  return Text(
                    '${_formatDuration(snapshot.data)} / ${_formatDuration(_audioPlayer.duration)}',
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      color: AppTheme.text200,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
