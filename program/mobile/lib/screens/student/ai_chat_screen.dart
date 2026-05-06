import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/chat_provider.dart';
import 'package:edu_smart_assistant/providers/lesson_provider.dart';
import 'package:edu_smart_assistant/widgets/chat_bubble_widget.dart';
import 'package:edu_smart_assistant/widgets/loading_widget.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';
import 'package:edu_smart_assistant/config/constants.dart';
import 'package:edu_smart_assistant/config/theme.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String _lessonId;
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _lessonId = args?['lessonId'] ??
          context.read<LessonProvider>().currentLesson?.id ??
          '';
      Future.microtask(
          () => context.read<ChatProvider>().loadHistory(_lessonId));
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage() async {
    final question = _messageController.text.trim();
    if (question.isEmpty) return;

    final chatProvider = context.read<ChatProvider>();
    if (!chatProvider.canSendMore) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'وصلت الحد الأقصى للرسائل (${AppConstants.maxChatMessages})',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: AppTheme.accent200,
        ),
      );
      return;
    }

    _messageController.clear();
    await chatProvider.sendMessage(question, _lessonId);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: Column(
        children: [
          DiyaaInnerNav(
            title: 'المساعد الذكي',
            onBack: () => Navigator.pop(context),
            trailing: Consumer<ChatProvider>(
              builder: (_, chatProvider, __) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary200.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${chatProvider.messageCount}/${AppConstants.maxChatMessages}',
                  style: GoogleFonts.tajawal(
                    fontSize: 13,
                    color: AppTheme.primary200,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (_, chatProvider, __) {
                if (chatProvider.isLoading && chatProvider.messages.isEmpty) {
                  return const Center(
                    child: LoadingWidget(message: 'جاري تحميل المحادثة...'),
                  );
                }

                if (chatProvider.messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.primary100.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.smart_toy,
                            size: 64,
                            color: AppTheme.primary100,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'اسأل المساعد الذكي عن الدرس!',
                          style: GoogleFonts.tajawal(
                            fontSize: 20,
                            color: AppTheme.text200,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  );
                }

                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (_, index) {
                    final msg = chatProvider.messages[index];
                    return ChatBubbleWidget(
                      message: msg.content,
                      isUser: msg.isUser,
                      timestamp: msg.createdAt,
                    );
                  },
                );
              },
            ),
          ),
          Consumer<ChatProvider>(
            builder: (_, chatProvider, __) {
              if (chatProvider.isLoading && chatProvider.messages.isNotEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(8),
                  child: LoadingWidget(message: 'جاري التفكير...'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppTheme.bg200, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Material(
              color: AppTheme.primary200,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: _sendMessage,
                borderRadius: BorderRadius.circular(24),
                child: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(Icons.send, color: Colors.white, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _messageController,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.tajawal(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'اكتب سؤالك هنا...',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: GoogleFonts.tajawal(color: AppTheme.text200),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppTheme.bg100,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
