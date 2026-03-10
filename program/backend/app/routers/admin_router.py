from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.orm import Session
from typing import Optional
from datetime import datetime, timedelta
from app.database import get_db
from app.models.user import User
from app.models.lesson import Lesson
from app.models.system_log import SystemLog
from app.models.learning_session import LearningSession
from app.schemas.admin_schema import AdminDashboard, SystemSettings
from app.schemas.auth_schema import UserResponse
from app.schemas.lesson_schema import LessonCreate, LessonResponse, LessonUpdate
from app.utils.helpers import format_response

router = APIRouter()


def require_admin(request: Request):
    user = request.state.user
    if user.role != "admin":
        raise HTTPException(
            status_code=403,
            detail=format_response(False, None, "غير مصرح — هذه الصفحة للمشرفين فقط")
        )
    return user


# ─── Dashboard ────────────────────────────────────────────────────────────────

# GET /api/admin/dashboard
@router.get("/dashboard")
async def get_dashboard(
    request: Request,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin)
):
    now = datetime.utcnow()
    seven_days_ago = now - timedelta(days=7)
    thirty_days_ago = now - timedelta(days=30)

    total_users = db.query(User).count()

    active_users_7d = (
        db.query(User)
        .filter(User.last_active >= seven_days_ago)
        .count()
    )

    total_sessions_week = (
        db.query(LearningSession)
        .filter(LearningSession.created_at >= seven_days_ago)
        .count()
    )

    total_sessions_month = (
        db.query(LearningSession)
        .filter(LearningSession.created_at >= thirty_days_ago)
        .count()
    )

    logs = db.query(SystemLog).filter(SystemLog.response_time.isnot(None)).all()
    avg_response_time = (
        round(sum(log.response_time for log in logs) / len(logs), 2)
        if logs else 0.0
    )

    dashboard_data = AdminDashboard(
        total_users=total_users,
        active_users_7d=active_users_7d,
        total_sessions_week=total_sessions_week,
        total_sessions_month=total_sessions_month,
        avg_response_time=avg_response_time
    )

    return format_response(True, dashboard_data, "إحصائيات النظام")


# ─── Users CRUD ───────────────────────────────────────────────────────────────

# GET /api/admin/users
@router.get("/users")
async def get_users(
    request: Request,
    db: Session = Depends(get_db),
    page: int = 1,
    per_page: int = 20,
    _: User = Depends(require_admin)
):
    offset = (page - 1) * per_page
    total = db.query(User).filter(User.is_active == True).count()
    users = (
        db.query(User)
        .filter(User.is_active == True)
        .offset(offset)
        .limit(per_page)
        .all()
    )

    return format_response(True, {
        "users": [UserResponse.from_orm(u) for u in users],
        "total": total,
        "page": page,
        "per_page": per_page
    }, "قائمة المستخدمين")


# GET /api/admin/users/{user_id}
@router.get("/users/{user_id}")
async def get_user(
    user_id: int,
    request: Request,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin)
):
    user = db.query(User).filter(User.id == user_id, User.is_active == True).first()
    if not user:
        raise HTTPException(
            status_code=404,
            detail=format_response(False, None, "المستخدم غير موجود")
        )

    return format_response(True, UserResponse.from_orm(user), "بيانات المستخدم")


# POST /api/admin/users
@router.post("/users")
async def create_user(
    request: Request,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin)
):
    body = await request.json()
    name = body.get("name")
    email = body.get("email")
    role = body.get("role")
    firebase_uid = body.get("firebase_uid")

    if not all([name, email, role, firebase_uid]):
        raise HTTPException(
            status_code=400,
            detail=format_response(False, None, "name, email, role, firebase_uid مطلوبة")
        )
    existing = db.query(User).filter(User.email == email).first()
    if existing:
        raise HTTPException(
            status_code=400,
            detail=format_response(False, None, "البريد الإلكتروني مستخدم مسبقاً")
        )

    new_user = User(
        name=name,
        email=email,
        role=role,
        firebase_uid=firebase_uid,
        is_active=True
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return format_response(True, UserResponse.from_orm(new_user), "تم إنشاء المستخدم بنجاح")


# PUT /api/admin/users/{user_id}
@router.put("/users/{user_id}")
async def update_user(
    user_id: int,
    request: Request,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin)
):
    user = db.query(User).filter(User.id == user_id, User.is_active == True).first()
    if not user:
        raise HTTPException(
            status_code=404,
            detail=format_response(False, None, "المستخدم غير موجود")
        )

    body = await request.json()
    if "name" in body:
        user.name = body["name"]
    if "email" in body:
        user.email = body["email"]
    if "role" in body:
        user.role = body["role"]

    db.commit()
    db.refresh(user)

    return format_response(True, UserResponse.from_orm(user), "تم تعديل المستخدم بنجاح")


# DELETE /api/admin/users/{user_id}
@router.delete("/users/{user_id}")
async def delete_user(
    user_id: int,
    request: Request,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin)
):
    user = db.query(User).filter(User.id == user_id, User.is_active == True).first()
    if not user:
        raise HTTPException(
            status_code=404,
            detail=format_response(False, None, "المستخدم غير موجود")
        )

    user.is_active = False
    db.commit()

    return format_response(True, None, "تم حذف المستخدم بنجاح")


# ─── Lessons CRUD ─────────────────────────────────────────────────────────────

# GET /api/admin/lessons
@router.get("/lessons")
async def get_lessons(
    request: Request,
    db: Session = Depends(get_db),
    page: int = 1,
    per_page: int = 20,
    _: User = Depends(require_admin)
):
    offset = (page - 1) * per_page
    total = db.query(Lesson).filter(Lesson.is_active == True).count()
    lessons = (
        db.query(Lesson)
        .filter(Lesson.is_active == True)
        .offset(offset)
        .limit(per_page)
        .all()
    )

    return format_response(True, {
        "lessons": [LessonResponse.from_orm(l) for l in lessons],
        "total": total,
        "page": page,
        "per_page": per_page
    }, "قائمة الدروس")


# POST /api/admin/lessons
@router.post("/lessons")
async def create_lesson(
    body: LessonCreate,
    request: Request,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin)
):
    new_lesson = Lesson(**body.dict(), is_active=True)
    db.add(new_lesson)
    db.commit()
    db.refresh(new_lesson)

    return format_response(True, LessonResponse.from_orm(new_lesson), "تم إنشاء الدرس بنجاح")


# PUT /api/admin/lessons/{lesson_id}
@router.put("/lessons/{lesson_id}")
async def update_lesson(
    lesson_id: int,
    body: LessonUpdate,
    request: Request,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin)
):
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id, Lesson.is_active == True).first()
    if not lesson:
        raise HTTPException(
            status_code=404,
            detail=format_response(False, None, "الدرس غير موجود")
        )

    for field, value in body.dict(exclude_unset=True).items():
        setattr(lesson, field, value)

    db.commit()
    db.refresh(lesson)

    return format_response(True, LessonResponse.from_orm(lesson), "تم تعديل الدرس بنجاح")


# DELETE /api/admin/lessons/{lesson_id}
@router.delete("/lessons/{lesson_id}")
async def delete_lesson(
    lesson_id: int,
    request: Request,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin)
):
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id, Lesson.is_active == True).first()
    if not lesson:
        raise HTTPException(
            status_code=404,
            detail=format_response(False, None, "الدرس غير موجود")
        )

    lesson.is_active = False
    db.commit()

    return format_response(True, None, "تم حذف الدرس بنجاح")


# ─── Logs ─────────────────────────────────────────────────────────────────────

# GET /api/admin/logs
@router.get("/logs")
async def get_logs(
    request: Request,
    db: Session = Depends(get_db),
    action: Optional[str] = None,
    user_id: Optional[int] = None,
    date_from: Optional[datetime] = None,
    date_to: Optional[datetime] = None,
    page: int = 1,
    per_page: int = 20,
    _: User = Depends(require_admin)
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

    total = query.count()
    offset = (page - 1) * per_page
    logs = query.order_by(SystemLog.created_at.desc()).offset(offset).limit(per_page).all()

    logs_list = [
        {
            "id": log.id,
            "user_id": log.user_id,
            "action": log.action,
            "response_time": log.response_time,
            "created_at": str(log.created_at)
        }
        for log in logs
    ]

    return format_response(True, {
        "logs": logs_list,
        "total": total,
        "page": page,
        "per_page": per_page
    }, "سجلات النظام")


# ─── Settings ─────────────────────────────────────────────────────────────────

# GET /api/admin/settings
@router.get("/settings")
async def get_settings(
    request: Request,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin)
):
    from app.models.system_setting import SystemSetting
    settings = db.query(SystemSetting).first()
    if not settings:
        raise HTTPException(
            status_code=404,
            detail=format_response(False, None, "الإعدادات غير موجودة")
        )

    return format_response(True, SystemSettings.from_orm(settings), "إعدادات النظام")


# PUT /api/admin/settings
@router.put("/settings")
async def update_settings(
    body: SystemSettings,
    request: Request,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin)
):
    from app.models.system_setting import SystemSetting
    settings = db.query(SystemSetting).first()
    if not settings:
        raise HTTPException(
            status_code=404,
            detail=format_response(False, None, "الإعدادات غير موجودة")
        )

    for field, value in body.dict(exclude_unset=True).items():
        setattr(settings, field, value)

    db.commit()
    db.refresh(settings)

    return format_response(True, SystemSettings.from_orm(settings), "تم تعديل الإعدادات بنجاح")