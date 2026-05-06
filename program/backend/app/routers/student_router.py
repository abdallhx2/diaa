from uuid import UUID
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import func
from decimal import Decimal
from app.database import get_db
from app.models.user import User
from app.models.student import Student
from app.models.learning_session import LearningSession, SessionType
from app.models.quiz_result import QuizResult
from app.middleware.auth_middleware import get_current_user
from app.schemas.student_schema import SessionStartRequest, SessionResponse
from app.utils.helpers import format_response

router = APIRouter()


def _require_student(current_user: User) -> Student:
    """Ensure current user is a student and return the Student record."""
    if current_user.role.value != "student":
        raise HTTPException(status_code=403, detail=format_response(False, None, "الوصول مقصور على الطلاب"))
    if not current_user.student:
        raise HTTPException(status_code=404, detail=format_response(False, None, "سجل الطالب غير موجود"))
    return current_user.student


@router.get("/dashboard")
async def get_dashboard(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get student dashboard with recent sessions, quizzes, and progress."""
    student = _require_student(current_user)
    try:
        recent_sessions = (
            db.query(LearningSession)
            .options(joinedload(LearningSession.lesson))
            .filter(LearningSession.student_id == student.id)
            .order_by(LearningSession.started_at.desc())
            .limit(5)
            .all()
        )
        sessions_list = []
        for s in recent_sessions:
            sessions_list.append({
                "lesson_title": s.lesson.title if s.lesson else "",
                "session_type": s.session_type.value if hasattr(s.session_type, "value") else s.session_type,
                "started_at": str(s.started_at),
                "duration_minutes": s.duration_minutes,
            })

        recent_quizzes = (
            db.query(QuizResult)
            .filter(QuizResult.student_id == student.id)
            .order_by(QuizResult.answered_at.desc())
            .limit(5)
            .all()
        )
        quizzes_list = []
        for q in recent_quizzes:
            quizzes_list.append({
                "quiz_id": str(q.quiz_id),
                "is_correct": q.is_correct,
                "answered_at": str(q.answered_at),
            })

        # Aggregate stats: completed lessons, quiz score average, total study time
        completed_lessons = (
            db.query(func.count(LearningSession.id))
            .filter(
                LearningSession.student_id == student.id,
                LearningSession.ended_at.isnot(None),
            )
            .scalar()
        ) or 0

        total_quiz = db.query(QuizResult).filter(QuizResult.student_id == student.id).count()
        correct_quiz = db.query(QuizResult).filter(
            QuizResult.student_id == student.id,
            QuizResult.is_correct == True,
        ).count()
        quiz_score_average = round((correct_quiz / total_quiz * 100) if total_quiz > 0 else 0, 2)

        study_time_minutes = (
            db.query(func.coalesce(func.sum(LearningSession.duration_minutes), 0))
            .filter(LearningSession.student_id == student.id)
            .scalar()
        )

        dashboard = {
            "student_info": {
                "id": str(student.id),
                "name": current_user.name,
                "age": student.age,
                "grade": student.grade,
                "learning_level": student.learning_level,
                "progress_score": float(student.progress_score or 0),
            },
            "completed_lessons": completed_lessons,
            "quiz_score_average": quiz_score_average,
            "study_time_minutes": int(study_time_minutes),
            "recent_sessions": sessions_list,
            "recent_quizzes": quizzes_list,
            "progress_score": float(student.progress_score or 0),
        }
        return format_response(True, dashboard, "لوحة تحكم الطالب")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.get("/sessions")
async def get_sessions(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get all learning sessions for the current student."""
    student = _require_student(current_user)
    try:
        sessions = (
            db.query(LearningSession)
            .options(joinedload(LearningSession.lesson))
            .filter(LearningSession.student_id == student.id)
            .order_by(LearningSession.started_at.desc())
            .all()
        )
        sessions_list = []
        for s in sessions:
            sessions_list.append({
                "id": str(s.id),
                "lesson_title": s.lesson.title if s.lesson else "",
                "session_type": s.session_type.value if hasattr(s.session_type, "value") else s.session_type,
                "started_at": str(s.started_at),
                "ended_at": str(s.ended_at) if s.ended_at else None,
                "duration_minutes": s.duration_minutes,
            })
        return format_response(True, sessions_list, "جلسات التعلم")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.get("/progress")
async def get_progress(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get progress percentage for the current student."""
    student = _require_student(current_user)
    try:
        total_results = db.query(QuizResult).filter(QuizResult.student_id == student.id).count()
        correct_results = db.query(QuizResult).filter(
            QuizResult.student_id == student.id,
            QuizResult.is_correct == True,
        ).count()

        progress = round((correct_results / total_results * 100) if total_results > 0 else 0, 2)

        return format_response(True, {"progress_percentage": progress}, "نسبة التقدم")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.post("/sessions/start", response_model=None)
async def start_session(
    body: SessionStartRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Start a new learning session."""
    student = _require_student(current_user)
    try:
        # Validate session_type
        try:
            session_type = SessionType(body.session_type)
        except ValueError:
            raise HTTPException(
                status_code=400,
                detail=format_response(False, None, "نوع الجلسة غير صالح. الأنواع المتاحة: scan, qr, upload"),
            )

        session = LearningSession(
            student_id=student.id,
            lesson_id=body.lesson_id,
            session_type=session_type,
            started_at=datetime.now(timezone.utc),
        )
        db.add(session)
        db.commit()
        db.refresh(session)

        return format_response(True, {
            "id": str(session.id),
            "student_id": str(session.student_id),
            "lesson_id": str(session.lesson_id),
            "session_type": session.session_type.value,
            "started_at": str(session.started_at),
        }, "تم بدء الجلسة بنجاح")
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.post("/sessions/{session_id}/end", response_model=None)
async def end_session(
    session_id: UUID,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """End an active learning session and calculate duration."""
    student = _require_student(current_user)
    try:
        session = (
            db.query(LearningSession)
            .filter(
                LearningSession.id == session_id,
                LearningSession.student_id == student.id,
            )
            .first()
        )
        if not session:
            raise HTTPException(
                status_code=404,
                detail=format_response(False, None, "الجلسة غير موجودة"),
            )
        if session.ended_at is not None:
            raise HTTPException(
                status_code=400,
                detail=format_response(False, None, "الجلسة منتهية بالفعل"),
            )

        now = datetime.now(timezone.utc)
        started = session.started_at.replace(tzinfo=timezone.utc) if session.started_at.tzinfo is None else session.started_at
        duration = int((now - started).total_seconds() / 60)

        session.ended_at = now
        session.duration_minutes = duration
        db.commit()
        db.refresh(session)

        return format_response(True, {
            "id": str(session.id),
            "student_id": str(session.student_id),
            "lesson_id": str(session.lesson_id),
            "session_type": session.session_type.value if hasattr(session.session_type, "value") else session.session_type,
            "started_at": str(session.started_at),
            "ended_at": str(session.ended_at),
            "duration_minutes": session.duration_minutes,
        }, "تم إنهاء الجلسة بنجاح")
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))
