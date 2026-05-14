import json
import os
from uuid import UUID
from datetime import datetime, timedelta, timezone
from decimal import Decimal
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.database import get_db
from app.models.user import User
from app.models.student import Student
from app.models.lesson import Lesson
from app.models.system_log import SystemLog
from app.models.learning_session import LearningSession
from app.schemas.lesson_schema import LessonCreate, LessonUpdate
from app.schemas.admin_schema import AdminDashboard, UserManage, SystemSettings
from app.middleware.auth_middleware import get_current_user
from app.utils.helpers import format_response, paginate

router = APIRouter()

# ─── File-based settings persistence ─────────────────────────────
_SETTINGS_FILE = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), "settings.json")


def _load_settings() -> SystemSettings:
    """Load settings from JSON file, or return defaults if file missing."""
    try:
        with open(_SETTINGS_FILE, "r", encoding="utf-8") as f:
            data = json.load(f)
        return SystemSettings(**data)
    except (FileNotFoundError, json.JSONDecodeError, Exception):
        return SystemSettings()


def _save_settings(settings: SystemSettings) -> None:
    """Persist settings to JSON file."""
    with open(_SETTINGS_FILE, "w", encoding="utf-8") as f:
        json.dump(settings.model_dump(), f, ensure_ascii=False, indent=2)


def require_admin(current_user: User = Depends(get_current_user)) -> User:
    """Dependency to ensure the current user is an admin."""
    if current_user.role.value != "admin":
        raise HTTPException(status_code=403, detail=format_response(False, None, "الوصول مقصور على المشرفين"))
    return current_user


# ─── Dashboard ──────────────────────────────────────────────────
@router.get("/dashboard")
async def get_dashboard(
    admin: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Get system statistics for admin dashboard."""
    try:
        now = datetime.now(timezone.utc)
        total_users = db.query(User).count()

        week_ago = now - timedelta(days=7)
        active_users_7d = (
            db.query(func.count(func.distinct(LearningSession.student_id)))
            .filter(LearningSession.started_at >= week_ago)
            .scalar()
        ) or 0

        total_sessions_week = (
            db.query(LearningSession)
            .filter(LearningSession.started_at >= week_ago)
            .count()
        )

        month_ago = now - timedelta(days=30)
        total_sessions_month = (
            db.query(LearningSession)
            .filter(LearningSession.started_at >= month_ago)
            .count()
        )

        # JSONB path query only works on PostgreSQL; skip on SQLite
        from app.config import settings as _cfg
        if _cfg.USE_MOCKS:
            avg_response_time = Decimal("0")
        else:
            avg_time = (
                db.query(func.avg(
                    func.cast(SystemLog.details["response_time_ms"].as_string(), Decimal)
                ))
                .filter(SystemLog.details.isnot(None))
                .scalar()
            )
            avg_response_time = Decimal(str(round(float(avg_time or 0), 2)))

        dashboard = AdminDashboard(
            total_users=total_users,
            active_users_7d=active_users_7d,
            total_sessions_week=total_sessions_week,
            total_sessions_month=total_sessions_month,
            avg_response_time=avg_response_time,
        )
        return format_response(True, dashboard.model_dump(), "إحصائيات النظام")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


# ─── Users CRUD ─────────────────────────────────────────────────
@router.get("/users")
async def list_users(
    page: int = Query(1, ge=1),
    per_page: int = Query(20, ge=1, le=100),
    admin: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """List all users with pagination."""
    try:
        query = db.query(User).order_by(User.created_at.desc())
        items, total = paginate(query, page, per_page)
        users_list = []
        for u in items:
            users_list.append({
                "id": str(u.id),
                "name": u.name,
                "email": u.email,
                "role": u.role.value if hasattr(u.role, "value") else u.role,
                "is_active": u.is_active,
                "created_at": str(u.created_at),
            })
        return format_response(True, {"users": users_list, "total": total, "page": page}, "قائمة المستخدمين")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.post("/users")
async def create_user(
    body: UserManage,
    admin: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Create a new user (admin only)."""
    try:
        from app.models.user import UserRole
        user = User(
            firebase_uid=f"admin_created_{datetime.now(timezone.utc).timestamp()}",
            role=UserRole(body.role) if body.role else UserRole.student,
            name=body.name or "مستخدم جديد",
            email=body.email,
            is_active=body.is_active if body.is_active is not None else True,
        )
        db.add(user)
        db.commit()
        db.refresh(user)
        return format_response(True, {"id": str(user.id), "name": user.name}, "تم إنشاء المستخدم")
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=format_response(False, None, str(e)))


@router.put("/users/{user_id}")
async def update_user(
    user_id: UUID,
    body: UserManage,
    admin: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Update a user's details."""
    try:
        user = db.query(User).filter(User.id == user_id).first()
        if not user:
            raise HTTPException(status_code=404, detail=format_response(False, None, "المستخدم غير موجود"))

        if body.name is not None:
            user.name = body.name
        if body.email is not None:
            user.email = body.email
        if body.is_active is not None:
            user.is_active = body.is_active
        if body.grade is not None:
            student = db.query(Student).filter(Student.user_id == user.id).first()
            if student:
                student.grade = body.grade

        db.commit()
        return format_response(True, {"id": str(user.id), "name": user.name}, "تم تعديل المستخدم")
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=format_response(False, None, str(e)))


@router.delete("/users/{user_id}")
async def delete_user(
    user_id: UUID,
    admin: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Soft delete a user (set is_active = False)."""
    try:
        user = db.query(User).filter(User.id == user_id).first()
        if not user:
            raise HTTPException(status_code=404, detail=format_response(False, None, "المستخدم غير موجود"))

        user.is_active = False
        db.commit()
        return format_response(True, None, "تم حذف المستخدم")
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


# ─── Lessons CRUD ───────────────────────────────────────────────
@router.get("/lessons")
async def list_lessons(
    page: int = Query(1, ge=1),
    per_page: int = Query(20, ge=1, le=100),
    admin: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """List all lessons with pagination."""
    try:
        query = db.query(Lesson).order_by(Lesson.created_at.desc())
        items, total = paginate(query, page, per_page)
        lessons_list = []
        for l in items:
            lessons_list.append({
                "id": str(l.id),
                "title": l.title,
                "subject": l.subject,
                "grade_level": l.grade_level,
                "qr_code": l.qr_code,
                "audio_url": l.audio_url,
                "created_at": str(l.created_at),
            })
        return format_response(True, {"lessons": lessons_list, "total": total, "page": page}, "قائمة الدروس")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.post("/lessons")
async def create_lesson(
    body: LessonCreate,
    admin: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Create a new lesson."""
    try:
        lesson = Lesson(
            title=body.title,
            subject=body.subject,
            grade_level=body.grade_level,
            original_text=body.original_text,
            qr_code=body.qr_code,
        )
        db.add(lesson)
        db.commit()
        db.refresh(lesson)
        return format_response(True, {"id": str(lesson.id), "title": lesson.title}, "تم إنشاء الدرس")
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=format_response(False, None, str(e)))


@router.put("/lessons/{lesson_id}")
async def update_lesson(
    lesson_id: UUID,
    body: LessonUpdate,
    admin: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Update a lesson."""
    try:
        lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
        if not lesson:
            raise HTTPException(status_code=404, detail=format_response(False, None, "الدرس غير موجود"))

        if body.title is not None:
            lesson.title = body.title
        if body.subject is not None:
            lesson.subject = body.subject
        if body.grade_level is not None:
            lesson.grade_level = body.grade_level
        if body.original_text is not None:
            lesson.original_text = body.original_text

        db.commit()
        return format_response(True, {"id": str(lesson.id), "title": lesson.title}, "تم تعديل الدرس")
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=format_response(False, None, str(e)))


@router.delete("/lessons/{lesson_id}")
async def delete_lesson(
    lesson_id: UUID,
    admin: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Delete a lesson."""
    try:
        lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
        if not lesson:
            raise HTTPException(status_code=404, detail=format_response(False, None, "الدرس غير موجود"))

        db.delete(lesson)
        db.commit()
        return format_response(True, None, "تم حذف الدرس")
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


# ─── System Logs ────────────────────────────────────────────────
@router.get("/logs")
async def get_logs(
    action: Optional[str] = None,
    user_id: Optional[UUID] = None,
    page: int = Query(1, ge=1),
    per_page: int = Query(20, ge=1, le=100),
    admin: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    """Get system logs with optional filtering."""
    try:
        query = db.query(SystemLog).order_by(SystemLog.created_at.desc())

        if action:
            query = query.filter(SystemLog.action.ilike(f"%{action}%"))
        if user_id:
            query = query.filter(SystemLog.user_id == user_id)

        items, total = paginate(query, page, per_page)
        logs_list = []
        for log in items:
            logs_list.append({
                "id": str(log.id),
                "user_id": str(log.user_id) if log.user_id else None,
                "action": log.action,
                "status": log.status,
                "details": log.details,
                "created_at": str(log.created_at),
            })
        return format_response(True, {"logs": logs_list, "total": total, "page": page}, "سجلات النظام")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


# ─── System Settings ───────────────────────────────────────────
@router.get("/settings")
async def get_settings(admin: User = Depends(require_admin)):
    """Get current system settings."""
    current = _load_settings()
    return format_response(True, current.model_dump(), "إعدادات النظام")


@router.put("/settings")
async def update_settings(
    body: SystemSettings,
    admin: User = Depends(require_admin),
):
    """Update system settings."""
    _save_settings(body)
    return format_response(True, body.model_dump(), "تم تعديل الإعدادات")
