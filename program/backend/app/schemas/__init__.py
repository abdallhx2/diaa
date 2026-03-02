# ============================================================
# File: schemas/__init__.py
# Purpose: تصدير جميع الـ schemas — يسهّل الاستيراد من مكان واحد
# Owner: رنيم — API Developer
# Branch: feature/backend-routers
# Week: Week 2 — إعداد الـ schemas
# ============================================================

# --- Required Imports ---
# from app.schemas.auth_schema import TokenVerifyRequest, RegisterParentRequest, AddChildRequest, UserResponse, LoginResponse
# from app.schemas.student_schema import StudentCreate, StudentResponse, StudentDashboard
# from app.schemas.lesson_schema import LessonCreate, LessonResponse, LessonUpdate
# from app.schemas.quiz_schema import QuizCreate, QuizResponse, QuizSubmitRequest, QuizResultResponse
# from app.schemas.chat_schema import ChatRequest, ChatResponse, ChatHistoryResponse
# from app.schemas.report_schema import WeeklyReport, MonthlyReport
# from app.schemas.admin_schema import AdminDashboard, SystemSettings

# --- Implementation Steps ---

# Step 1: استيراد جميع الـ schemas من ملفاتها
# Step 2: تصدير الكل باستخدام __all__ (اختياري)

# --- Notes ---
# - هذا الملف يسمح باستيراد مختصر: from app.schemas import UserResponse, StudentCreate, ...
# - كل schema يستخدم Pydantic BaseModel
