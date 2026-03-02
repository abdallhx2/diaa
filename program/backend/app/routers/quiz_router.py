# ============================================================
# File: routers/quiz_router.py
# Purpose: نقاط نهاية الاختبارات — عرض الأسئلة وتسليم الإجابات والنتائج
# Owner: رنيم — API Developer
# Branch: feature/backend-routers
# Week: Week 2 — واجهات الاختبارات
# ============================================================

# --- Required Imports ---
# from fastapi import APIRouter, Depends, HTTPException, Request
# from sqlalchemy.orm import Session
# from app.database import get_db
# from app.services.quiz_service import get_quizzes_for_lesson, submit_quiz, get_student_results
# from app.schemas.quiz_schema import QuizResponse, QuizSubmitRequest, QuizResultResponse
# from app.utils.helpers import format_response

# --- Implementation Steps ---

# Step 1: إنشاء الراوتر
# - router = APIRouter()

# Step 2: GET /{lesson_id} — جلب اختبارات درس معين
# - @router.get("/{lesson_id}")
# - يحتاج مصادقة
# - استدعي get_quizzes_for_lesson(lesson_id) من quiz_service
# - ارجعي format_response(True, quizzes_list, "اختبارات الدرس")
# - ملاحظة: لا ترجعي correct_answer في الـ response!

# Step 3: GET /types/{type} — جلب اختبارات حسب النوع
# - @router.get("/types/{type}")
# - يحتاج مصادقة
# - type يكون: reading, writing, أو comprehension
# - اجلبي من DB كل الاختبارات من هذا النوع
# - ارجعي format_response(True, quizzes_list, f"اختبارات {type}")

# Step 4: POST /submit — تسليم إجابات اختبار
# - @router.post("/submit")
# - يحتاج مصادقة (student role)
# - استلمي QuizSubmitRequest(quiz_id, student_id, answers: list)
# - استدعي submit_quiz(student_id, quiz_id, answers) من quiz_service
# - الدالة تحسب الدرجة وتحفظ النتيجة في quiz_results
# - ارجعي format_response(True, QuizResultResponse(...), "تم تسليم الاختبار")

# Step 5: GET /results/{student_id} — نتائج طالب معين
# - @router.get("/results/{student_id}")
# - يحتاج مصادقة
# - استدعي get_student_results(student_id) من quiz_service
# - ارجعي format_response(True, results_list, "نتائج الطالب")

# --- Dependencies ---
# - app/services/quiz_service.py (get_quizzes_for_lesson, submit_quiz, get_student_results)
# - app/schemas/quiz_schema.py (QuizResponse, QuizSubmitRequest, QuizResultResponse)
# - app/database.py (get_db)

# --- API Endpoints ---
# GET  /api/quizzes/{lesson_id}        — اختبارات الدرس
# GET  /api/quizzes/types/{type}       — اختبارات حسب النوع
# POST /api/quizzes/submit             — تسليم الإجابات
# GET  /api/quizzes/results/{student_id} — نتائج الطالب

# --- Notes ---
# - مهم: لا ترجعي correct_answer في GET endpoints عشان الطالب ما يغش
# - أنواع الاختبارات: reading (قراءة), writing (كتابة), comprehension (فهم)
# - استخدمي format_response دائماً: { success: bool, data: any, message: str }
