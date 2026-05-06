from datetime import datetime, timedelta, timezone
from decimal import Decimal
from uuid import UUID
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import func
from app.models.learning_session import LearningSession
from app.models.quiz_result import QuizResult
from app.models.student import Student


def recalculate_student_progress(db: Session, student_id: UUID) -> float:
    """Recalculate student progress_score from quiz_results and update DB.

    Formula: (correct answers / total answers) * 100
    Returns the new progress percentage.
    """
    try:
        total = db.query(QuizResult).filter(QuizResult.student_id == student_id).count()
        if total == 0:
            return 0.0

        correct = db.query(QuizResult).filter(
            QuizResult.student_id == student_id,
            QuizResult.is_correct == True,
        ).count()

        progress = round(correct / total * 100, 2)

        student = db.query(Student).filter(Student.id == student_id).first()
        if student:
            student.progress_score = Decimal(str(progress))
            db.commit()
            db.refresh(student)

        return progress
    except Exception as e:
        db.rollback()
        raise Exception(f"خطأ في إعادة حساب التقدم: {str(e)}")


def _calculate_daily_streak(db: Session, student_id: UUID) -> int:
    """Calculate the number of consecutive days a student has studied."""
    try:
        sessions = (
            db.query(func.date(LearningSession.started_at))
            .filter(LearningSession.student_id == student_id)
            .distinct()
            .order_by(func.date(LearningSession.started_at).desc())
            .all()
        )
        if not sessions:
            return 0

        dates = sorted([s[0] for s in sessions], reverse=True)
        streak = 1
        for i in range(1, len(dates)):
            diff = (dates[i - 1] - dates[i]).days
            if diff == 1:
                streak += 1
            else:
                break
        return streak
    except Exception:
        return 0


def _get_recent_activities(db: Session, student_id: UUID, since: datetime, limit: int = 10) -> list:
    """Get recent activities (sessions and quiz results) for a student."""
    activities = []
    try:
        sessions = (
            db.query(LearningSession)
            .options(joinedload(LearningSession.lesson))
            .filter(
                LearningSession.student_id == student_id,
                LearningSession.started_at >= since,
            )
            .order_by(LearningSession.started_at.desc())
            .limit(limit)
            .all()
        )
        for s in sessions:
            activities.append({
                "type": "lesson",
                "title": s.lesson.title if s.lesson else "درس",
                "date": str(s.started_at.date()) if s.started_at else "",
            })

        results = (
            db.query(QuizResult)
            .filter(
                QuizResult.student_id == student_id,
                QuizResult.answered_at >= since,
            )
            .order_by(QuizResult.answered_at.desc())
            .limit(limit)
            .all()
        )
        for r in results:
            activities.append({
                "type": "quiz",
                "title": "اختبار",
                "date": str(r.answered_at.date()) if r.answered_at else "",
                "is_correct": r.is_correct,
            })

        activities.sort(key=lambda x: x.get("date", ""), reverse=True)
        return activities[:limit]
    except Exception:
        return []


def get_weekly_report(db: Session, child_id: UUID) -> dict:
    """Generate a weekly report for a student."""
    try:
        week_start = datetime.now(timezone.utc) - timedelta(days=7)

        sessions = (
            db.query(LearningSession)
            .filter(
                LearningSession.student_id == child_id,
                LearningSession.started_at >= week_start,
            )
            .all()
        )

        quiz_results = (
            db.query(QuizResult)
            .filter(
                QuizResult.student_id == child_id,
                QuizResult.answered_at >= week_start,
            )
            .all()
        )

        lessons_completed = sum(1 for s in sessions if s.ended_at is not None)
        quizzes_taken = len(quiz_results)
        total_minutes = sum(s.duration_minutes or 0 for s in sessions)
        study_time_hours = Decimal(str(round(total_minutes / 60, 2)))

        correct_count = sum(1 for r in quiz_results if r.is_correct)
        avg_quiz_score = Decimal(str(round((correct_count / quizzes_taken * 100) if quizzes_taken > 0 else 0, 2)))

        student = db.query(Student).filter(Student.id == child_id).first()
        progress_percentage = Decimal(str(student.progress_score or 0)) if student else Decimal("0")

        daily_streak = _calculate_daily_streak(db, child_id)
        recent_activities = _get_recent_activities(db, child_id, week_start)

        return {
            "lessons_completed": lessons_completed,
            "quizzes_taken": quizzes_taken,
            "total_quizzes": quizzes_taken,
            "correct_answers": correct_count,
            "total_study_minutes": total_minutes,
            "study_time_hours": study_time_hours,
            "progress_percentage": progress_percentage,
            "avg_quiz_score": avg_quiz_score,
            "daily_streak": daily_streak,
            "recent_activities": recent_activities,
        }
    except Exception as e:
        raise Exception(f"خطأ في إنشاء التقرير الأسبوعي: {str(e)}")


def get_monthly_report(db: Session, child_id: UUID) -> dict:
    """Generate a monthly report for a student, including trends."""
    try:
        month_start = datetime.now(timezone.utc) - timedelta(days=30)

        sessions = (
            db.query(LearningSession)
            .filter(
                LearningSession.student_id == child_id,
                LearningSession.started_at >= month_start,
            )
            .all()
        )

        quiz_results = (
            db.query(QuizResult)
            .filter(
                QuizResult.student_id == child_id,
                QuizResult.answered_at >= month_start,
            )
            .all()
        )

        lessons_completed = sum(1 for s in sessions if s.ended_at is not None)
        quizzes_taken = len(quiz_results)
        total_minutes = sum(s.duration_minutes or 0 for s in sessions)
        study_time_hours = Decimal(str(round(total_minutes / 60, 2)))

        correct_count = sum(1 for r in quiz_results if r.is_correct)
        avg_quiz_score = Decimal(str(round((correct_count / quizzes_taken * 100) if quizzes_taken > 0 else 0, 2)))

        student = db.query(Student).filter(Student.id == child_id).first()
        progress_percentage = Decimal(str(student.progress_score or 0)) if student else Decimal("0")

        daily_streak = _calculate_daily_streak(db, child_id)
        recent_activities = _get_recent_activities(db, child_id, month_start)

        # Calculate weekly trends
        weekly_scores = []
        now = datetime.now(timezone.utc)
        for week_num in range(4):
            w_end = now - timedelta(days=7 * week_num)
            w_start = w_end - timedelta(days=7)
            week_results = [
                r for r in quiz_results
                if r.answered_at and w_start <= r.answered_at.replace(tzinfo=timezone.utc) <= w_end
            ]
            if week_results:
                week_correct = sum(1 for r in week_results if r.is_correct)
                week_score = round(week_correct / len(week_results) * 100, 2)
            else:
                week_score = 0
            weekly_scores.insert(0, week_score)

        if len(weekly_scores) >= 2 and weekly_scores[-1] > weekly_scores[0]:
            score_trend = "improving"
        elif len(weekly_scores) >= 2 and weekly_scores[-1] < weekly_scores[0]:
            score_trend = "declining"
        else:
            score_trend = "stable"

        trends = {
            "score_trend": score_trend,
            "study_time_trend": "stable",
            "weekly_scores": weekly_scores,
        }

        return {
            "lessons_completed": lessons_completed,
            "quizzes_taken": quizzes_taken,
            "total_quizzes": quizzes_taken,
            "correct_answers": correct_count,
            "total_study_minutes": total_minutes,
            "study_time_hours": study_time_hours,
            "progress_percentage": progress_percentage,
            "avg_quiz_score": avg_quiz_score,
            "daily_streak": daily_streak,
            "recent_activities": recent_activities,
            "trends": trends,
        }
    except Exception as e:
        raise Exception(f"خطأ في إنشاء التقرير الشهري: {str(e)}")
