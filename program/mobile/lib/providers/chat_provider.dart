import 'package:flutter/material.dart';
import 'package:edu_smart_assistant/models/chat_message_model.dart';
import 'package:edu_smart_assistant/services/chat_service.dart';
import 'package:edu_smart_assistant/config/constants.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatMessageModel> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentLessonId;
  final ChatService _chatService = ChatService();

  List<ChatMessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get currentLessonId => _currentLessonId;
  int get messageCount => _messages.length;
  bool get canSendMore => _messages.where((m) => m.role == 'user').length < AppConstants.maxChatMessages;

  Future<void> sendMessage(String question, String lessonId) async {
    if (!canSendMore) {
      _errorMessage = 'وصلت الحد الأقصى للرسائل (${AppConstants.maxChatMessages})';
      notifyListeners();
      return;
    }

    _errorMessage = null;
    _currentLessonId = lessonId;

    // Add user message immediately
    final userMsg = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: question,
      lessonId: lessonId,
      createdAt: DateTime.now(),
    );
    _messages.add(userMsg);
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _chatService.askQuestion(question, lessonId);
      final botMsg = ChatMessageModel(
        id: '${DateTime.now().millisecondsSinceEpoch}_bot',
        role: 'assistant',
        content: response['answer'] ?? '',
        lessonId: lessonId,
        createdAt: DateTime.now(),
      );
      _messages.add(botMsg);
    } catch (e) {
      _errorMessage = 'فشل في إرسال السؤال، حاول مرة أخرى';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadHistory(String lessonId) async {
    _isLoading = true;
    _currentLessonId = lessonId;
    notifyListeners();

    try {
      _messages = await _chatService.getHistory(lessonId);
    } catch (_) {
      _messages = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearChat() {
    _messages = [];
    _errorMessage = null;
    _currentLessonId = null;
    notifyListeners();
  }
}
