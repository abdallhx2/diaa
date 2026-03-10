from fastapi import APIRouter, Depends, Request, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.student import Student
from app.models.learning_session import LearningSession
from app.models.quiz_result import QuizResult
from app.schemas.student_schema import StudentDashboard
from app.utils.helpers import format_response

router = APIRouter()


def require_student(request: Request):
    user = request.state.user
    if user.role != "student":
        raise HTTPException(
            status_code=403,
            detail=format_response(False, None, "غير مصرح — هذه الصفحة للطلاب فقط")
        )
    return user


@router.get("/dashboard")
async def get_dashboard(request: Request, db: Session = Depends(get_db)):
    user = require_student(request)

    student = db.query(Student).filter(Student.user_id == user.id).first()
    if not student:
        raise HTTPException(
            status_code=404,
            detail=format_response(False, None, "بيانات الطالب غير موجودة")
        )

    recent_sessions = (
        db.query(LearningSession)
        .filter(LearningSession.student_id == student.id)
        .order_by(LearningSession.created_at.desc())
        .limit(5)
        .all()
    )

    recent_quizzes = (
        db.query(QuizResult)
        .filter(QuizResult.student_id == student.id)
        .order_by(QuizResult.created_at.desc())
        .limit(5)
        .all()
    )

    total_quizzes = db.query(QuizResult).filter(QuizResult.student_id == student.id).count()
    passed_quizzes = db.query(QuizResult).filter(
        QuizResult.student_id == student.id,
        QuizResult.score >= 50
    ).count()
    progress_score = round((passed_quizzes / total_quizzes) * 100, 2) if total_quizzes > 0 else 0.0

    dashboard_data = StudentDashboard(
        id=user.id,
        name=user.name,
        email=user.email,
        role=user.role,
        grade=student.grade,
        learning_level=student.learning_level,
        progress_score=progress_score,
        recent_sessions=[
            {
                "id": s.id,
                "topic": s.topic,
                "duration_minutes": s.duration_minutes,
                "created_at": str(s.created_at)
            }
            for s in recent_sessions
        ],
        recent_quizzes=[
            {
                "id": q.id,
                "quiz_title": q.quiz_title,
                "score": q.score,
                "created_at": str(q.created_at)
            }
            for q in recent_quizzes
        ]
    )

    return format_response(True, dashboard_data, "لوحة تحكم الطالب")


@router.get("/sessions")
async def get_sessions(request: Request, db: Session = Depends(get_db)):
    user = require_student(request)

    student = db.query(Student).filter(Student.user_id == user.id).first()
    if not student:
        raise HTTPException(
            status_code=404,
            detail=format_response(False, None, "بيانات الطالب غير موجودة")
        )

    sessions = (
        db.query(LearningSession)
        .filter(LearningSession.student_id == student.id)
        .order_by(LearningSession.created_at.desc())
        .all()
    )

    sessions_list = [
        {
            "id": s.id,
            "topic": s.topic,
            "duration_minutes": s.duration_minutes,
            "status": s.status,
            "created_at": str(s.created_at)
        }
        for s in sessions
    ]

    return format_response(True, sessions_list, "جلسات التعلم")


@router.get("/progress")
async def get_progress(request: Request, db: Session = Depends(get_db)):
    user = require_student(request)

    student = db.query(Student).filter(Student.user_id == user.id).first()
    if not student:
        raise HTTPException(
            status_code=404,
            detail=format_response(False, None, "بيانات الطالب غير موجودة")
        )

    total_quizzes = db.query(QuizResult).filter(QuizResult.student_id == student.id).count()
    passed_quizzes = db.query(QuizResult).filter(
        QuizResult.student_id == student.id,
        QuizResult.score >= 50
    ).count()

    total_sessions = db.query(LearningSession).filter(LearningSession.student_id == student.id).count()
    completed_sessions = db.query(LearningSession).filter(
        LearningSession.student_id == student.id,
        LearningSession.status == "completed"
    ).count()

    quiz_score = round((passed_quizzes / total_quizzes) * 100, 2) if total_quizzes > 0 else 0.0
    session_score = round((completed_sessions / total_sessions) * 100, 2) if total_sessions > 0 else 0.0
    overall_progress = round((quiz_score + session_score) / 2, 2)

    progress_data = {
        "progress_percentage": overall_progress,
        "quiz_progress": {
            "total": total_quizzes,
            "passed": passed_quizzes,
            "score_percentage": quiz_score
        },
        "session_progress": {
            "total": total_sessions,
            "completed": completed_sessions,
            "score_percentage": session_score
        }
    }

    return format_response(True, progress_data, "نسبة التقدم")