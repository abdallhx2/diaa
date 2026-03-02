# ============================================================
# File: models/learning_session.py
# Purpose: موديل جلسة التعلم — جدول learning_sessions في قاعدة البيانات
# Owner: فاطمة — Database Lead
# Branch: feature/backend-models
# Week: Week 1 — إنشاء جداول قاعدة البيانات
# ============================================================

# --- Required Imports ---
# import uuid
# from sqlalchemy import Column, Integer, DateTime, ForeignKey, Enum as SQLEnum
# from sqlalchemy.dialects.postgresql import UUID
# from sqlalchemy.orm import relationship
# from sqlalchemy.sql import func
# from app.database import Base

# --- Implementation Steps ---

# Step 1: تعريف الـ Enum لنوع الجلسة
# - أنشئي Enum بالقيم: 'scan', 'qr', 'upload'
# - scan = مسح بالكاميرا
# - qr = مسح كود QR
# - upload = رفع صورة

# Step 2: إنشاء كلاس LearningSession يرث من Base
# - __tablename__ = "learning_sessions"

# Step 3: تعريف الأعمدة (Columns)
# - id: UUID — Primary Key, default=uuid.uuid4
# - student_id: UUID — ForeignKey("students.id"), Not Null — الطالب صاحب الجلسة
# - lesson_id: UUID — ForeignKey("lessons.id"), Not Null — الدرس المرتبط
# - session_type: ENUM('scan', 'qr', 'upload') — Not Null — طريقة الوصول للدرس
# - started_at: TIMESTAMP — Default=now() — وقت بداية الجلسة
# - ended_at: TIMESTAMP — Nullable — وقت نهاية الجلسة (Null = لسا شغالة)
# - duration_minutes: INTEGER — Nullable — مدة الجلسة بالدقائق (يتحسب عند الانتهاء)

# Step 4: تعريف العلاقات (Relationships)
# - student = relationship("Student", back_populates="sessions")  — العلاقة مع الطالب
# - lesson = relationship("Lesson", back_populates="sessions")    — العلاقة مع الدرس

# --- Dependencies ---
# - app/database.py (Base class)
# - app/models/student.py (Student model — FK)
# - app/models/lesson.py (Lesson model — FK)

# --- Notes ---
# - الجلسة تبدأ لما الطالب يفتح درس (scan/qr/upload)
# - ended_at يكون None لين الطالب يقفل الدرس
# - duration_minutes يتحسب تلقائياً: ended_at - started_at
# - يُستخدم في التقارير لحساب وقت الدراسة الكلي
