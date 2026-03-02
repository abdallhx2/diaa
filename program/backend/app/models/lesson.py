# ============================================================
# File: models/lesson.py
# Purpose: موديل الدرس — جدول lessons في قاعدة البيانات
# Owner: فاطمة — Database Lead
# Branch: feature/backend-models
# Week: Week 1 — إنشاء جداول قاعدة البيانات
# ============================================================

# --- Required Imports ---
# import uuid
# from sqlalchemy import Column, String, Text, DateTime
# from sqlalchemy.dialects.postgresql import UUID
# from sqlalchemy.orm import relationship
# from sqlalchemy.sql import func
# from app.database import Base

# --- Implementation Steps ---

# Step 1: إنشاء كلاس Lesson يرث من Base
# - __tablename__ = "lessons"

# Step 2: تعريف الأعمدة (Columns)
# - id: UUID — Primary Key, default=uuid.uuid4
# - title: VARCHAR(200) — Not Null — عنوان الدرس
# - subject: VARCHAR(100) — Not Null — المادة (مثل: "لغة عربية")
# - grade_level: VARCHAR(20) — Not Null — المرحلة الدراسية
# - original_text: TEXT — Not Null — النص الأصلي للدرس (المستخرج من OCR أو المُدخل)
# - qr_code: VARCHAR(100) — Nullable — كود QR مرتبط بالدرس
# - audio_url: VARCHAR(500) — Nullable — رابط الملف الصوتي (يتولد من TTS)
# - created_at: TIMESTAMP — Default=now() — تاريخ الإنشاء

# Step 3: تعريف العلاقات (Relationships)
# - sessions = relationship("LearningSession", back_populates="lesson")   — علاقة 1:N مع الجلسات
# - quizzes = relationship("Quiz", back_populates="lesson")               — علاقة 1:N مع الاختبارات
# - chat_messages = relationship("ChatMessage", back_populates="lesson")  — علاقة 1:N مع الرسائل

# --- Dependencies ---
# - app/database.py (Base class)

# --- Schema Fields (للربط مع lesson_schema.py) ---
# - LessonCreate: title, subject, grade_level, original_text, qr_code
# - LessonResponse: id, title, subject, grade_level, original_text, qr_code, audio_url, created_at
# - LessonUpdate: title, subject, grade_level, original_text

# --- Notes ---
# - original_text يحتوي على النص العربي الكامل للدرس
# - audio_url يتعبى بعد ما TTS Service تولد الصوت
# - qr_code يُستخدم لربط الدرس بكود QR مطبوع في الكتاب
