from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.user import User
from app.models.achievement import Achievement
from app.middleware.auth_middleware import get_current_user
from app.services.achievement_service import get_student_progress
from app.utils.helpers import format_response

router = APIRouter()


def _require_student(current_user: User):
    if current_user.role.value != "student" or not current_user.student:
        raise HTTPException(
            status_code=403,
            detail=format_response(False, None, "الوصول مقصور على الطلاب"),
        )
    return current_user.student


@router.get("/me")
async def my_progress(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get current student's achievements and streak progress."""
    student = _require_student(current_user)
    try:
        data = get_student_progress(db, student.id)
        return format_response(True, data, "تقدم الطالب")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.get("/catalog")
async def achievements_catalog(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get all 8 achievements in the catalog."""
    try:
        achievements = db.query(Achievement).all()
        data = [
            {
                "id": str(a.id),
                "code": a.code,
                "name_ar": a.name_ar,
                "description_ar": a.description_ar,
                "icon_emoji": a.icon_emoji,
                "threshold": a.threshold,
                "kind": a.kind,
            }
            for a in achievements
        ]
        return format_response(True, data, "قائمة الإنجازات")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))
