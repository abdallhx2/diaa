# ============================================================
# File: models/chat_message.py
# Purpose: موديل رسائل المحادثة الذكية — جدول chat_messages في قاعدة البيانات
# Owner: فاطمة — Database Lead
# Branch: feature/backend-models
# Week: Week 1 — إنشاء جداول قاعدة البيانات
# ============================================================

# --- Required Imports ---
# import uuid
# from sqlalchemy import Column, Text, DateTime, ForeignKey
# from sqlalchemy.dialects.postgresql import UUID
# from sqlalchemy.orm import relationship
# from sqlalchemy.sql import func
# from app.database import Base

# --- Implementation Steps ---

# Step 1: إنشاء كلاس ChatMessage يرث من Base
# - __tablename__ = "chat_messages"

# Step 2: تعريف الأعمدة (Columns)
# - id: UUID — Primary Key, default=uuid.uuid4
# - student_id: UUID — ForeignKey("students.id"), Not Null — الطالب اللي أرسل السؤال
# - lesson_id: UUID — ForeignKey("lessons.id"), Not Null — الدرس المرتبط بالمحادثة
# - user_message: TEXT — Not Null — سؤال الطالب
# - bot_response: TEXT — Not Null — رد المساعد الذكي (من OpenAI)
# - created_at: TIMESTAMP — Default=now() — وقت الرسالة

# Step 3: تعريف العلاقات (Relationships)
# - student = relationship("Student", back_populates="chat_messages")  — العلاقة مع الطالب
# - lesson = relationship("Lesson", back_populates="chat_messages")    — العلاقة مع الدرس

# --- Dependencies ---
# - app/database.py (Base class)
# - app/models/student.py (Student model — FK)
# - app/models/lesson.py (Lesson model — FK)

# --- Notes ---
# - كل رسالة تحتوي على سؤال الطالب + رد البوت
# - المحادثة مرتبطة بدرس معين عشان البوت يجاوب من محتوى الدرس فقط
# - الحد الأقصى: 20 رسالة لكل جلسة (يُتحقق منه في chat_router)
# - يُستخدم في GET /api/chat/history/{lesson_id} لعرض سجل المحادثة
