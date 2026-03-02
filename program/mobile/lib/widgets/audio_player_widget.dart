// ============================================================
// File: audio_player_widget.dart
// Purpose: مشغل صوت — تشغيل/إيقاف/إعادة مع شريط تقدم
// Owner: رهف — UI Developer
// Branch: feature/flutter-parent
// Week: 2 — ويدجت مشغل الصوت
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

// --- Implementation Steps ---
// Step 1: إنشاء StatefulWidget باسم AudioPlayerWidget
//         - class AudioPlayerWidget extends StatefulWidget {
//             final String audioUrl;
//             const AudioPlayerWidget({required this.audioUrl});
//           }

// Step 2: تهيئة AudioPlayer في initState
//         - final AudioPlayer _audioPlayer = AudioPlayer();
//         - في initState:
//           * await _audioPlayer.setUrl(widget.audioUrl);

// Step 3: في dispose
//         - _audioPlayer.dispose();

// Step 4: بناء واجهة المشغل
//         - Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [...],
//             ),
//             child: Column(children: [
//               // شريط التقدم (audio_video_progress_bar)
//               StreamBuilder<Duration>(
//                 stream: _audioPlayer.positionStream,
//                 builder: (_, snapshot) {
//                   return ProgressBar(
//                     progress: snapshot.data ?? Duration.zero,
//                     total: _audioPlayer.duration ?? Duration.zero,
//                     buffered: _audioPlayer.bufferedPosition,
//                     onSeek: (duration) => _audioPlayer.seek(duration),
//                   );
//                 },
//               ),
//               SizedBox(height: 8),

//               // أزرار التحكم
//               Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                 // زر الإعادة
//                 IconButton(
//                   icon: Icon(Icons.replay, size: 32),
//                   onPressed: () => _audioPlayer.seek(Duration.zero),
//                 ),
//                 SizedBox(width: 16),

//                 // زر التشغيل/الإيقاف (كبير 56dp)
//                 StreamBuilder<PlayerState>(
//                   stream: _audioPlayer.playerStateStream,
//                   builder: (_, snapshot) {
//                     final isPlaying = snapshot.data?.playing ?? false;
//                     return FloatingActionButton(
//                       heroTag: 'audio_play',
//                       mini: false,  // حجم عادي 56dp
//                       onPressed: () {
//                         if (isPlaying) _audioPlayer.pause();
//                         else _audioPlayer.play();
//                       },
//                       child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 32),
//                     );
//                   },
//                 ),
//                 SizedBox(width: 16),

//                 // عرض الوقت: الحالي / الإجمالي
//                 StreamBuilder<Duration>(
//                   stream: _audioPlayer.positionStream,
//                   builder: (_, snapshot) {
//                     return Text(
//                       '${_formatDuration(snapshot.data)} / ${_formatDuration(_audioPlayer.duration)}',
//                       style: TextStyle(fontSize: 14),
//                     );
//                   },
//                 ),
//               ]),
//             ]),
//           )

// Step 5: إنشاء method _formatDuration(Duration? duration)
//         - تحويل Duration لنص mm:ss
//         - مثال: Duration(minutes: 2, seconds: 35) → "2:35"

// Step 6: التعامل مع حالات الخطأ والتحميل
//         - إذا جاري التحميل: عرض CircularProgressIndicator
//         - إذا فشل التحميل: عرض "تعذر تحميل الصوت"
//         - إذا انتهى الصوت: إعادة الموضع للبداية

// --- Notes ---
// - just_audio: حزمة تشغيل الصوت من URL
// - audio_video_progress_bar: شريط تقدم جاهز وجميل
// - زر التشغيل كبير (56dp) لسهولة اللمس للأطفال
// - StreamBuilder لتحديث الواجهة تلقائياً مع تغير حالة المشغل
// - _audioPlayer.dispose() مهم جداً لمنع تسرب الذاكرة
// - يمكن إضافة التشغيل التلقائي بـ _audioPlayer.play() في initState
