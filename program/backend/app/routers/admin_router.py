# ============================================================
# File: routers/admin_router.py
# Purpose: نقاط نهاية لوحة تحكم المشرف — إدارة المستخدمين والدروس والسجلات
# Owner: رنيم — API Developer
# Branch: feature/backend-routers
# Week: Week 2 — واجهات المشرف
# ============================================================

# --- Required Imports ---
# from fastapi import APIRouter, Depends, HTTPException, Request
# from sqlalchemy.orm import Session
# from app.database import get_db
# from app.models.user import User
# from app.models.lesson import Lesson
# from app.models.system_log import SystemLog
# from app.models.learning_session import LearningSession
# from app.schemas.admin_schema import AdminDashboard, SystemSettings
# from app.schemas.auth_schema import UserResponse
# from app.schemas.lesson_schema import LessonCreate, LessonResponse, LessonUpdate
# from app.utils.helpers import format_response

# --- Implementation Steps ---

# Step 1: إنشاء الراوتر
# - router = APIRouter()

# Step 2: إنشاء dependency للتحقق من صلاحية المشرف
# - def require_admin(request: Request):
# -     if request.state.user.role != "admin": raise HTTPException(403)
# - استخدميها في كل endpoint: Depends(require_admin)

# Step 3: GET /dashboard — لوحة تحكم المشرف (إحصائيات النظام)
# - @router.get("/dashboard", dependencies=[Depends(require_admin)])
# - احسبي: total_users (عدد المستخدمين الكلي)
# - احسبي: active_users_7d (المستخدمين النشطين آخر 7 أيام)
# - احسبي: total_sessions_week (الجلسات هذا الأسبوع)
# - احسبي: total_sessions_month (الجلسات هذا الشهر)
# - احسبي: avg_response_time (متوسط وقت الاستجابة من system_logs)
# - ارجعي format_response(True, AdminDashboard(...), "إحصائيات النظام")

# Step 4: CRUD للمستخدمين
# - GET    /users         — قائمة جميع المستخدمين (مع pagination)
# - POST   /users         — إنشاء مستخدم جديد (للمشرف فقط)
# - PUT    /users/{id}    — تعديل بيانات مستخدم
# - DELETE /users/{id}    — حذف مستخدم (soft delete: is_active = False)

# Step 5: CRUD للدروس
# - GET    /lessons       — قائمة جميع الدروس (مع pagination)
# - POST   /lessons       — إنشاء درس جديد (استلمي LessonCreate)
# - PUT    /lessons/{id}  — تعديل درس (استلمي LessonUpdate)
# - DELETE /lessons/{id}  — حذف درس

# Step 6: GET /logs — سجلات النظام
# - @router.get("/logs", dependencies=[Depends(require_admin)])
# - دعمي الفلترة بـ query parameters:
#   - action: str (مثل: "login", "scan_text")
#   - user_id: UUID (سجلات مستخدم معين)
#   - date_from, date_to: datetime (نطاق تاريخي)
#   - page, per_page: int (pagination)
# - ارجعي format_response(True, logs_list, "سجلات النظام")

# Step 7: إعدادات النظام
# - GET /settings  — جلب الإعدادات الحالية
# - PUT /settings  — تعديل الإعدادات

# --- Dependencies ---
# - app/database.py (get_db)
# - app/models/* (User, Lesson, SystemLog, LearningSession)
# - app/schemas/admin_schema.py (AdminDashboard, SystemSettings)
# - app/schemas/lesson_schema.py (LessonCreate, LessonResponse, LessonUpdate)

# --- API Endpoints ---
# GET    /api/admin/dashboard          — إحصائيات النظام
# GET    /api/admin/users              — قائمة المستخدمين
# POST   /api/admin/users              — إنشاء مستخدم
# PUT    /api/admin/users/{id}         — تعديل مستخدم
# DELETE /api/admin/users/{id}         — حذف مستخدم
# GET    /api/admin/lessons            — قائمة الدروس
# POST   /api/admin/lessons            — إنشاء درس
# PUT    /api/admin/lessons/{id}       — تعديل درس
# DELETE /api/admin/lessons/{id}       — حذف درس
# GET    /api/admin/logs               — سجلات النظام
# GET    /api/admin/settings           — جلب الإعدادات
# PUT    /api/admin/settings           — تعديل الإعدادات

# --- Notes ---
# - جميع الـ endpoints تحتاج مصادقة + role = admin
# - استخدمي require_admin dependency في كل endpoint
# - الحذف يكون soft delete (is_active = False) مو حذف فعلي
# - استخدمي pagination في القوائم الطويلة
# - استخدمي format_response دائماً: { success: bool, data: any, message: str }
