# ============================================================
# File: models/__init__.py
# Purpose: تصدير جميع الموديلات — يسهّل الاستيراد من مكان واحد
# Owner: فاطمة — Database Lead
# Branch: feature/backend-models
# Week: Week 1 — إعداد الموديلات
# ============================================================

# --- Required Imports ---
# from app.database import Base
# from app.models.user import User
# from app.models.student import Student
# from app.models.parent import Parent
# from app.models.admin import Admin
# from app.models.lesson import Lesson
# from app.models.learning_session import LearningSession
# from app.models.quiz import Quiz
# from app.models.quiz_result import QuizResult
# from app.models.chat_message import ChatMessage
# from app.models.system_log import SystemLog

# --- Implementation Steps ---

# Step 1: استيراد Base من database.py
# - هذا مهم عشان Alembic يكتشف جميع الجداول

# Step 2: استيراد كل الموديلات
# - كل موديل يمثل جدول في قاعدة البيانات
# - الاستيراد هنا يضمن تسجيل الموديلات مع Base.metadata

# Step 3: تصدير الكل باستخدام __all__
# - __all__ = [
# -     "Base",
# -     "User", "Student", "Parent", "Admin",
# -     "Lesson", "LearningSession",
# -     "Quiz", "QuizResult",
# -     "ChatMessage", "SystemLog"
# - ]

# --- Notes ---
# - لازم تستوردين كل موديل جديد هنا عشان Alembic يشتغل صح
# - هذا الملف يسمح باستيراد مختصر: from app.models import User, Student, ...
# - ترتيب الاستيراد مو مهم، بس حافظي على التنظيم
