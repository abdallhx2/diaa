from datetime import date, datetime, timezone
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from app.models.achievement import Achievement
from app.models.student_achievement import StudentAchievement
from app.models.student_streak import StudentStreak
from app.models.learning_session import LearningSession
from app.models.quiz_result import QuizResult


def _notify_achievements(db: Session, student_id, unlocked: list):
    """Fire parent notifications for each newly unlocked achievement."""
    if not unlocked:
        return
    from app.services import notification_service
    for ach in unlocked:
        notification_service.notify_parent_of_child_event(
            db, student_id, "achievement_unlocked", {"name_ar": ach.name_ar}
        )


def _get_or_create_streak(db: Session, student_id) -> StudentStreak:
    streak = db.query(StudentStreak).filter(StudentStreak.student_id == student_id).first()
    if not streak:
        streak = StudentStreak(student_id=student_id, current_streak=0, longest_streak=0)
        db.add(streak)
        db.flush()
    return streak


def _unlock_if_new(db: Session, student_id, achievement: Achievement) -> Achievement | None:
    """Insert student_achievement row; return achievement if newly unlocked, None if already had it."""
    existing = (
        db.query(StudentAchievement)
        .filter(
            StudentAchievement.student_id == student_id,
            StudentAchievement.achievement_id == achievement.id,
        )
        .first()
    )
    if existing:
        return None
    sa = StudentAchievement(student_id=student_id, achievement_id=achievement.id)
    db.add(sa)
    try:
        db.flush()
    except IntegrityError:
        db.rollback()
        return None
    return achievement


def _check_streak_achievements(db: Session, student_id, current_streak: int) -> list:
    unlocked = []
    for threshold in (3, 7, 30):
        if current_streak >= threshold:
            code = f"streak_{threshold}"
            ach = db.query(Achievement).filter(Achievement.code == code).first()
            if ach:
                result = _unlock_if_new(db, student_id, ach)
                if result:
                    unlocked.append(result)
    return unlocked


def record_activity(db: Session, student_id) -> list:
    """Bump streak for today; evaluate streak achievements. Returns newly unlocked list."""
    streak = _get_or_create_streak(db, student_id)
    today = date.today()

    if streak.last_activity_date == today:
        # Already counted today
        db.commit()
        return []

    yesterday = date.fromordinal(today.toordinal() - 1)
    if streak.last_activity_date == yesterday:
        streak.current_streak += 1
    else:
        streak.current_streak = 1

    streak.last_activity_date = today
    if streak.current_streak > streak.longest_streak:
        streak.longest_streak = streak.current_streak

    unlocked = _check_streak_achievements(db, student_id, streak.current_streak)
    db.commit()
    _notify_achievements(db, student_id, unlocked)
    return unlocked


def record_lesson_completed(db: Session, student_id) -> list:
    completed = (
        db.query(LearningSession)
        .filter(
            LearningSession.student_id == student_id,
            LearningSession.ended_at.isnot(None),
        )
        .count()
    )
    unlocked = []
    for threshold, code in ((1, "lessons_1"), (5, "lessons_5")):
        if completed >= threshold:
            ach = db.query(Achievement).filter(Achievement.code == code).first()
            if ach:
                result = _unlock_if_new(db, student_id, ach)
                if result:
                    unlocked.append(result)
    db.commit()
    _notify_achievements(db, student_id, unlocked)
    return unlocked


def record_quiz_completed(db: Session, student_id, score: int, total: int) -> list:
    unlocked = []
    # perfect score achievement
    if score == total and total > 0:
        ach = db.query(Achievement).filter(Achievement.code == "quiz_perfect").first()
        if ach:
            result = _unlock_if_new(db, student_id, ach)
            if result:
                unlocked.append(result)

    # quizzes_10: total quizzes attempted
    quiz_count = db.query(QuizResult).filter(QuizResult.student_id == student_id).count()
    if quiz_count >= 10:
        ach = db.query(Achievement).filter(Achievement.code == "quizzes_10").first()
        if ach:
            result = _unlock_if_new(db, student_id, ach)
            if result:
                unlocked.append(result)

    db.commit()
    _notify_achievements(db, student_id, unlocked)
    return unlocked


def record_reading(db: Session, student_id) -> list:
    # Count OCR scan sessions (session_type = 'scan' or 'upload')
    from app.models.learning_session import SessionType
    scan_count = (
        db.query(LearningSession)
        .filter(
            LearningSession.student_id == student_id,
            LearningSession.session_type.in_([SessionType.scan, SessionType.upload]),
        )
        .count()
    )
    unlocked = []
    if scan_count >= 10:
        ach = db.query(Achievement).filter(Achievement.code == "readings_10").first()
        if ach:
            result = _unlock_if_new(db, student_id, ach)
            if result:
                unlocked.append(result)
    db.commit()
    _notify_achievements(db, student_id, unlocked)
    return unlocked


def get_student_progress(db: Session, student_id) -> dict:
    all_achievements = db.query(Achievement).all()
    unlocked_rows = (
        db.query(StudentAchievement)
        .filter(StudentAchievement.student_id == student_id)
        .all()
    )
    unlocked_ids = {str(r.achievement_id): r.unlocked_at for r in unlocked_rows}

    streak = _get_or_create_streak(db, student_id)
    db.commit()

    achievements_out = []
    for ach in all_achievements:
        aid = str(ach.id)
        achievements_out.append({
            "id": aid,
            "code": ach.code,
            "name_ar": ach.name_ar,
            "description_ar": ach.description_ar,
            "icon_emoji": ach.icon_emoji,
            "threshold": ach.threshold,
            "kind": ach.kind,
            "unlocked": aid in unlocked_ids,
            "unlocked_at": (
                unlocked_ids[aid].isoformat() if aid in unlocked_ids else None
            ),
        })

    return {
        "achievements": achievements_out,
        "streak": {
            "current_streak": streak.current_streak,
            "longest_streak": streak.longest_streak,
            "last_activity_date": (
                streak.last_activity_date.isoformat() if streak.last_activity_date else None
            ),
        },
    }
