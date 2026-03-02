# ============================================================
# File: routers/student_router.py
# Purpose: نقاط نهاية الطالب — لوحة التحكم والجلسات والتقدم
# Owner: مشاعل — Backend Lead
# Branch: feature/backend-auth
# Week: Week 2 — واجهات الطالب
# ============================================================

# --- Required Imports ---
# from fastapi import APIRouter, Depends, Request, HTTPException
# from sqlalchemy.orm import Session
# from app.database import get_db
# from app.models.student import Student
# from app.models.learning_session import LearningSession
# from app.models.quiz_result import QuizResult
# from app.schemas.student_schema import StudentDashboard, StudentResponse
# from app.utils.helpers import format_response

# --- Implementation Steps ---

# Step 1: إنشاء الراوتر
# - router = APIRouter()

# Step 2: GET /dashboard — لوحة تحكم الطالب
# - @router.get("/dashboard")
# - يحتاج مصادقة (student role فقط)
# - تحققي إن request.state.user.role == "student"
# - اجلبي بيانات الطالب من students table
# - اجلبي آخر 5 جلسات تعلم (recent_sessions)
# - اجلبي آخر 5 نتائج اختبارات (recent_quizzes)
# - احسبي نسبة التقدم (progress_score)
# - ارجعي format_response(True, StudentDashboard(...), "لوحة تحكم الطالب")

# Step 3: GET /sessions — قائمة جلسات التعلم
# - @router.get("/sessions")
# - يحتاج مصادقة (student role فقط)
# - اجلبي جميع جلسات الطالب مرتبة بالأحدث
# - ارجعي format_response(True, sessions_list, "جلسات التعلم")

# Step 4: GET /progress — نسبة التقدم
# - @router.get("/progress")
# - يحتاج مصادقة (student role فقط)
# - احسبي النسبة من quiz_results + learning_sessions
# - ارجعي format_response(True, {"progress_percentage": score}, "نسبة التقدم")

# --- Dependencies ---
# - app/database.py (get_db)
# - app/models/student.py, learning_session.py, quiz_result.py
# - app/schemas/student_schema.py
# - app/middleware/auth_middleware.py (التحقق من التوكن)

# --- API Endpoints ---
# GET /api/student/dashboard  — لوحة تحكم الطالب
# GET /api/student/sessions   — قائمة الجلسات
# GET /api/student/progress   — نسبة التقدم

# --- Notes ---
# - جميع الـ endpoints تحتاج مصادقة + role = student
# - لو المستخدم مو student — ارجعي 403 Forbidden
# - استخدمي format_response دائماً
# - { success: bool, data: any, message: str }
