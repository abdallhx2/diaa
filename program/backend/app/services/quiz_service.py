import random
from uuid import UUID
from sqlalchemy.orm import Session
from app.models.quiz import Quiz
from app.models.quiz_result import QuizResult


def get_quizzes_by_lesson(db: Session, lesson_id: UUID) -> list:
    """Get all quizzes for a lesson. Does NOT include correct_answer."""
    try:
        quizzes = db.query(Quiz).filter(Quiz.lesson_id == lesson_id).all()
        result = []
        for q in quizzes:
            result.append({
                "id": str(q.id),
                "lesson_id": str(q.lesson_id),
                "quiz_type": q.quiz_type.value if hasattr(q.quiz_type, "value") else q.quiz_type,
                "question_text": q.question_text,
                "options": q.options,
                "created_at": str(q.created_at) if q.created_at else None,
            })
        return result
    except Exception as e:
        raise Exception(f"خطأ في جلب الاختبارات: {str(e)}")


def get_quizzes_by_type(db: Session, quiz_type: str) -> list:
    """Get all quizzes of a given type. Does NOT include correct_answer."""
    try:
        quizzes = db.query(Quiz).filter(Quiz.quiz_type == quiz_type).all()
        result = []
        for q in quizzes:
            result.append({
                "id": str(q.id),
                "lesson_id": str(q.lesson_id),
                "quiz_type": q.quiz_type.value if hasattr(q.quiz_type, "value") else q.quiz_type,
                "question_text": q.question_text,
                "options": q.options,
                "created_at": str(q.created_at) if q.created_at else None,
            })
        return result
    except Exception as e:
        raise Exception(f"خطأ في جلب الاختبارات حسب النوع: {str(e)}")


def submit_answer(db: Session, student_id: UUID, quiz_id: UUID, selected_answer: str) -> dict:
    """Submit an answer for a single quiz question, save result, return result dict."""
    try:
        quiz = db.query(Quiz).filter(Quiz.id == quiz_id).first()
        if not quiz:
            raise Exception("الاختبار غير موجود")

        sel = (selected_answer or "").strip()
        stored = (quiz.correct_answer or "").strip()
        # Resolve correct_answer to its value if it is a key into options dict.
        if isinstance(quiz.options, dict) and stored in quiz.options:
            correct_value = str(quiz.options[stored]).strip()
        else:
            correct_value = stored
        is_correct = sel == correct_value or sel == stored

        result = QuizResult(
            student_id=student_id,
            quiz_id=quiz_id,
            selected_answer=selected_answer,
            is_correct=is_correct,
        )
        db.add(result)
        db.commit()
        db.refresh(result)

        return {
            "id": str(result.id),
            "quiz_id": str(result.quiz_id),
            "selected_answer": result.selected_answer,
            "is_correct": result.is_correct,
            "correct_answer": quiz.correct_answer,
            "answered_at": str(result.answered_at),
        }
    except Exception as e:
        db.rollback()
        raise Exception(f"خطأ في تسليم الإجابة: {str(e)}")


def get_student_results(db: Session, student_id: UUID) -> list:
    """Get all quiz results for a student, ordered by most recent first."""
    try:
        results = (
            db.query(QuizResult)
            .filter(QuizResult.student_id == student_id)
            .order_by(QuizResult.answered_at.desc())
            .all()
        )
        output = []
        for r in results:
            output.append({
                "id": str(r.id),
                "quiz_id": str(r.quiz_id),
                "selected_answer": r.selected_answer,
                "is_correct": r.is_correct,
                "answered_at": str(r.answered_at),
            })
        return output
    except Exception as e:
        raise Exception(f"خطأ في جلب نتائج الطالب: {str(e)}")


def get_random_questions(db: Session, lesson_id: UUID, count: int = 5) -> list:
    """Get random quiz questions for a lesson with shuffled options.
    Uses random.sample to pick up to `count` questions, then shuffles each question's options.
    """
    try:
        quizzes = db.query(Quiz).filter(Quiz.lesson_id == lesson_id).all()

        if not quizzes:
            return []

        # Pick random subset (or all if fewer than count)
        selected = random.sample(quizzes, min(count, len(quizzes)))

        result = []
        for q in selected:
            # Shuffle options for each question (handle dict {key:value} or list)
            if isinstance(q.options, dict):
                options = list(q.options.values())
            elif q.options:
                options = list(q.options)
            else:
                options = []
            random.shuffle(options)

            result.append({
                "id": str(q.id),
                "lesson_id": str(q.lesson_id),
                "quiz_type": q.quiz_type.value if hasattr(q.quiz_type, "value") else q.quiz_type,
                "question_text": q.question_text,
                "options": options,
                "created_at": str(q.created_at) if q.created_at else None,
            })
        return result
    except Exception as e:
        raise Exception(f"خطأ في جلب أسئلة عشوائية: {str(e)}")


def get_quiz_feedback(score: float) -> str:
    """Return Arabic motivational feedback based on quiz score percentage."""
    if score >= 80:
        return "ممتاز! أحسنتِ في الإجابة"
    elif score >= 60:
        return "جيد! يمكنكِ التحسين أكثر"
    else:
        return "لا بأس! حاولي مرة أخرى"
