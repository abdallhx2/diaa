# ============================================================
# File: routers/chat_router.py
# Purpose: نقاط نهاية المحادثة الذكية — AI Chat مع المساعد التعليمي
# Owner: رنيم — API Developer
# Branch: feature/backend-routers
# Week: Week 2 — واجهة المحادثة الذكية
# ============================================================

# --- Required Imports ---
# from fastapi import APIRouter, Depends, HTTPException, Request
# from sqlalchemy.orm import Session
# from app.database import get_db
# from app.services.chat_service import ask_question
# from app.models.chat_message import ChatMessage
# from app.models.lesson import Lesson
# from app.schemas.chat_schema import ChatRequest, ChatResponse, ChatHistoryResponse
# from app.utils.helpers import format_response

# --- Implementation Steps ---

# Step 1: إنشاء الراوتر
# - router = APIRouter()

# Step 2: POST /ask — إرسال سؤال للمساعد الذكي
# - @router.post("/ask")
# - يحتاج مصادقة (student role)
# - استلمي ChatRequest(question, lesson_id)
# - اجلبي الدرس من DB بـ lesson_id
# - لو ما لقيتيه — ارجعي 404
# - تحققي من عدد الرسائل في هذي الجلسة (أقصى 20 رسالة):
#   - messages_count = db.query(ChatMessage).filter_by(student_id=..., lesson_id=...).count()
#   - if messages_count >= 20: ارجعي 429 "تجاوزتِ الحد الأقصى للرسائل"
# - استدعي ask_question(question, lesson.original_text) من chat_service
# - احفظي الرسالة في chat_messages:
#   - ChatMessage(student_id, lesson_id, user_message=question, bot_response=answer)
# - ارجعي format_response(True, ChatResponse(answer=answer, audio_url=None), "تم الإجابة")

# Step 3: GET /history/{lesson_id} — سجل المحادثة لدرس معين
# - @router.get("/history/{lesson_id}")
# - يحتاج مصادقة (student role)
# - اجلبي جميع الرسائل للطالب الحالي في هذا الدرس
# - رتبيها بالأقدم أولاً (created_at ASC)
# - ارجعي format_response(True, ChatHistoryResponse(messages=messages_list), "سجل المحادثة")

# --- Dependencies ---
# - app/services/chat_service.py (ask_question)
# - app/models/chat_message.py (ChatMessage model)
# - app/models/lesson.py (Lesson model)
# - app/schemas/chat_schema.py (ChatRequest, ChatResponse, ChatHistoryResponse)
# - app/database.py (get_db)

# --- API Endpoints ---
# POST /api/chat/ask                — إرسال سؤال
# GET  /api/chat/history/{lesson_id} — سجل المحادثة

# --- Notes ---
# - الحد الأقصى: 20 رسالة لكل طالب لكل درس
# - البوت يجاوب فقط من محتوى الدرس (original_text)
# - لو السؤال خارج الدرس — البوت يرد: "هذا السؤال خارج محتوى الدرس الحالي"
# - استخدمي format_response دائماً: { success: bool, data: any, message: str }
