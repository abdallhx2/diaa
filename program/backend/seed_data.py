"""
Seed realistic Arabic data for development/testing.
Usage:  python seed_data.py
"""

import sys
import uuid
from datetime import datetime, timezone, timedelta
from app.database import SessionLocal
from app.models.user import User, UserRole
from app.models.student import Student
from app.models.parent import Parent
from app.models.admin import Admin
from app.models.lesson import Lesson
from app.models.quiz import Quiz, QuizType
from app.models.learning_session import LearningSession, SessionType
from app.models.quiz_result import QuizResult
from app.models.chat_message import ChatMessage
from app.models.system_log import SystemLog

now = datetime.now(timezone.utc)

# ─── Fixed UUIDs for reproducibility ──────────────────────────────
# Users
UID_AHMED   = uuid.UUID("a0000000-0000-0000-0000-000000000001")
UID_SARA    = uuid.UUID("a0000000-0000-0000-0000-000000000002")
UID_MOHAMMED = uuid.UUID("a0000000-0000-0000-0000-000000000003")
UID_KHALED  = uuid.UUID("a0000000-0000-0000-0000-000000000004")
UID_NOURA   = uuid.UUID("a0000000-0000-0000-0000-000000000005")
UID_ADMIN   = uuid.UUID("a0000000-0000-0000-0000-000000000006")

# Students
SID_AHMED   = uuid.UUID("b0000000-0000-0000-0000-000000000001")
SID_SARA    = uuid.UUID("b0000000-0000-0000-0000-000000000002")
SID_MOHAMMED = uuid.UUID("b0000000-0000-0000-0000-000000000003")

# Parents
PID_KHALED  = uuid.UUID("c0000000-0000-0000-0000-000000000001")
PID_NOURA   = uuid.UUID("c0000000-0000-0000-0000-000000000002")

# Admin
AID_ADMIN   = uuid.UUID("d0000000-0000-0000-0000-000000000001")

# Lessons
LID_1 = uuid.UUID("e0000000-0000-0000-0000-000000000001")
LID_2 = uuid.UUID("e0000000-0000-0000-0000-000000000002")
LID_3 = uuid.UUID("e0000000-0000-0000-0000-000000000003")
LID_4 = uuid.UUID("e0000000-0000-0000-0000-000000000004")
LID_5 = uuid.UUID("e0000000-0000-0000-0000-000000000005")

# ─── Users ────────────────────────────────────────────────────────
USERS = [
    # Real Firebase Auth UIDs for test accounts
    # student@diyaa.test / Test123456 → U4vvHlF4zRa6su2QzC9uXgXHLRz2
    # parent@diyaa.test  / Test123456 → KBA71Xo0bRTTa3H7DRCSE5NAApt2
    User(id=UID_AHMED, firebase_uid="92b635990f8c57ea92278e840ed58674", role=UserRole.student,
         name="ahmed", email="ahmed@example.com", phone="0501234567",
         created_at=now - timedelta(days=30)),
    User(id=UID_SARA, firebase_uid="U4vvHlF4zRa6su2QzC9uXgXHLRz2", role=UserRole.student,
         name="سارة الطالبة", email="student@diyaa.test", phone="0507654321",
         created_at=now - timedelta(days=25)),
    User(id=UID_MOHAMMED, firebase_uid="40ccff8d71041bdd88e18abe88aa12e7", role=UserRole.student,
         name="mohammed", email="mohammed@example.com", phone="0509876543",
         created_at=now - timedelta(days=20)),
    User(id=UID_KHALED, firebase_uid="5e4c97cf7ac31c0935a5aa74fbc21a78", role=UserRole.parent,
         name="أحمد ولي الأمر", email="parent@diyaa.test", phone="0551112222",
         created_at=now - timedelta(days=30)),
    User(id=UID_NOURA, firebase_uid="c577df074985dac157b077128f77b23a", role=UserRole.parent,
         name="noura", email="noura@example.com", phone="0553334444",
         created_at=now - timedelta(days=25)),
    User(id=UID_ADMIN, firebase_uid="d071bfabcb1fa7daac84cf2350db4a1c", role=UserRole.admin,
         name="abdullah", email="admin@edusmart.sa", phone="0500000000",
         created_at=now - timedelta(days=60)),
]

# ─── Parents ──────────────────────────────────────────────────────
PARENTS = [
    Parent(id=PID_KHALED, user_id=UID_KHALED, created_at=now - timedelta(days=30)),
    Parent(id=PID_NOURA, user_id=UID_NOURA, created_at=now - timedelta(days=25)),
]

# ─── Students ─────────────────────────────────────────────────────
STUDENTS = [
    Student(id=SID_AHMED, user_id=UID_AHMED, parent_id=PID_KHALED,
            age=6, grade="الصف الاول", learning_level="مبتدئ", progress_score=45.50,
            created_at=now - timedelta(days=30)),
    Student(id=SID_SARA, user_id=UID_SARA, parent_id=PID_NOURA,
            age=8, grade="الصف الثالث", learning_level="متوسط", progress_score=72.00,
            created_at=now - timedelta(days=25)),
    Student(id=SID_MOHAMMED, user_id=UID_MOHAMMED, parent_id=PID_KHALED,
            age=10, grade="الصف الخامس", learning_level="متقدم", progress_score=88.75,
            created_at=now - timedelta(days=20)),
]

# ─── Admin ────────────────────────────────────────────────────────
ADMINS = [
    Admin(id=AID_ADMIN, user_id=UID_ADMIN, admin_level="super",
          created_at=now - timedelta(days=60)),
]

# ─── Lessons (5 real lessons) ─────────────────────────────────────
LESSONS = [
    Lesson(
        id=LID_1,
        title="حرف الالف",
        subject="لغتي",
        grade_level="الصف الاول",
        qr_code="QR001",
        original_text=(
            "حرف الالف هو اول حرف في الحروف الهجائية العربية. "
            "شكل حرف الالف يشبه العصا المستقيمة: ا. "
            "الالف حرف لا يتصل بما بعده. "
            "كلمات تبدا بحرف الالف: اسد، ارنب، اناناس، اسرة. "
            "الالف في اول الكلمة ينطق بالفتحة (اَ) مثل: اَسد، "
            "وبالكسرة (اِ) مثل: اِبرة، وبالضمة (اُ) مثل: اُذن. "
            "تدريب: اكتب حرف الالف خمس مرات وتعرف على كلمات جديدة تبدا بحرف الالف."
        ),
        created_at=now - timedelta(days=14),
    ),
    Lesson(
        id=LID_2,
        title="الجملة الاسمية",
        subject="لغتي",
        grade_level="الصف الثالث",
        qr_code="QR002",
        original_text=(
            "الجملة الاسمية هي الجملة التي تبدا باسم. "
            "تتكون الجملة الاسمية من ركنين اساسيين: المبتدا والخبر. "
            "المبتدا هو الاسم الذي نتحدث عنه، والخبر هو ما نخبر به عن المبتدا. "
            "امثلة: السماء صافية - المبتدا: السماء، الخبر: صافية. "
            "الطالب مجتهد - المبتدا: الطالب، الخبر: مجتهد. "
            "الشمس مشرقة - المبتدا: الشمس، الخبر: مشرقة. "
            "المبتدا والخبر كلاهما مرفوعان. "
            "تدريب: كون ثلاث جمل اسمية من عندك."
        ),
        created_at=now - timedelta(days=12),
    ),
    Lesson(
        id=LID_3,
        title="الاعداد من 1 الى 10",
        subject="رياضيات",
        grade_level="الصف الاول",
        qr_code="QR003",
        original_text=(
            "الاعداد من واحد الى عشرة هي: 1 واحد، 2 اثنان، 3 ثلاثة، "
            "4 اربعة، 5 خمسة، 6 ستة، 7 سبعة، 8 ثمانية، 9 تسعة، 10 عشرة. "
            "العدد الذي ياتي قبل 5 هو 4، والعدد الذي ياتي بعد 5 هو 6. "
            "نستخدم الاعداد في العد والحساب وفي حياتنا اليومية. "
            "مثلا: عندي 3 تفاحات واشتريت 2 اخرى، فاصبح عندي 5 تفاحات. "
            "تدريب: عد من 1 الى 10 ثم من 10 الى 1."
        ),
        created_at=now - timedelta(days=10),
    ),
    Lesson(
        id=LID_4,
        title="حالات المادة",
        subject="علوم",
        grade_level="الصف الثالث",
        qr_code="QR004",
        original_text=(
            "للمادة ثلاث حالات رئيسية: الحالة الصلبة والحالة السائلة والحالة الغازية. "
            "المادة الصلبة لها شكل ثابت وحجم ثابت، مثل: الخشب والحديد والحجر. "
            "المادة السائلة لها حجم ثابت لكن ليس لها شكل ثابت، وتاخذ شكل الاناء الذي توضع فيه، مثل: الماء والحليب والعصير. "
            "المادة الغازية ليس لها شكل ثابت ولا حجم ثابت، وتنتشر في كل الاتجاهات، مثل: الهواء وبخار الماء. "
            "يمكن تحويل المادة من حالة الى اخرى عن طريق التسخين او التبريد. "
            "مثلا: الماء سائل، اذا سخناه يتحول الى بخار (غاز)، واذا بردناه يتحول الى ثلج (صلب)."
        ),
        created_at=now - timedelta(days=8),
    ),
    Lesson(
        id=LID_5,
        title="اركان الاسلام",
        subject="تربية اسلامية",
        grade_level="الصف الخامس",
        qr_code="QR005",
        original_text=(
            "اركان الاسلام خمسة، وهي الاساس الذي يقوم عليه الدين الاسلامي. "
            "الركن الاول: شهادة ان لا اله الا الله وان محمدا رسول الله، وهي اساس الدين كله. "
            "الركن الثاني: اقامة الصلاة، وهي خمس صلوات في اليوم والليلة: الفجر والظهر والعصر والمغرب والعشاء. "
            "الركن الثالث: ايتاء الزكاة، وهي حق المال الذي يعطى للفقراء والمحتاجين. "
            "الركن الرابع: صوم رمضان، وهو الامتناع عن الطعام والشراب من الفجر حتى المغرب في شهر رمضان. "
            "الركن الخامس: حج البيت لمن استطاع اليه سبيلا، وهو زيارة بيت الله الحرام في مكة المكرمة. "
            "قال النبي صلى الله عليه وسلم: بني الاسلام على خمس."
        ),
        created_at=now - timedelta(days=5),
    ),
]

# ─── Quizzes (3 per lesson = 15) ──────────────────────────────────
QUIZZES = []
_qid = 0


def _quid():
    global _qid
    _qid += 1
    return uuid.UUID(f"f0000000-0000-0000-0000-{_qid:012d}")


# Lesson 1: حرف الالف
QUIZZES += [
    Quiz(id=_quid(), lesson_id=LID_1, quiz_type=QuizType.reading,
         question_text="ما هو اول حرف في الحروف الهجائية العربية؟",
         options={"ا": "الالف", "ب": "الباء", "ج": "التاء", "د": "الدال"},
         correct_answer="ا"),
    Quiz(id=_quid(), lesson_id=LID_1, quiz_type=QuizType.writing,
         question_text="اي كلمة تبدا بحرف الالف؟",
         options={"ا": "بقرة", "ب": "ارنب", "ج": "قطة", "د": "كلب"},
         correct_answer="ب"),
    Quiz(id=_quid(), lesson_id=LID_1, quiz_type=QuizType.comprehension,
         question_text="حرف الالف لا يتصل بما بعده. ما شكله؟",
         options={"ا": "يشبه الدائرة", "ب": "يشبه العصا المستقيمة", "ج": "يشبه النقطة", "د": "يشبه الهلال"},
         correct_answer="ب"),
]

# Lesson 2: الجملة الاسمية
QUIZZES += [
    Quiz(id=_quid(), lesson_id=LID_2, quiz_type=QuizType.reading,
         question_text="ما هي الجملة الاسمية؟",
         options={"ا": "جملة تبدا بفعل", "ب": "جملة تبدا باسم", "ج": "جملة تبدا بحرف", "د": "جملة بدون فعل او اسم"},
         correct_answer="ب"),
    Quiz(id=_quid(), lesson_id=LID_2, quiz_type=QuizType.writing,
         question_text="في جملة (الطالب مجتهد) ما هو المبتدا؟",
         options={"ا": "مجتهد", "ب": "الطالب", "ج": "في", "د": "جملة"},
         correct_answer="ب"),
    Quiz(id=_quid(), lesson_id=LID_2, quiz_type=QuizType.comprehension,
         question_text="تتكون الجملة الاسمية من ركنين هما:",
         options={"ا": "الفعل والفاعل", "ب": "المبتدا والخبر", "ج": "الحرف والاسم", "د": "الفاعل والمفعول به"},
         correct_answer="ب"),
]

# Lesson 3: الاعداد من 1 الى 10
QUIZZES += [
    Quiz(id=_quid(), lesson_id=LID_3, quiz_type=QuizType.reading,
         question_text="ما هو العدد الذي ياتي بعد الرقم 7؟",
         options={"ا": "6", "ب": "8", "ج": "9", "د": "5"},
         correct_answer="ب"),
    Quiz(id=_quid(), lesson_id=LID_3, quiz_type=QuizType.writing,
         question_text="اكتب ناتج: 3 + 2 = ؟",
         options={"ا": "4", "ب": "6", "ج": "5", "د": "3"},
         correct_answer="ج"),
    Quiz(id=_quid(), lesson_id=LID_3, quiz_type=QuizType.comprehension,
         question_text="عندي 3 تفاحات واشتريت 2، كم اصبح عندي؟",
         options={"ا": "4 تفاحات", "ب": "6 تفاحات", "ج": "3 تفاحات", "د": "5 تفاحات"},
         correct_answer="د"),
]

# Lesson 4: حالات المادة
QUIZZES += [
    Quiz(id=_quid(), lesson_id=LID_4, quiz_type=QuizType.reading,
         question_text="كم حالة رئيسية للمادة؟",
         options={"ا": "حالتان", "ب": "ثلاث حالات", "ج": "اربع حالات", "د": "خمس حالات"},
         correct_answer="ب"),
    Quiz(id=_quid(), lesson_id=LID_4, quiz_type=QuizType.writing,
         question_text="اي مما يلي مثال على المادة السائلة؟",
         options={"ا": "الحجر", "ب": "الهواء", "ج": "الماء", "د": "الخشب"},
         correct_answer="ج"),
    Quiz(id=_quid(), lesson_id=LID_4, quiz_type=QuizType.comprehension,
         question_text="ماذا يحدث للماء عندما نبرده كثيرا؟",
         options={"ا": "يتحول الى بخار", "ب": "يبقى سائلا", "ج": "يتحول الى ثلج", "د": "يختفي"},
         correct_answer="ج"),
]

# Lesson 5: اركان الاسلام
QUIZZES += [
    Quiz(id=_quid(), lesson_id=LID_5, quiz_type=QuizType.reading,
         question_text="كم عدد اركان الاسلام؟",
         options={"ا": "ثلاثة", "ب": "اربعة", "ج": "خمسة", "د": "ستة"},
         correct_answer="ج"),
    Quiz(id=_quid(), lesson_id=LID_5, quiz_type=QuizType.writing,
         question_text="ما هو الركن الثاني من اركان الاسلام؟",
         options={"ا": "الزكاة", "ب": "الصلاة", "ج": "الصوم", "د": "الحج"},
         correct_answer="ب"),
    Quiz(id=_quid(), lesson_id=LID_5, quiz_type=QuizType.comprehension,
         question_text="في اي شهر يصوم المسلمون؟",
         options={"ا": "شعبان", "ب": "شوال", "ج": "رمضان", "د": "محرم"},
         correct_answer="ج"),
]

# ─── Learning Sessions (10 sessions) ─────────────────────────────
_sid = 0


def _suid():
    global _sid
    _sid += 1
    return uuid.UUID(f"10000000-0000-0000-0000-{_sid:012d}")


SESSIONS = [
    # Ahmed - 4 sessions
    LearningSession(id=_suid(), student_id=SID_AHMED, lesson_id=LID_1,
                    session_type=SessionType.qr,
                    started_at=now - timedelta(days=7, hours=2),
                    ended_at=now - timedelta(days=7, hours=1, minutes=45),
                    duration_minutes=15),
    LearningSession(id=_suid(), student_id=SID_AHMED, lesson_id=LID_3,
                    session_type=SessionType.scan,
                    started_at=now - timedelta(days=5, hours=3),
                    ended_at=now - timedelta(days=5, hours=2, minutes=40),
                    duration_minutes=20),
    LearningSession(id=_suid(), student_id=SID_AHMED, lesson_id=LID_1,
                    session_type=SessionType.upload,
                    started_at=now - timedelta(days=3, hours=1),
                    ended_at=now - timedelta(days=3, hours=0, minutes=50),
                    duration_minutes=10),
    LearningSession(id=_suid(), student_id=SID_AHMED, lesson_id=LID_3,
                    session_type=SessionType.qr,
                    started_at=now - timedelta(days=1, hours=4),
                    ended_at=now - timedelta(days=1, hours=3, minutes=30),
                    duration_minutes=30),
    # Sara - 3 sessions
    LearningSession(id=_suid(), student_id=SID_SARA, lesson_id=LID_2,
                    session_type=SessionType.qr,
                    started_at=now - timedelta(days=6, hours=5),
                    ended_at=now - timedelta(days=6, hours=4, minutes=35),
                    duration_minutes=25),
    LearningSession(id=_suid(), student_id=SID_SARA, lesson_id=LID_4,
                    session_type=SessionType.scan,
                    started_at=now - timedelta(days=4, hours=2),
                    ended_at=now - timedelta(days=4, hours=1, minutes=42),
                    duration_minutes=18),
    LearningSession(id=_suid(), student_id=SID_SARA, lesson_id=LID_2,
                    session_type=SessionType.upload,
                    started_at=now - timedelta(days=2, hours=6),
                    ended_at=now - timedelta(days=2, hours=5, minutes=52),
                    duration_minutes=8),
    # Mohammed - 3 sessions
    LearningSession(id=_suid(), student_id=SID_MOHAMMED, lesson_id=LID_5,
                    session_type=SessionType.qr,
                    started_at=now - timedelta(days=5, hours=1),
                    ended_at=now - timedelta(days=5, hours=0, minutes=35),
                    duration_minutes=25),
    LearningSession(id=_suid(), student_id=SID_MOHAMMED, lesson_id=LID_5,
                    session_type=SessionType.scan,
                    started_at=now - timedelta(days=3, hours=3),
                    ended_at=now - timedelta(days=3, hours=2, minutes=55),
                    duration_minutes=5),
    LearningSession(id=_suid(), student_id=SID_MOHAMMED, lesson_id=LID_4,
                    session_type=SessionType.upload,
                    started_at=now - timedelta(days=1, hours=2),
                    ended_at=now - timedelta(days=1, hours=1, minutes=40),
                    duration_minutes=20),
]

# ─── Quiz Results (20 results) ────────────────────────────────────
_rid = 0


def _ruid():
    global _rid
    _rid += 1
    return uuid.UUID(f"20000000-0000-0000-0000-{_rid:012d}")


# Quiz IDs for reference (indexed 0-14)
Q = [q.id for q in QUIZZES]

QUIZ_RESULTS = [
    # Ahmed - 8 results (Lessons 1 & 3)
    QuizResult(id=_ruid(), student_id=SID_AHMED, quiz_id=Q[0],
               selected_answer="ا", is_correct=True, answered_at=now - timedelta(days=7)),
    QuizResult(id=_ruid(), student_id=SID_AHMED, quiz_id=Q[1],
               selected_answer="ب", is_correct=True, answered_at=now - timedelta(days=7)),
    QuizResult(id=_ruid(), student_id=SID_AHMED, quiz_id=Q[2],
               selected_answer="ا", is_correct=False, answered_at=now - timedelta(days=7)),
    QuizResult(id=_ruid(), student_id=SID_AHMED, quiz_id=Q[6],
               selected_answer="ب", is_correct=True, answered_at=now - timedelta(days=5)),
    QuizResult(id=_ruid(), student_id=SID_AHMED, quiz_id=Q[7],
               selected_answer="ج", is_correct=True, answered_at=now - timedelta(days=5)),
    QuizResult(id=_ruid(), student_id=SID_AHMED, quiz_id=Q[8],
               selected_answer="ب", is_correct=False, answered_at=now - timedelta(days=5)),
    QuizResult(id=_ruid(), student_id=SID_AHMED, quiz_id=Q[0],
               selected_answer="ا", is_correct=True, answered_at=now - timedelta(days=3)),
    QuizResult(id=_ruid(), student_id=SID_AHMED, quiz_id=Q[2],
               selected_answer="ب", is_correct=True, answered_at=now - timedelta(days=3)),

    # Sara - 7 results (Lessons 2 & 4)
    QuizResult(id=_ruid(), student_id=SID_SARA, quiz_id=Q[3],
               selected_answer="ب", is_correct=True, answered_at=now - timedelta(days=6)),
    QuizResult(id=_ruid(), student_id=SID_SARA, quiz_id=Q[4],
               selected_answer="ب", is_correct=True, answered_at=now - timedelta(days=6)),
    QuizResult(id=_ruid(), student_id=SID_SARA, quiz_id=Q[5],
               selected_answer="ا", is_correct=False, answered_at=now - timedelta(days=6)),
    QuizResult(id=_ruid(), student_id=SID_SARA, quiz_id=Q[9],
               selected_answer="ب", is_correct=True, answered_at=now - timedelta(days=4)),
    QuizResult(id=_ruid(), student_id=SID_SARA, quiz_id=Q[10],
               selected_answer="ج", is_correct=True, answered_at=now - timedelta(days=4)),
    QuizResult(id=_ruid(), student_id=SID_SARA, quiz_id=Q[11],
               selected_answer="ا", is_correct=False, answered_at=now - timedelta(days=4)),
    QuizResult(id=_ruid(), student_id=SID_SARA, quiz_id=Q[3],
               selected_answer="ب", is_correct=True, answered_at=now - timedelta(days=2)),

    # Mohammed - 5 results (Lesson 5)
    QuizResult(id=_ruid(), student_id=SID_MOHAMMED, quiz_id=Q[12],
               selected_answer="ج", is_correct=True, answered_at=now - timedelta(days=5)),
    QuizResult(id=_ruid(), student_id=SID_MOHAMMED, quiz_id=Q[13],
               selected_answer="ب", is_correct=True, answered_at=now - timedelta(days=5)),
    QuizResult(id=_ruid(), student_id=SID_MOHAMMED, quiz_id=Q[14],
               selected_answer="ج", is_correct=True, answered_at=now - timedelta(days=5)),
    QuizResult(id=_ruid(), student_id=SID_MOHAMMED, quiz_id=Q[9],
               selected_answer="ا", is_correct=False, answered_at=now - timedelta(days=3)),
    QuizResult(id=_ruid(), student_id=SID_MOHAMMED, quiz_id=Q[10],
               selected_answer="ج", is_correct=True, answered_at=now - timedelta(days=3)),
]

# ─── Chat Messages (10 messages) ─────────────────────────────────
_cid = 0


def _cuid():
    global _cid
    _cid += 1
    return uuid.UUID(f"30000000-0000-0000-0000-{_cid:012d}")


CHAT_MESSAGES = [
    # Ahmed asking about حرف الالف
    ChatMessage(id=_cuid(), student_id=SID_AHMED, lesson_id=LID_1,
                role="user", content="ما هو حرف الالف؟",
                created_at=now - timedelta(days=7, hours=1, minutes=50)),
    ChatMessage(id=_cuid(), student_id=SID_AHMED, lesson_id=LID_1,
                role="assistant",
                content="حرف الالف هو اول حرف في الحروف الهجائية العربية. شكله يشبه العصا المستقيمة: ا. ومن الكلمات التي تبدا بالالف: اسد وارنب واناناس.",
                created_at=now - timedelta(days=7, hours=1, minutes=49)),
    # Ahmed asking about الاعداد
    ChatMessage(id=_cuid(), student_id=SID_AHMED, lesson_id=LID_3,
                role="user", content="كم يساوي 3 + 2؟",
                created_at=now - timedelta(days=5, hours=2, minutes=50)),
    ChatMessage(id=_cuid(), student_id=SID_AHMED, lesson_id=LID_3,
                role="assistant",
                content="3 + 2 = 5. مثلا اذا كان عندك 3 تفاحات واشتريت 2 اخرى، يصبح عندك 5 تفاحات!",
                created_at=now - timedelta(days=5, hours=2, minutes=49)),
    # Sara asking about الجملة الاسمية
    ChatMessage(id=_cuid(), student_id=SID_SARA, lesson_id=LID_2,
                role="user", content="ما الفرق بين المبتدا والخبر؟",
                created_at=now - timedelta(days=6, hours=4, minutes=40)),
    ChatMessage(id=_cuid(), student_id=SID_SARA, lesson_id=LID_2,
                role="assistant",
                content="المبتدا هو الاسم الذي نتحدث عنه، والخبر هو المعلومة التي نخبر بها عنه. مثلا في جملة (السماء صافية): السماء هي المبتدا وصافية هي الخبر.",
                created_at=now - timedelta(days=6, hours=4, minutes=39)),
    # Sara asking about حالات المادة
    ChatMessage(id=_cuid(), student_id=SID_SARA, lesson_id=LID_4,
                role="user", content="لماذا الماء سائل؟",
                created_at=now - timedelta(days=4, hours=1, minutes=50)),
    ChatMessage(id=_cuid(), student_id=SID_SARA, lesson_id=LID_4,
                role="assistant",
                content="الماء سائل لان جزيئاته تتحرك بحرية ولكنها متقاربة. لذلك له حجم ثابت لكن ياخذ شكل الاناء. اذا سخناه يتحول لبخار واذا بردناه يتحول لثلج!",
                created_at=now - timedelta(days=4, hours=1, minutes=49)),
    # Mohammed asking about اركان الاسلام
    ChatMessage(id=_cuid(), student_id=SID_MOHAMMED, lesson_id=LID_5,
                role="user", content="ما هي اركان الاسلام الخمسة؟",
                created_at=now - timedelta(days=5, hours=0, minutes=40)),
    ChatMessage(id=_cuid(), student_id=SID_MOHAMMED, lesson_id=LID_5,
                role="assistant",
                content="اركان الاسلام خمسة: 1- الشهادتان 2- الصلاة (خمس مرات يوميا) 3- الزكاة 4- صوم رمضان 5- حج البيت لمن استطاع. وهي الاساس الذي يقوم عليه الاسلام.",
                created_at=now - timedelta(days=5, hours=0, minutes=39)),
]

# ─── System Logs (5 logs) ─────────────────────────────────────────
_lid = 0


def _luid():
    global _lid
    _lid += 1
    return uuid.UUID(f"40000000-0000-0000-0000-{_lid:012d}")


SYSTEM_LOGS = [
    SystemLog(id=_luid(), user_id=UID_ADMIN, action="login",
              status="success", details={"ip": "192.168.1.10", "device": "Chrome"},
              created_at=now - timedelta(days=7)),
    SystemLog(id=_luid(), user_id=UID_ADMIN, action="create_lesson",
              status="success", details={"lesson_title": "حرف الالف", "subject": "لغتي"},
              created_at=now - timedelta(days=7)),
    SystemLog(id=_luid(), user_id=UID_AHMED, action="submit_quiz",
              status="success", details={"quiz_count": 3, "correct": 2, "lesson": "حرف الالف"},
              created_at=now - timedelta(days=6)),
    SystemLog(id=_luid(), user_id=UID_SARA, action="start_session",
              status="success", details={"lesson": "الجملة الاسمية", "type": "qr"},
              created_at=now - timedelta(days=5)),
    SystemLog(id=_luid(), user_id=UID_KHALED, action="view_child_report",
              status="success", details={"child": "ahmed", "report_type": "weekly"},
              created_at=now - timedelta(days=3)),
]


# ─── Seed Function ────────────────────────────────────────────────
def seed():
    db = SessionLocal()
    try:
        existing = db.query(User).count()
        if existing > 0:
            print(f"[SEED] يوجد بالفعل {existing} مستخدم(ين) -- تم التخطي.")
            return

        print("[SEED] بدء ادراج البيانات التجريبية...")

        # Order matters due to foreign keys
        for u in USERS:
            db.add(u)
        db.flush()
        print(f"   [OK] {len(USERS)} مستخدمين")

        for p in PARENTS:
            db.add(p)
        db.flush()
        print(f"   [OK] {len(PARENTS)} اولياء امور")

        for s in STUDENTS:
            db.add(s)
        db.flush()
        print(f"   [OK] {len(STUDENTS)} طلاب")

        for a in ADMINS:
            db.add(a)
        db.flush()
        print(f"   [OK] {len(ADMINS)} مسؤولين")

        for lesson in LESSONS:
            db.add(lesson)
        db.flush()
        print(f"   [OK] {len(LESSONS)} دروس")

        for q in QUIZZES:
            db.add(q)
        db.flush()
        print(f"   [OK] {len(QUIZZES)} سؤال اختبار")

        for s in SESSIONS:
            db.add(s)
        db.flush()
        print(f"   [OK] {len(SESSIONS)} جلسات تعلم")

        for r in QUIZ_RESULTS:
            db.add(r)
        db.flush()
        print(f"   [OK] {len(QUIZ_RESULTS)} نتيجة اختبار")

        for c in CHAT_MESSAGES:
            db.add(c)
        db.flush()
        print(f"   [OK] {len(CHAT_MESSAGES)} رسائل دردشة")

        for log in SYSTEM_LOGS:
            db.add(log)
        db.flush()
        print(f"   [OK] {len(SYSTEM_LOGS)} سجلات نظام")

        db.commit()
        print("[SEED] تم تحميل جميع البيانات التجريبية بنجاح!")

    except Exception as e:
        db.rollback()
        print(f"[SEED ERROR] {e}", file=sys.stderr)
        raise
    finally:
        db.close()


if __name__ == "__main__":
    seed()
