from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.orm import Session
from sqlalchemy import func
from datetime import datetime, timedelta, timezone
from uuid import UUID
from typing import Optional

from app.database import get_db
from app.models.user import User
from app.models.lesson import Lesson
from app.models.system_log import SystemLog
from app.models.learning_session import LearningSession
from app.schemas.lesson_schema import LessonCreate, LessonResponse, LessonUpdate
from app.utils.helpers import format_response

router = APIRouter()

# التحقق من صلاحية المشرف
def require_admin(request: Request):
    user = request.state.user
    if user.role != "admin":
        raise HTTPException(status_code=403, detail="غير مصرح")

# GET /dashboard
@router.get("/dashboard")
def get_dashboard(
    request: Request,
    db: Session = Depends(get_db),
    _: None = Depends(require_admin)
):
    now = datetime.now(timezone.utc)
    week_ago = now - timedelta(days=7)
    month_ago = now - timedelta(days=30)

    total_users = db.query(User).count()
    active_users_7d = db.query(User).filter(User.last_login >= week_ago).count()
    total_sessions_week = db.query(LearningSession).filter(LearningSession.created_at >= week_ago).count()
    total_sessions_month = db.query(LearningSession).filter(LearningSession.created_at >= month_ago).count()

    data = {
        "total_users": total_users,
        "active_users_7d": active_users_7d,
        "total_sessions_week": total_sessions_week,
        "total_sessions_month": total_sessions_month,
    }
    return format_response(True, data, "إحصائيات النظام")

# GET /users
@router.get("/users")
def get_users(
    request: Request,
    page: int = 1,
    per_page: int = 10,
    db: Session = Depends(get_db),
    _: None = Depends(require_admin)
):
    skip = (page - 1) * per_page
    users = db.query(User).offset(skip).limit(per_page).all()
    return format_response(True, [u.__dict__ for u in users], "قائمة المستخدمين")

# DELETE /users/{id} — soft delete
@router.delete("/users/{user_id}")
def delete_user(
    user_id: UUID,
    request: Request,
    db: Session = Depends(get_db),
    _: None = Depends(require_admin)
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="المستخدم غير موجود")
    user.is_active = False
    db.commit()
    return format_response(True, None, "تم حذف المستخدم")

# GET /lessons
@router.get("/lessons")
def get_lessons(
    request: Request,
    page: int = 1,
    per_page: int = 10,
    db: Session = Depends(get_db),
    _: None = Depends(require_admin)
):
    skip = (page - 1) * per_page
    lessons = db.query(Lesson).offset(skip).limit(per_page).all()
    return format_response(True, [LessonResponse.model_validate(l).model_dump() for l in lessons], "قائمة الدروس")

# POST /lessons
@router.post("/lessons")
def create_lesson(
    lesson_data: LessonCreate,
    request: Request,
    db: Session = Depends(get_db),
    _: None = Depends(require_admin)
):
    lesson = Lesson(**lesson_data.model_dump())
    db.add(lesson)
    db.commit()
    db.refresh(lesson)
    return format_response(True, LessonResponse.model_validate(lesson).model_dump(), "تم إنشاء الدرس")

# PUT /lessons/{id}
@router.put("/lessons/{lesson_id}")
def update_lesson(
    lesson_id: UUID,
    lesson_data: LessonUpdate,
    request: Request,
    db: Session = Depends(get_db),
    _: None = Depends(require_admin)
):
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="الدرس غير موجود")
    for key, value in lesson_data.model_dump(exclude_none=True).items():
        setattr(lesson, key, value)
    db.commit()
    db.refresh(lesson)
    return format_response(True, LessonResponse.model_validate(lesson).model_dump(), "تم تعديل الدرس")

# DELETE /lessons/{id}
@router.delete("/lessons/{lesson_id}")
def delete_lesson(
    lesson_id: UUID,
    request: Request,
    db: Session = Depends(get_db),
    _: None = Depends(require_admin)
):
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="الدرس غير موجود")
    db.delete(lesson)
    db.commit()
    return format_response(True, None, "تم حذف الدرس")

# GET /logs
@router.get("/logs")
def get_logs(
    request: Request,
    action: Optional[str] = None,
    user_id: Optional[UUID] = None,
    date_from: Optional[datetime] = None,
    date_to: Optional[datetime] = None,
    page: int = 1,
    per_page: int = 10,
    db: Session = Depends(get_db),
    _: None = Depends(require_admin)
):
    query = db.query(SystemLog)
    if action:
        query = query.filter(SystemLog.action == action)
    if user_id:
        query = query.filter(SystemLog.user_id == user_id)
    if date_from:
        query = query.filter(SystemLog.created_at >= date_from)
    if date_to:
        query = query.filter(SystemLog.created_at <= date_to)
    skip = (page - 1) * per_page
    logs = query.offset(skip).limit(per_page).all()
    return format_response(True, [l.__dict__ for l in logs], "سجلات النظام")