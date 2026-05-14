from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.user import User
from app.models.lesson import Lesson
from app.middleware.auth_middleware import get_current_user
from app.utils.helpers import format_response

router = APIRouter()


@router.get("/subjects")
async def get_subjects(
    grade: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    rows = db.query(Lesson.subject).filter(Lesson.grade_level == grade).distinct().all()
    subjects = [s[0] for s in rows if s[0]]
    return format_response(True, {"subjects": subjects}, "تم جلب المواد بنجاح")


@router.get("", include_in_schema=True)
async def list_lessons(
    grade: str,
    subject: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    rows = (
        db.query(Lesson)
        .filter(Lesson.grade_level == grade, Lesson.subject == subject)
        .all()
    )
    lessons = [
        {"id": str(r.id), "title": r.title, "subject": r.subject, "grade_level": r.grade_level}
        for r in rows
    ]
    return format_response(True, lessons, "تم جلب الدروس بنجاح")


@router.get("/{lesson_id}")
async def get_lesson(
    lesson_id: UUID,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
    if not lesson:
        raise HTTPException(status_code=404, detail=format_response(False, None, "الدرس غير موجود"))

    if lesson.summary is None and lesson.original_text:
        from app.services.chat_service import summarize
        lesson.summary = await summarize(lesson.original_text)
        db.commit()
        db.refresh(lesson)

    data = {
        "id": str(lesson.id),
        "title": lesson.title,
        "subject": lesson.subject,
        "grade_level": lesson.grade_level,
        "original_text": lesson.original_text,
        "summary": lesson.summary,
        "audio_url": lesson.audio_url,
    }
    return format_response(True, data, "تم جلب الدرس بنجاح")
