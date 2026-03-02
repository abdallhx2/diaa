# ============================================================
# File: schemas/lesson_schema.py
# Purpose: مخططات الدرس — التحقق من بيانات إنشاء وتعديل الدروس
# Owner: رنيم — API Developer
# Branch: feature/backend-routers
# Week: Week 2 — إعداد الـ schemas
# ============================================================

# --- Required Imports ---
# from pydantic import BaseModel
# from typing import Optional
# from uuid import UUID
# from datetime import datetime

# --- Implementation Steps ---

# Step 1: LessonCreate — بيانات إنشاء درس جديد
# - class LessonCreate(BaseModel):
#     - title: str             — عنوان الدرس
#     - subject: str           — المادة (مثل: "لغة عربية")
#     - grade_level: str       — المرحلة الدراسية
#     - original_text: str     — النص الأصلي للدرس
#     - qr_code: Optional[str] = None  — كود QR (اختياري)

# Step 2: LessonResponse — بيانات الدرس في الـ response
# - class LessonResponse(BaseModel):
#     - id: UUID
#     - title: str
#     - subject: str
#     - grade_level: str
#     - original_text: str
#     - qr_code: Optional[str]
#     - audio_url: Optional[str]   — رابط الصوت (يتولد من TTS)
#     - created_at: datetime
#     - class Config:
#         - from_attributes = True

# Step 3: LessonUpdate — بيانات تعديل درس (جميع الحقول اختيارية)
# - class LessonUpdate(BaseModel):
#     - title: Optional[str] = None
#     - subject: Optional[str] = None
#     - grade_level: Optional[str] = None
#     - original_text: Optional[str] = None

# --- Dependencies ---
# - لا يعتمد على ملفات أخرى (schemas مستقلة)

# --- Notes ---
# - LessonCreate يُستخدم في POST /api/admin/lessons
# - LessonUpdate يُستخدم في PUT /api/admin/lessons/{id}
# - LessonResponse يُرجع في كل endpoints اللي تتعامل مع الدروس
# - audio_url يكون None لين يتم توليد الصوت من TTS service
