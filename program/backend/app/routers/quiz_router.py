from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.services.quiz_service import get_quizzes_by_lesson, get_quizzes_by_type, submit_answer, get_student_results, get_random_questions
from app.services.report_service import recalculate_student_progress
from app.schemas.quiz_schema import QuizSubmit
from app.models.user import User
from app.middleware.auth_middleware import get_current_user
from app.utils.helpers import format_response

router = APIRouter()


@router.get("/random/{lesson_id}")
async def get_random_quiz(
    lesson_id: UUID,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get 5 random quiz questions for a lesson (without correct_answer)."""
    try:
        questions = get_random_questions(db, lesson_id, count=5)
        return format_response(True, questions, "أسئلة عشوائية")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.get("/{lesson_id}")
async def get_lesson_quizzes(
    lesson_id: UUID,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get quizzes for a specific lesson (without correct answers)."""
    try:
        quizzes = get_quizzes_by_lesson(db, lesson_id)
        return format_response(True, quizzes, "اختبارات الدرس")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.get("/types/{quiz_type}")
async def get_quizzes_by_type_endpoint(
    quiz_type: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get quizzes by type (reading, writing, comprehension)."""
    if quiz_type not in ("reading", "writing", "comprehension"):
        raise HTTPException(
            status_code=400,
            detail=format_response(False, None, "نوع الاختبار غير صالح"),
        )
    try:
        quizzes = get_quizzes_by_type(db, quiz_type)
        return format_response(True, quizzes, f"اختبارات {quiz_type}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.post("/submit")
async def submit_quiz(
    body: QuizSubmit,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Submit an answer for a quiz question."""
    if current_user.role.value != "student" or not current_user.student:
        raise HTTPException(status_code=403, detail=format_response(False, None, "الوصول مقصور على الطلاب"))

    try:
        result = submit_answer(
            db,
            student_id=current_user.student.id,
            quiz_id=body.quiz_id,
            selected_answer=body.selected_answer,
        )
        # Recalculate student progress after each answer
        recalculate_student_progress(db, current_user.student.id)
        return format_response(True, result, "تم تسليم الإجابة")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.get("/results/{student_id}")
async def get_results(
    student_id: UUID,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get quiz results for a student."""
    try:
        results = get_student_results(db, student_id)
        return format_response(True, results, "نتائج الطالب")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))
