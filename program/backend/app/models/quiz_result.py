# ============================================================
# File: models/quiz_result.py
# Purpose: موديل نتيجة الاختبار — جدول quiz_results في قاعدة البيانات
# Owner: فاطمة — Database Lead
# Branch: feature/backend-models
# Week: Week 1 — إنشاء جداول قاعدة البيانات
# ============================================================

# --- Required Imports ---
# import uuid
# from sqlalchemy import Column, Numeric, DateTime, ForeignKey
# from sqlalchemy.dialects.postgresql import UUID, JSONB
# from sqlalchemy.orm import relationship
# from sqlalchemy.sql import func
# from app.database import Base

# --- Implementation Steps ---

# Step 1: إنشاء كلاس QuizResult يرث من Base
# - __tablename__ = "quiz_results"

# Step 2: تعريف الأعمدة (Columns)
# - id: UUID — Primary Key, default=uuid.uuid4
# - student_id: UUID — ForeignKey("students.id"), Not Null — الطالب
# - quiz_id: UUID — ForeignKey("quizzes.id"), Not Null — الاختبار
# - score: DECIMAL(5,2) — Not Null — الدرجة (نسبة مئوية 0-100)
# - answers_detail: JSONB — Not Null — تفاصيل الإجابات، مثال:
#   [{"question_id": "...", "answer": "...", "is_correct": true}, ...]
# - taken_at: TIMESTAMP — Default=now() — وقت تقديم الاختبار

# Step 3: تعريف العلاقات (Relationships)
# - student = relationship("Student", back_populates="quiz_results")  — العلاقة مع الطالب
# - quiz = relationship("Quiz", back_populates="results")             — العلاقة مع الاختبار

# --- Dependencies ---
# - app/database.py (Base class)
# - app/models/student.py (Student model — FK)
# - app/models/quiz.py (Quiz model — FK)

# --- Schema Fields (للربط مع quiz_schema.py) ---
# - QuizResultResponse: id, score, answers_detail, taken_at

# --- Notes ---
# - answers_detail يحفظ كل التفاصيل عشان نقدر نعرض للطالب وش غلط فيه
# - score تكون نسبة مئوية (مثل: 85.50)
# - يُستخدم في التقارير لحساب المعدل والتقدم
