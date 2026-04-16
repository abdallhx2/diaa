import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/chat_provider.dart';
import 'package:edu_smart_assistant/providers/lesson_provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';

const int _maxMessages = 20;

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController      _scrollController  = ScrollController();

  late String _lessonId;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) { return; }
    _initialized = true;

    final args           = ModalRoute.of(context)?.settings.arguments;
    final lessonProvider = context.read<LessonProvider>();

    if (args is Map<String, dynamic>) {
      _lessonId = args['lessonId'] as String? ?? lessonProvider.currentLesson?.id ?? '';
    } else {
      _lessonId = lessonProvider.currentLesson?.id ?? '';
    }

    context.read<ChatProvider>().loadHistory(_lessonId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve:    Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final question = _messageController.text.trim();
    if (question.isEmpty) { return; }

    final chatProvider = context.read<ChatProvider>();

    if (chatProvider.messageCount >= _maxMessages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'وصلت الحد الأقصى للرسائل ($_maxMessages رسالة).',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: AppTheme.errorColor,
          behavior:        SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    _messageController.clear();
    _scrollToBottom();

    await chatProvider.sendMessage(question, _lessonId);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('المساعد الذكي'),
          leading: IconButton(
            icon:      const Icon(Icons.arrow_forward_ios_rounded),
            onPressed: () {
              context.read<ChatProvider>().clearChat();
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            _buildMessageCounter(),
            Expanded(child: _buildMessageList()),
            _buildLoadingIndicator(),
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCounter() {
    return Consumer<ChatProvider>(
      builder: (_, chatProvider, __) {
        final count     = chatProvider.messageCount;
        final remaining = _maxMessages - count;
        final isLow     = remaining <= 5;

        return Container(
          width:   double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          color:   isLow ? AppTheme.errorColor10 : AppTheme.primaryBlue08,
          child: Text(
            'الرسائل المتبقية: $remaining / $_maxMessages',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize:   13,
              color:      isLow ? AppTheme.errorColor : AppTheme.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageList() {
    return Consumer<ChatProvider>(
      builder: (_, chatProvider, __) {
        if (chatProvider.messages.isEmpty && !chatProvider.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size:  72,
                  color: AppTheme.primaryBlue15,
                ),
                const SizedBox(height: 16),
                Text(
                  'اسأل أي سؤال عن الدرس!',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppTheme.textSecondary),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller:  _scrollController,
          padding:     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount:   chatProvider.messages.length,
          itemBuilder: (_, index) {
            final msg = chatProvider.messages[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (msg.isFromUser)
                  _ChatBubble(
                    message:   msg.question,
                    isUser:    true,
                    timestamp: msg.timestamp,
                  ),
                if (!msg.isFromUser && msg.answer.isNotEmpty)
                  _ChatBubble(
                    message:   msg.answer,
                    isUser:    false,
                    timestamp: msg.timestamp,
                    audioUrl:  msg.audioUrl,
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Consumer<ChatProvider>(
      builder: (_, chatProvider, __) {
        if (!chatProvider.isLoading) { return const SizedBox.shrink(); }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: Colors.white,
          child: const Row(
            children: [
              SizedBox(
                width: 18, height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppTheme.primaryBlue),
              ),
              SizedBox(width: 12),
              Text(
                'جاري التفكير...',
                style: TextStyle(
                  color:    AppTheme.textSecondary,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField() {
    return Consumer<ChatProvider>(
      builder: (_, chatProvider, __) {
        final canSend = chatProvider.canSendMore && !chatProvider.isLoading;

        return Container(
          padding: EdgeInsets.only(
            right:  16,
            left:   8,
            top:    10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color:      AppTheme.shadowColor,
                blurRadius: 8,
                offset:     Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller:      _messageController,
                  textDirection:   TextDirection.rtl,
                  enabled:         canSend,
                  maxLines:        3,
                  minLines:        1,
                  textInputAction: TextInputAction.send,
                  onSubmitted:     (_) => canSend ? _sendMessage() : null,
                  decoration: InputDecoration(
                    hintText:          'اكتب سؤالك هنا...',
                    hintTextDirection: TextDirection.rtl,
                    filled:            true,
                    fillColor:         AppTheme.backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:   BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: canSend ? _sendMessage : null,
                child: Container(
                  width:  48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: canSend
                        ? AppTheme.primaryBlue
                        : AppTheme.dividerColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size:  22,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String    message;
  final bool      isUser;
  final DateTime  timestamp;
  final String?   audioUrl;

  const _ChatBubble({
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.audioUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin:  const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.only(
            topRight:    const Radius.circular(16),
            topLeft:     const Radius.circular(16),
            bottomRight: Radius.circular(isUser ? 16 : 4),
            bottomLeft:  Radius.circular(isUser ? 4  : 16),
          ),
          boxShadow: const [
            BoxShadow(
              color:      AppTheme.shadowColor,
              blurRadius: 4,
              offset:     Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 17,
                height:   1.5,
                color:    isUser ? Colors.white : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${timestamp.hour.toString().padLeft(2, '0')}:'
              '${timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 11,
                color:    isUser ? Colors.white70 : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
