import 'package:flutter/material.dart';

class ChatMessageModel {
  final String  question;
  final String  answer;
  final String? audioUrl;
  final String  lessonId;
  final DateTime timestamp;
  final bool    isFromUser;

  const ChatMessageModel({
    required this.question,
    required this.answer,
    this.audioUrl,
    required this.lessonId,
    required this.timestamp,
    required this.isFromUser,
  });
}

class ChatService {
  Future<Map<String, dynamic>> askQuestion(String question, String lessonId) async =>
      {'answer': '', 'audioUrl': null};
  Future<List<ChatMessageModel>> getHistory(String lessonId) async => [];
}

class AppConstants {
  static const int maxChatMessages = 20;
}

class ChatProvider extends ChangeNotifier {
  List<ChatMessageModel> _messages = [];
  bool    _isLoading    = false;
  String? _errorMessage;
  final ChatService _chatService = ChatService();

  List<ChatMessageModel> get messages     => List.unmodifiable(_messages);
  bool                   get isLoading    => _isLoading;
  int                    get messageCount => _messages.length;
  String?                get errorMessage => _errorMessage;
  bool get canSendMore => _messages.length < AppConstants.maxChatMessages;

  Future<void> sendMessage(String question, String lessonId) async {
    _errorMessage = null;

    if (messageCount >= AppConstants.maxChatMessages) {
      _errorMessage =
          'لقد وصلت إلى الحد الأقصى للرسائل في هذه الجلسة (${AppConstants.maxChatMessages} رسالة).';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final userMsg = ChatMessageModel(
        question:   question,
        answer:     '',
        audioUrl:   null,
        lessonId:   lessonId,
        timestamp:  DateTime.now(),
        isFromUser: true,
      );
      _messages.add(userMsg);
      notifyListeners();

      final Map<String, dynamic> response =
          await _chatService.askQuestion(question, lessonId);

      final assistantMsg = ChatMessageModel(
        question:   question,
        answer:     response['answer'] as String? ?? '',
        audioUrl:   response['audioUrl'] as String?,
        lessonId:   lessonId,
        timestamp:  DateTime.now(),
        isFromUser: false,
      );
      _messages.add(assistantMsg);
    } catch (e) {
      _errorMessage = 'تعذّر إرسال الرسالة. يرجى التحقق من الاتصال والمحاولة مجدداً.';
      if (_messages.isNotEmpty && _messages.last.isFromUser) {
        _messages.removeLast();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadHistory(String lessonId) async {
    _errorMessage = null;
    _isLoading    = true;
    notifyListeners();

    try {
      final List<ChatMessageModel> history =
          await _chatService.getHistory(lessonId);
      _messages = history;
    } catch (e) {
      _errorMessage = 'تعذّر تحميل سجل المحادثة. يرجى المحاولة مجدداً.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages     = [];
    _errorMessage = null;
    _isLoading    = false;
    notifyListeners();
  }
}