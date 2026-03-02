# ============================================================
# File: schemas/chat_schema.py
# Purpose: مخططات المحادثة الذكية — التحقق من بيانات الأسئلة والردود
# Owner: رنيم — API Developer
# Branch: feature/backend-routers
# Week: Week 2 — إعداد الـ schemas
# ============================================================

# --- Required Imports ---
# from pydantic import BaseModel
# from typing import List, Optional
# from uuid import UUID
# from datetime import datetime

# --- Implementation Steps ---

# Step 1: ChatRequest — طلب إرسال سؤال للمساعد الذكي
# - class ChatRequest(BaseModel):
#     - question: str         — سؤال الطالب بالعربي
#     - lesson_id: UUID       — معرف الدرس المرتبط (عشان البوت يجاوب من محتواه)

# Step 2: ChatResponse — رد المساعد الذكي
# - class ChatResponse(BaseModel):
#     - answer: str           — إجابة البوت بالعربي
#     - audio_url: Optional[str] = None  — رابط الصوت (لو تم تحويل الرد لصوت)

# Step 3: ChatHistoryResponse — سجل المحادثة لدرس معين
# - class ChatHistoryResponse(BaseModel):
#     - messages: List[dict]  — قائمة الرسائل، كل رسالة تحتوي على:
#       # {
#       #   "user_message": "ما معنى كلمة...؟",
#       #   "bot_response": "معنى الكلمة هو...",
#       #   "created_at": "2026-03-01T10:30:00"
#       # }

# --- Dependencies ---
# - لا يعتمد على ملفات أخرى (schemas مستقلة)

# --- Notes ---
# - ChatRequest يُستخدم في POST /api/chat/ask
# - ChatHistoryResponse يُستخدم في GET /api/chat/history/{lesson_id}
# - audio_url في ChatResponse يكون None لو ما طلب الطالب تحويل الرد لصوت
# - الحد الأقصى للرسائل: 20 رسالة لكل طالب لكل درس (يُتحقق في chat_router)
