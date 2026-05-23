import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/providers/lessons_provider.dart';
import 'package:edu_smart_assistant/providers/chat_provider.dart';
import 'package:edu_smart_assistant/providers/achievement_provider.dart';
import 'package:edu_smart_assistant/services/student_service.dart';
import 'package:edu_smart_assistant/services/tts_service.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';

class LessonDetailScreen extends StatefulWidget {
  final String lessonId;
  final String lessonName;

  const LessonDetailScreen({
    super.key,
    required this.lessonId,
    required this.lessonName,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _sessionId;
  bool _ttsLoading = false;
  bool _ttsUnavailable = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  final TextEditingController _chatController = TextEditingController();
  final StudentService _studentService = StudentService();
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChange);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final lessonsProvider = context.read<LessonsProvider>();
      await lessonsProvider.loadDetail(widget.lessonId);
      final id = await _studentService.startSession(widget.lessonId);
      if (mounted) setState(() => _sessionId = id);
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state.playing);
      }
    });
  }

  void _onTabChange() {
    if (!_tabController.indexIsChanging) return;
    if (_tabController.index == 1) {
      context.read<ChatProvider>().loadHistory(widget.lessonId);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChange);
    _tabController.dispose();
    _audioPlayer.dispose();
    _chatController.dispose();
    if (_sessionId != null) {
      _studentService.endSession(_sessionId!);
    }
    context.read<LessonsProvider>().cleanup();
    context.read<ChatProvider>().cleanup();
    super.dispose();
  }

  Future<void> _playTts(String text) async {
    if (_ttsLoading || _ttsUnavailable) return;
    setState(() => _ttsLoading = true);
    try {
      final url = await _ttsService.generateSpeech(text);
      if (url.isNotEmpty) {
        await _audioPlayer.setUrl(url);
        await _audioPlayer.play();
      } else {
        setState(() => _ttsUnavailable = true);
      }
    } catch (_) {
      setState(() => _ttsUnavailable = true);
    } finally {
      if (mounted) setState(() => _ttsLoading = false);
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) context.read<AchievementProvider>().loadProgress();
      },
      child: Scaffold(
      backgroundColor: AppTheme.bg100,
      body: Column(
        children: [
          DiyaaInnerNav(title: widget.lessonName),
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.primary100,
              indicatorWeight: 3,
              labelColor: AppTheme.primary200,
              unselectedLabelColor: AppTheme.text200,
              labelStyle: GoogleFonts.tajawal(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.tajawal(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'الملخص'),
                Tab(text: 'اسأل'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSummaryTab(),
                _buildChatTab(),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  // ─── Tab 1: Summary + TTS ────────────────────────────────────────

  Widget _buildSummaryTab() {
    return Consumer<LessonsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingDetail) {
          return const Center(child: CircularProgressIndicator());
        }
        final detail = provider.detail;
        if (detail == null) {
          return Center(
            child: Text(
              'لم يتم تحميل الدرس',
              style: GoogleFonts.tajawal(color: AppTheme.text200, fontSize: 14),
            ),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🔊', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    'استمع للملخص',
                    style: GoogleFonts.tajawal(
                      color: AppTheme.primary200,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Audio bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x108B5FBF),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (_ttsLoading)
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      GestureDetector(
                        onTap: _ttsUnavailable
                            ? null
                            : () async {
                                if (_audioPlayer.duration == null) {
                                  final text = detail.summary.isNotEmpty
                                      ? detail.summary
                                      : detail.originalText;
                                  await _playTts(text);
                                } else {
                                  await _togglePlayPause();
                                }
                              },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _ttsUnavailable
                                ? AppTheme.text200
                                : AppTheme.primary200,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _ttsUnavailable
                                ? '🔇'
                                : _isPlaying
                                    ? '⏸'
                                    : '▶',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ttsUnavailable
                          ? Text(
                              'الصوت غير متاح حالياً',
                              style: GoogleFonts.tajawal(
                                color: AppTheme.text200,
                                fontSize: 12,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(8, (i) {
                                final heights = [
                                  14.0, 22.0, 10.0, 28.0, 16.0, 24.0, 12.0, 20.0
                                ];
                                return Container(
                                  width: 3,
                                  height: heights[i],
                                  decoration: BoxDecoration(
                                    color: AppTheme.accent200,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              if (detail.summary.isNotEmpty) ...[
                Row(
                  children: [
                    const Text('📝', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      'الملخص',
                      style: GoogleFonts.tajawal(
                        color: AppTheme.primary200,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _textCard(detail.summary),
                const SizedBox(height: 14),
              ],
              Row(
                children: [
                  const Text('📄', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    'النص الكامل',
                    style: GoogleFonts.tajawal(
                      color: AppTheme.primary200,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _textCard(detail.originalText),
            ],
          ),
        );
      },
    );
  }

  Widget _textCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        boxShadow: const [
          BoxShadow(
            color: Color(0x108B5FBF),
            blurRadius: 8,
            offset: Offset(0, 2),
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
    );
  }

  // ─── Tab 3: AI Chat ──────────────────────────────────────────────

  Widget _buildChatTab() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(14),
                itemCount: chatProvider.messages.length +
                    (chatProvider.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (chatProvider.isLoading &&
                      index == chatProvider.messages.length) {
                    return _buildTypingIndicator();
                  }
                  final msg = chatProvider.messages[index];
                  return _buildBubble(
                    msg.content,
                    isUser: msg.role == 'user',
                  );
                },
              ),
            ),
            if (chatProvider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    chatProvider.errorMessage!,
                    style: GoogleFonts.tajawal(
                      color: AppTheme.errorColor,
                      fontSize: 12,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _chatController,
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.tajawal(
                        fontSize: 13.5,
                        color: AppTheme.text100,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.bg100,
                        hintText: 'اكتب سؤالك هنا...',
                        hintStyle: GoogleFonts.tajawal(
                          color: AppTheme.text200,
                          fontSize: 13,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppTheme.bg200,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppTheme.bg200,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppTheme.primary100,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: chatProvider.isLoading
                        ? null
                        : () {
                            final text = _chatController.text.trim();
                            if (text.isEmpty) return;
                            _chatController.clear();
                            chatProvider.sendMessage(text, widget.lessonId);
                          },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: chatProvider.isLoading
                            ? AppTheme.text200
                            : AppTheme.primary100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '➤',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBubble(String text, {required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primary200 : AppTheme.bg100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isUser ? 12 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 12),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.tajawal(
            color: isUser ? Colors.white : AppTheme.text100,
            fontSize: 13.5,
            height: 1.5,
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.bg100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 8),
            Text(
              'جاري التفكير...',
              style: GoogleFonts.tajawal(
                color: AppTheme.text200,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
