# ============================================================
# File: routers/parent_router.py
# Purpose: نقاط نهاية ولي الأمر — عرض الأبناء والتقارير
# Owner: مشاعل — Backend Lead
# Branch: feature/backend-auth
# Week: Week 2 — واجهات ولي الأمر
# ============================================================

# --- Required Imports ---
# from fastapi import APIRouter, Depends, Request, HTTPException
# from sqlalchemy.orm import Session
# from app.database import get_db
# from app.models.parent import Parent
# from app.models.student import Student
# from app.services.report_service import get_weekly_report, get_monthly_report
# from app.schemas.student_schema import StudentResponse
# from app.schemas.report_schema import WeeklyReport, MonthlyReport
# from app.utils.helpers import format_response

# --- Implementation Steps ---

# Step 1: إنشاء الراوتر
# - router = APIRouter()

# Step 2: GET /children — قائمة أبناء ولي الأمر
# - @router.get("/children")
# - يحتاج مصادقة (parent role فقط)
# - parent_id = request.state.user.parent.id
# - اجلبي جميع الطلاب المرتبطين بـ parent_id
# - ارجعي format_response(True, children_list, "قائمة الأبناء")

# Step 3: GET /reports/{child_id} — تقرير عام عن الطفل
# - @router.get("/reports/{child_id}")
# - يحتاج مصادقة (parent role فقط)
# - تحققي إن child_id ينتمي لهذا ولي الأمر (أمان!)
# - اجلبي بيانات الطالب + آخر النتائج + نسبة التقدم
# - ارجعي format_response(True, report_data, "تقرير الطفل")

# Step 4: GET /reports/{child_id}/weekly — التقرير الأسبوعي
# - @router.get("/reports/{child_id}/weekly")
# - يحتاج مصادقة (parent role فقط)
# - تحققي إن child_id ينتمي لهذا ولي الأمر
# - استدعي get_weekly_report(child_id) من report_service
# - ارجعي format_response(True, weekly_report, "التقرير الأسبوعي")

# Step 5: GET /reports/{child_id}/monthly — التقرير الشهري
# - @router.get("/reports/{child_id}/monthly")
# - يحتاج مصادقة (parent role فقط)
# - تحققي إن child_id ينتمي لهذا ولي الأمر
# - استدعي get_monthly_report(child_id) من report_service
# - ارجعي format_response(True, monthly_report, "التقرير الشهري")

# --- Dependencies ---
# - app/database.py (get_db)
# - app/services/report_service.py (get_weekly_report, get_monthly_report)
# - app/schemas/report_schema.py (WeeklyReport, MonthlyReport)
# - app/middleware/auth_middleware.py (التحقق من التوكن)

# --- API Endpoints ---
# GET /api/parent/children                    — قائمة الأبناء
# GET /api/parent/reports/{child_id}           — تقرير عام
# GET /api/parent/reports/{child_id}/weekly    — تقرير أسبوعي
# GET /api/parent/reports/{child_id}/monthly   — تقرير شهري

# --- Notes ---
# - جميع الـ endpoints تحتاج مصادقة + role = parent
# - مهم جداً: تحققي إن child_id ينتمي فعلاً لهذا ولي الأمر (Authorization check)
# - لو ولي الأمر يحاول يشوف تقرير طفل مو تبعه — ارجعي 403 Forbidden
# - استخدمي format_response دائماً: { success: bool, data: any, message: str }
