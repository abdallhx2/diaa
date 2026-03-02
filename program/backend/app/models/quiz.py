# ============================================================
# File: models/quiz.py
# Purpose: موديل الاختبار — جدول quizzes في قاعدة البيانات
# Owner: فاطمة — Database Lead
# Branch: feature/backend-models
# Week: Week 1 — إنشاء جداول قاعدة البيانات
# ============================================================

# --- Required Imports ---
# import uuid
# from sqlalchemy import Column, String, Text, ForeignKey, Enum as SQLEnum
# from sqlalchemy.dialects.postgresql import UUID, JSONB
# from sqlalchemy.orm import relationship
# from app.database import Base

# --- Implementation Steps ---

# Step 1: تعريف الـ Enum لنوع الاختبار
# - أنشئي Enum بالقيم: 'reading', 'writing', 'comprehension'
# - reading = اختبار قراءة
# - writing = اختبار كتابة
# - comprehension = اختبار فهم واستيعاب

# Step 2: إنشاء كلاس Quiz يرث من Base
# - __tablename__ = "quizzes"

# Step 3: تعريف الأعمدة (Columns)
# - id: UUID — Primary Key, default=uuid.uuid4
# - lesson_id: UUID — ForeignKey("lessons.id"), Not Null — الدرس المرتبط بالاختبار
# - quiz_type: ENUM('reading', 'writing', 'comprehension') — Not Null — نوع الاختبار
# - question_text: TEXT — Not Null — نص السؤال بالعربي
# - options: JSONB — Not Null — الخيارات كـ JSON array، مثال:
#   ["الخيار الأول", "الخيار الثاني", "الخيار الثالث", "الخيار الرابع"]
# - correct_answer: VARCHAR(200) — Not Null — الإجابة الصحيحة

# Step 4: تعريف العلاقات (Relationships)
# - lesson = relationship("Lesson", back_populates="quizzes")          — العلاقة مع الدرس
# - results = relationship("QuizResult", back_populates="quiz")        — علاقة 1:N مع النتائج

# --- Dependencies ---
# - app/database.py (Base class)
# - app/models/lesson.py (Lesson model — FK)

# --- Schema Fields (للربط مع quiz_schema.py) ---
# - QuizCreate: lesson_id, quiz_type, question_text, options, correct_answer
# - QuizResponse: id, lesson_id, quiz_type, question_text, options (بدون correct_answer!)

# --- Notes ---
# - الـ options تُخزّن كـ JSONB عشان مرونة في عدد الخيارات
# - مهم: QuizResponse ما يرجّع correct_answer عشان الطالب ما يغش
# - كل درس ممكن يكون عنده أكثر من اختبار بأنواع مختلفة
