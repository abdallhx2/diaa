// ============================================================
// File: chat_provider.dart
// Purpose: إدارة حالة المحادثة الذكية — الرسائل، الإرسال، التاريخ
// Owner: ديمة — Flutter Lead
// Branch: feature/flutter-student
// Week: 3 — شاشات الاختبارات والمحادثة الذكية
// ============================================================

// --- Required Imports ---
// import 'package:flutter/material.dart';
// import 'package:edu_smart_assistant/models/chat_message_model.dart';
// import 'package:edu_smart_assistant/services/chat_service.dart';
// import 'package:edu_smart_assistant/config/constants.dart';

// --- Implementation Steps ---
// Step 1: إنشاء class ChatProvider extends ChangeNotifier
//         - class ChatProvider extends ChangeNotifier { ... }

// Step 2: تعريف الحقول (Fields)
//         - List<ChatMessageModel> _messages = [];    // قائمة الرسائل
//         - bool _isLoading = false;                   // جاري إرسال/استقبال رسالة
//         - int get messageCount => _messages.length;  // عدد الرسائل الحالي
//         - final ChatService _chatService = ChatService();

// Step 3: إنشاء Getters
//         - List<ChatMessageModel> get messages => _messages;
//         - bool get isLoading => _isLoading;
//         - int get messageCount => _messages.length;
//         - bool get canSendMore => _messages.length < AppConstants.maxChatMessages;

// Step 4: إنشاء method sendMessage(String question, String lessonId)
//         - التحقق: إذا messageCount >= 20 → عرض رسالة "وصلت الحد الأقصى للرسائل"
//         - _isLoading = true; notifyListeners();
//         - استدعاء _chatService.askQuestion(question, lessonId)
//         - إنشاء ChatMessageModel من الاستجابة (answer + audioUrl)
//         - إضافة الرسالة لـ _messages
//         - _isLoading = false; notifyListeners();

// Step 5: إنشاء method loadHistory(String lessonId)
//         - استدعاء _chatService.getHistory(lessonId)
//         - _messages = القائمة المُرجعة
//         - notifyListeners();

// Step 6: إنشاء method clearChat()
//         - _messages = [];
//         - notifyListeners();

// --- Notes ---
// - الحد الأقصى 20 رسالة لكل جلسة (من constants.dart)
// - كل رسالة تحتوي على سؤال الطالب + رد المساعد + رابط الصوت
// - loadHistory() يُستدعى عند فتح شاشة المحادثة لتحميل المحادثات السابقة
// - يجب تشغيل الصوت تلقائياً عند وصول رد المساعد
// - clearChat() يُستدعى عند مغادرة شاشة المحادثة أو بدء درس جديد
