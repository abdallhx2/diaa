# ============================================================
# File: schemas/quiz_schema.py
# Purpose: مخططات الاختبارات — التحقق من بيانات الأسئلة والإجابات والنتائج
# Owner: رنيم — API Developer
# Branch: feature/backend-routers
# Week: Week 2 — إعداد الـ schemas
# ============================================================

# --- Required Imports ---
# from pydantic import BaseModel
# from typing import List, Optional
# from uuid import UUID
# from decimal import Decimal
# from datetime import datetime

# --- Implementation Steps ---

# Step 1: QuizCreate — بيانات إنشاء اختبار جديد (للمشرف)
# - class QuizCreate(BaseModel):
#     - lesson_id: UUID         — معرف الدرس المرتبط
#     - quiz_type: str          — نوع الاختبار: "reading" | "writing" | "comprehension"
#     - question_text: str      — نص السؤال بالعربي
#     - options: List[str]      — قائمة الخيارات (مثل: ["خيار 1", "خيار 2", ...])
#     - correct_answer: str     — الإجابة الصحيحة

# Step 2: QuizResponse — بيانات الاختبار في الـ response (بدون الإجابة الصحيحة!)
# - class QuizResponse(BaseModel):
#     - id: UUID
#     - lesson_id: UUID
#     - quiz_type: str
#     - question_text: str
#     - options: List[str]
#     # ملاحظة مهمة: لا تضيفي correct_answer هنا! عشان الطالب ما يغش
#     - class Config:
#         - from_attributes = True

# Step 3: QuizSubmitRequest — طلب تسليم إجابات
# - class QuizSubmitRequest(BaseModel):
#     - quiz_id: UUID           — معرف الاختبار
#     - student_id: UUID        — معرف الطالب
#     - answers: List[str]      — قائمة إجابات الطالب

# Step 4: QuizResultResponse — نتيجة الاختبار
# - class QuizResultResponse(BaseModel):
#     - id: UUID
#     - score: Decimal          — الدرجة (نسبة مئوية 0-100)
#     - answers_detail: List[dict]  — تفاصيل كل إجابة: [{"question": "...", "answer": "...", "is_correct": true}]
#     - taken_at: datetime
#     - class Config:
#         - from_attributes = True

# --- Dependencies ---
# - لا يعتمد على ملفات أخرى (schemas مستقلة)

# --- Notes ---
# - مهم جداً: QuizResponse ما يحتوي على correct_answer عشان ما ينكشف للطالب
# - quiz_type لازم يكون واحد من: "reading", "writing", "comprehension"
# - answers_detail في QuizResultResponse يعرض للطالب وش غلط فيه بعد التسليم
# - options في QuizCreate لازم تحتوي على correct_answer كواحد من الخيارات
