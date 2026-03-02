# ============================================================
# File: models/student.py
# Purpose: موديل الطالب — جدول students في قاعدة البيانات
# Owner: فاطمة — Database Lead
# Branch: feature/backend-models
# Week: Week 1 — إنشاء جداول قاعدة البيانات
# ============================================================

# --- Required Imports ---
# import uuid
# from sqlalchemy import Column, String, Integer, Numeric, ForeignKey, DateTime
# from sqlalchemy.dialects.postgresql import UUID
# from sqlalchemy.orm import relationship
# from sqlalchemy.sql import func
# from app.database import Base

# --- Implementation Steps ---

# Step 1: إنشاء كلاس Student يرث من Base
# - __tablename__ = "students"

# Step 2: تعريف الأعمدة (Columns)
# - id: UUID — Primary Key, default=uuid.uuid4
# - user_id: UUID — ForeignKey("users.id"), Unique, Not Null — ربط مع جدول المستخدمين
# - parent_id: UUID — ForeignKey("parents.id"), Nullable — ربط مع ولي الأمر (اختياري)
# - age: INTEGER — Not Null — عمر الطالب
# - grade: VARCHAR(20) — Not Null — الصف الدراسي (مثل: "الثالث ابتدائي")
# - learning_level: VARCHAR(50) — Not Null — مستوى التعلم (مبتدئ/متوسط/متقدم)
# - progress_score: DECIMAL(5,2) — Default=0 — نسبة التقدم الكلية

# Step 3: تعريف العلاقات (Relationships)
# - user = relationship("User", back_populates="student")              — علاقة 1:1 مع User
# - parent = relationship("Parent", back_populates="children")         — علاقة M:1 مع Parent
# - sessions = relationship("LearningSession", back_populates="student")  — علاقة 1:N مع الجلسات
# - quiz_results = relationship("QuizResult", back_populates="student")    — علاقة 1:N مع نتائج الاختبارات
# - chat_messages = relationship("ChatMessage", back_populates="student")  — علاقة 1:N مع الرسائل

# --- Dependencies ---
# - app/database.py (Base class)
# - app/models/user.py (User model — FK)
# - app/models/parent.py (Parent model — FK)

# --- Schema Fields (للربط مع student_schema.py) ---
# - StudentResponse: id, name, age, grade, learning_level, progress_score
# - StudentCreate: user_id, parent_id, age, grade, learning_level

# --- Notes ---
# - user_id يكون Unique عشان كل مستخدم يكون عنده سجل طالب واحد فقط
# - parent_id اختياري عشان ممكن الطالب يُسجَّل بدون ولي أمر أول
# - progress_score يتحدث تلقائياً بناءً على نتائج الاختبارات والجلسات
# - DECIMAL(5,2) يعني أقصى قيمة 999.99
