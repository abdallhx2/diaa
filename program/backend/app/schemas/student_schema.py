# ============================================================
# File: schemas/student_schema.py
# Purpose: مخططات الطالب — التحقق من بيانات الطالب ولوحة التحكم
# Owner: رنيم — API Developer
# Branch: feature/backend-routers
# Week: Week 2 — إعداد الـ schemas
# ============================================================

# --- Required Imports ---
# from pydantic import BaseModel
# from typing import Optional, List
# from uuid import UUID
# from decimal import Decimal

# --- Implementation Steps ---

# Step 1: StudentCreate — بيانات إنشاء طالب جديد
# - class StudentCreate(BaseModel):
#     - user_id: UUID          — معرف المستخدم المرتبط
#     - parent_id: Optional[UUID] = None  — معرف ولي الأمر (اختياري)
#     - age: int               — العمر
#     - grade: str             — الصف الدراسي
#     - learning_level: str    — مستوى التعلم

# Step 2: StudentResponse — بيانات الطالب في الـ response
# - class StudentResponse(BaseModel):
#     - id: UUID
#     - name: str              — يُجلب من User المرتبط
#     - age: int
#     - grade: str
#     - learning_level: str
#     - progress_score: Decimal
#     - class Config:
#         - from_attributes = True

# Step 3: StudentDashboard — لوحة تحكم الطالب
# - class StudentDashboard(BaseModel):
#     - student_info: StudentResponse     — بيانات الطالب الأساسية
#     - recent_sessions: List[dict]       — آخر 5 جلسات تعلم
#     - recent_quizzes: List[dict]        — آخر 5 نتائج اختبارات
#     - progress_score: Decimal           — نسبة التقدم الكلية

# --- Dependencies ---
# - لا يعتمد على ملفات أخرى (schemas مستقلة)

# --- Notes ---
# - StudentDashboard يُستخدم في GET /api/student/dashboard
# - recent_sessions يحتوي على: lesson_title, session_type, started_at, duration_minutes
# - recent_quizzes يحتوي على: quiz_type, score, taken_at
# - progress_score نسبة مئوية من 0 إلى 100
