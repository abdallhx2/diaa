"""Seed realistic demo family (الغامدي) with full activity data.

Father: parent@diyaa.test (existing Firebase + DB) → عبدالله سعد الغامدي
Son 1:  student@diyaa.test (existing) → محمد عبدالله الغامدي (grade الخامس)
Son 2:  student2@diyaa.test (NEW) → خالد عبدالله الغامدي (grade الثاني)
Admin:  admin@edusmart.sa (existing) → فيصل عبدالرحمن المنصور

Idempotent: safe to re-run. Uses INSERT...ON CONFLICT for relinks, deletes
prior demo activity for the two sons before re-seeding.
"""
import os
import random
from datetime import datetime, timedelta, timezone, date
from uuid import uuid4

import firebase_admin
from firebase_admin import credentials, auth as fb_auth

from app.database import SessionLocal
from app.models.user import User, UserRole
from app.models.student import Student
from app.models.parent import Parent
from app.models.admin import Admin
from app.models.lesson import Lesson
from app.models.quiz import Quiz
from app.models.quiz_result import QuizResult
from app.models.learning_session import LearningSession, SessionType
from app.models.chat_message import ChatMessage
from app.models.student_streak import StudentStreak
from app.models.student_achievement import StudentAchievement
from app.models.achievement import Achievement
from app.config import settings


# ── Firebase Init ─────────────────────────────────────────────────────────
if not firebase_admin._apps:
    cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS_PATH)
    firebase_admin.initialize_app(cred)


# ── Family Data ───────────────────────────────────────────────────────────
FATHER = {
    "email": "parent@diyaa.test",
    "name": "عبدالله سعد الغامدي",
}
SON1 = {
    "email": "student@diyaa.test",
    "name": "محمد عبدالله الغامدي",
    "grade": "الخامس",
    "age": 11,
    "level": "متقدم",
    "score": 88.5,
    "streak": 7,
    "longest_streak": 14,
}
SON2 = {
    "email": "student2@diyaa.test",
    "name": "خالد عبدالله الغامدي",
    "grade": "الثاني",
    "age": 8,
    "level": "متوسط",
    "score": 65.0,
    "streak": 3,
    "longest_streak": 5,
}
ADMIN = {
    "email": "admin@edusmart.sa",
    "name": "فيصل عبدالرحمن المنصور",
}
PASSWORD = "Test123456"


def get_or_create_firebase_user(email: str, password: str, display_name: str) -> str:
    """Return Firebase UID. Create if missing, update display name."""
    try:
        user = fb_auth.get_user_by_email(email)
        fb_auth.update_user(user.uid, password=password, display_name=display_name)
        return user.uid
    except fb_auth.UserNotFoundError:
        user = fb_auth.create_user(email=email, password=password, display_name=display_name)
        return user.uid


def upsert_db_user(db, firebase_uid: str, email: str, name: str, role: UserRole) -> User:
    user = db.query(User).filter(User.email == email).first()
    if user is None:
        # also try by firebase_uid (covers email change)
        user = db.query(User).filter(User.firebase_uid == firebase_uid).first()
    if user is None:
        user = User(
            id=uuid4(),
            firebase_uid=firebase_uid,
            email=email,
            name=name,
            role=role,
        )
        db.add(user)
        db.flush()
    else:
        user.firebase_uid = firebase_uid
        user.email = email
        user.name = name
        user.role = role
    return user


def upsert_parent(db, user_id) -> Parent:
    p = db.query(Parent).filter(Parent.user_id == user_id).first()
    if p is None:
        p = Parent(id=uuid4(), user_id=user_id)
        db.add(p)
        db.flush()
    return p


def upsert_student(db, user_id, parent_id, grade, age, level, score) -> Student:
    s = db.query(Student).filter(Student.user_id == user_id).first()
    if s is None:
        s = Student(
            id=uuid4(),
            user_id=user_id,
            parent_id=parent_id,
            grade=grade,
            age=age,
            learning_level=level,
            progress_score=score,
        )
        db.add(s)
        db.flush()
    else:
        s.parent_id = parent_id
        s.grade = grade
        s.age = age
        s.learning_level = level
        s.progress_score = score
    return s


def upsert_admin(db, user_id) -> Admin:
    a = db.query(Admin).filter(Admin.user_id == user_id).first()
    if a is None:
        a = Admin(id=uuid4(), user_id=user_id)
        db.add(a)
        db.flush()
    return a


def clear_student_activity(db, student_id):
    db.query(QuizResult).filter(QuizResult.student_id == student_id).delete(synchronize_session=False)
    db.query(LearningSession).filter(LearningSession.student_id == student_id).delete(synchronize_session=False)
    db.query(ChatMessage).filter(ChatMessage.student_id == student_id).delete(synchronize_session=False)
    db.query(StudentAchievement).filter(StudentAchievement.student_id == student_id).delete(synchronize_session=False)
    db.query(StudentStreak).filter(StudentStreak.student_id == student_id).delete(synchronize_session=False)
    db.flush()


def seed_sessions_for_student(db, student_id, lessons, n_sessions: int):
    """Create n_sessions LearningSession rows over the last 14 days."""
    if not lessons:
        return []
    created = []
    now = datetime.now(timezone.utc)
    for i in range(n_sessions):
        lesson = random.choice(lessons)
        days_ago = random.randint(0, 13)
        started = now - timedelta(days=days_ago, hours=random.randint(8, 19), minutes=random.randint(0, 59))
        duration = random.randint(5, 18)
        ended = started + timedelta(minutes=duration)
        session = LearningSession(
            id=uuid4(),
            student_id=student_id,
            lesson_id=lesson.id,
            session_type=SessionType.scan,
            started_at=started,
            ended_at=ended,
            duration_minutes=duration,
        )
        db.add(session)
        created.append(session)
    db.flush()
    return created


def seed_quiz_results_for_student(db, student_id, quizzes, n_results: int, accuracy: float):
    """Create n_results QuizResult rows. accuracy = % correct."""
    if not quizzes:
        return
    now = datetime.now(timezone.utc)
    for _ in range(n_results):
        quiz = random.choice(quizzes)
        is_correct = random.random() < accuracy
        # Pick correct or incorrect answer from options
        opts = quiz.options if isinstance(quiz.options, list) else (
            list(quiz.options.values()) if isinstance(quiz.options, dict) else []
        )
        if not opts:
            continue
        if is_correct:
            stored = (quiz.correct_answer or "").strip()
            if isinstance(quiz.options, dict) and stored in quiz.options:
                selected = str(quiz.options[stored])
            else:
                selected = stored
        else:
            wrong_opts = [o for o in opts if o != quiz.correct_answer]
            selected = random.choice(wrong_opts) if wrong_opts else opts[0]
        days_ago = random.randint(0, 13)
        answered = now - timedelta(days=days_ago, hours=random.randint(8, 20))
        db.add(QuizResult(
            id=uuid4(),
            student_id=student_id,
            quiz_id=quiz.id,
            selected_answer=selected,
            is_correct=is_correct,
            answered_at=answered,
        ))
    db.flush()


def seed_chat_for_student(db, student_id, lessons, n_pairs: int):
    """Create n_pairs of (user, assistant) messages tied to random lessons."""
    if not lessons:
        return
    sample_questions = [
        "ما معنى هذه الكلمة؟",
        "لماذا يحدث هذا؟",
        "اشرح لي مرة ثانية",
        "ما الفائدة من ذلك؟",
        "كيف أحفظ هذه القصيدة؟",
    ]
    sample_answers = [
        "سؤال جميل! دعنا نشرح بالتفصيل…",
        "في هذا الدرس، الإجابة هي كالتالي:",
        "بالطبع، إليك الشرح بطريقة أبسط:",
        "الفائدة كبيرة، أهمها:",
        "خطوات بسيطة لحفظها:",
    ]
    now = datetime.now(timezone.utc)
    for i in range(n_pairs):
        lesson = random.choice(lessons)
        ts = now - timedelta(days=random.randint(0, 10), hours=random.randint(8, 20))
        db.add(ChatMessage(
            id=uuid4(),
            student_id=student_id,
            lesson_id=lesson.id,
            role="user",
            content=random.choice(sample_questions),
            created_at=ts,
        ))
        db.add(ChatMessage(
            id=uuid4(),
            student_id=student_id,
            lesson_id=lesson.id,
            role="assistant",
            content=random.choice(sample_answers),
            created_at=ts + timedelta(seconds=2),
        ))
    db.flush()


def seed_streak(db, student_id, current: int, longest: int):
    streak = StudentStreak(
        student_id=student_id,
        current_streak=current,
        longest_streak=longest,
        last_activity_date=date.today(),
    )
    db.add(streak)
    db.flush()


def seed_achievements(db, student_id, codes):
    rows = db.query(Achievement).filter(Achievement.code.in_(codes)).all()
    for ach in rows:
        db.add(StudentAchievement(
            id=uuid4(),
            student_id=student_id,
            achievement_id=ach.id,
            unlocked_at=datetime.now(timezone.utc) - timedelta(days=random.randint(1, 7)),
        ))
    db.flush()


def main():
    db = SessionLocal()
    try:
        print("=== Step 1: Firebase users ===")
        father_uid = get_or_create_firebase_user(FATHER["email"], PASSWORD, FATHER["name"])
        son1_uid = get_or_create_firebase_user(SON1["email"], PASSWORD, SON1["name"])
        son2_uid = get_or_create_firebase_user(SON2["email"], PASSWORD, SON2["name"])
        admin_uid = get_or_create_firebase_user(ADMIN["email"], PASSWORD, ADMIN["name"])
        print(f"  father: {father_uid}")
        print(f"  son1:   {son1_uid}")
        print(f"  son2:   {son2_uid}")
        print(f"  admin:  {admin_uid}")

        print("\n=== Step 2: DB users ===")
        father_user = upsert_db_user(db, father_uid, FATHER["email"], FATHER["name"], UserRole.parent)
        son1_user = upsert_db_user(db, son1_uid, SON1["email"], SON1["name"], UserRole.student)
        son2_user = upsert_db_user(db, son2_uid, SON2["email"], SON2["name"], UserRole.student)
        admin_user = upsert_db_user(db, admin_uid, ADMIN["email"], ADMIN["name"], UserRole.admin)
        db.commit()

        print("\n=== Step 3: Parent + Students + Admin ===")
        parent = upsert_parent(db, father_user.id)
        son1 = upsert_student(db, son1_user.id, parent.id, SON1["grade"], SON1["age"], SON1["level"], SON1["score"])
        son2 = upsert_student(db, son2_user.id, parent.id, SON2["grade"], SON2["age"], SON2["level"], SON2["score"])
        admin = upsert_admin(db, admin_user.id)
        db.commit()
        print(f"  parent_id={parent.id}")
        print(f"  son1_id={son1.id}  parent_id={son1.parent_id}")
        print(f"  son2_id={son2.id}  parent_id={son2.parent_id}")

        print("\n=== Step 4: Clearing prior activity for both sons ===")
        clear_student_activity(db, son1.id)
        clear_student_activity(db, son2.id)
        db.commit()

        print("\n=== Step 5: Loading lessons + quizzes per grade ===")
        lessons_son1 = db.query(Lesson).filter(Lesson.grade_level == SON1["grade"]).all()
        lessons_son2 = db.query(Lesson).filter(Lesson.grade_level == SON2["grade"]).all()
        # Fallback to any lessons if grade-specific empty
        if not lessons_son1:
            lessons_son1 = db.query(Lesson).limit(5).all()
        if not lessons_son2:
            lessons_son2 = db.query(Lesson).limit(5).all()
        quizzes_son1 = db.query(Quiz).filter(Quiz.lesson_id.in_([l.id for l in lessons_son1])).all()
        quizzes_son2 = db.query(Quiz).filter(Quiz.lesson_id.in_([l.id for l in lessons_son2])).all()
        if not quizzes_son1:
            quizzes_son1 = db.query(Quiz).limit(10).all()
        if not quizzes_son2:
            quizzes_son2 = db.query(Quiz).limit(10).all()
        print(f"  son1: {len(lessons_son1)} lessons, {len(quizzes_son1)} quizzes")
        print(f"  son2: {len(lessons_son2)} lessons, {len(quizzes_son2)} quizzes")

        print("\n=== Step 6: Sessions ===")
        s1_sessions = seed_sessions_for_student(db, son1.id, lessons_son1, 9)
        s2_sessions = seed_sessions_for_student(db, son2.id, lessons_son2, 6)
        print(f"  son1: {len(s1_sessions)} sessions, son2: {len(s2_sessions)} sessions")

        print("\n=== Step 7: Quiz results ===")
        seed_quiz_results_for_student(db, son1.id, quizzes_son1, 16, accuracy=0.82)
        seed_quiz_results_for_student(db, son2.id, quizzes_son2, 13, accuracy=0.62)

        print("\n=== Step 8: Chat history ===")
        seed_chat_for_student(db, son1.id, lessons_son1, 4)
        seed_chat_for_student(db, son2.id, lessons_son2, 3)

        print("\n=== Step 9: Streaks ===")
        seed_streak(db, son1.id, SON1["streak"], SON1["longest_streak"])
        seed_streak(db, son2.id, SON2["streak"], SON2["longest_streak"])

        print("\n=== Step 10: Achievements ===")
        # son1 (advanced): streak_3, streak_7, lessons_1, lessons_5, quiz_perfect
        seed_achievements(db, son1.id, ["streak_3", "streak_7", "lessons_1", "lessons_5", "quiz_perfect"])
        # son2 (younger): streak_3, lessons_1, quiz_perfect
        seed_achievements(db, son2.id, ["streak_3", "lessons_1", "quiz_perfect"])

        db.commit()

        print("\n=== ✅ DONE ===")
        print("Login credentials (all password = Test123456):")
        print(f"  Father: {FATHER['email']}    | {FATHER['name']}")
        print(f"  Son 1:  {SON1['email']}     | {SON1['name']} | grade {SON1['grade']}")
        print(f"  Son 2:  {SON2['email']}    | {SON2['name']} | grade {SON2['grade']}")
        print(f"  Admin:  {ADMIN['email']}   | {ADMIN['name']}")

    except Exception as e:
        db.rollback()
        print(f"❌ FAILED: {e}")
        raise
    finally:
        db.close()


if __name__ == "__main__":
    main()
