"""
Comprehensive seed script for Diya (ضياء) system testing.
Uses REAL Firebase Auth UIDs so login works end-to-end.

Firebase Auth test users:
  - student@diyaa.test / Test123456  (UID: U4vvHlF4zRa6su2QzC9uXgXHLRz2)
  - parent@diyaa.test  / Test123456  (UID: KBA71Xo0bRTTa3H7DRCSE5NAApt2)

Run:  python seed_test_data.py
"""
import json
import uuid
from datetime import datetime, timedelta, timezone

from app.database import SessionLocal, engine
from app.models import Base
from app.models.user import User, UserRole
from app.models.student import Student
from app.models.parent import Parent
from app.models.admin import Admin
from app.models.lesson import Lesson
from app.models.quiz import Quiz
from app.models.quiz_result import QuizResult
from app.models.chat_message import ChatMessage
from app.models.learning_session import LearningSession
from app.models.system_log import SystemLog


# ═══════════════════════════════════════════════════════════════
# Real Firebase Auth UIDs
# ═══════════════════════════════════════════════════════════════
FB_STUDENT = "U4vvHlF4zRa6su2QzC9uXgXHLRz2"   # student@diyaa.test
FB_PARENT  = "KBA71Xo0bRTTa3H7DRCSE5NAApt2"   # parent@diyaa.test
FB_ADMIN   = "admin_firebase_uid_placeholder"    # no real account yet


def now_utc():
    return datetime.now(timezone.utc)


def seed():
    # Recreate tables
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)

    db = SessionLocal()

    try:
        # ═══════════════════════════════════════════════════
        # 1. USERS
        # ═══════════════════════════════════════════════════

        # Admin
        admin_user = User(
            firebase_uid=FB_ADMIN,
            role=UserRole.admin,
            name="مدير النظام",
            email="admin@diyaa.test",
            phone="0500000000",
            is_active=True,
        )
        db.add(admin_user)
        db.flush()
        db.add(Admin(user_id=admin_user.id, admin_level="super"))

        # Parent (real Firebase user)
        parent_user = User(
            firebase_uid=FB_PARENT,
            role=UserRole.parent,
            name="أحمد ولي الأمر",
            email="parent@diyaa.test",
            phone="0501234567",
            is_active=True,
        )
        db.add(parent_user)
        db.flush()
        parent = Parent(user_id=parent_user.id)
        db.add(parent)
        db.flush()

        # Student (real Firebase user)
        student_user = User(
            firebase_uid=FB_STUDENT,
            role=UserRole.student,
            name="سارة الطالبة",
            email="student@diyaa.test",
            is_active=True,
        )
        db.add(student_user)
        db.flush()
        student1 = Student(
            user_id=student_user.id,
            parent_id=parent.id,
            age=9,
            grade="الثالث",
            learning_level="متوسط",
            progress_score=72.5,
        )
        db.add(student1)
        db.flush()

        # Extra student (child of same parent, no Firebase account)
        s2_user = User(
            firebase_uid="extra_student_uid_001",
            role=UserRole.student,
            name="محمد أحمد",
            email="mohammed@diyaa.test",
            is_active=True,
        )
        db.add(s2_user)
        db.flush()
        student2 = Student(
            user_id=s2_user.id,
            parent_id=parent.id,
            age=11,
            grade="الخامس",
            learning_level="متقدم",
            progress_score=85.0,
        )
        db.add(student2)
        db.flush()

        print(f"[OK] Users: 1 admin, 1 parent, 2 students")

        # ═══════════════════════════════════════════════════
        # 2. LESSONS (8 real Arabic curriculum lessons)
        # ═══════════════════════════════════════════════════

        lessons_data = [
            # --- لغتي الجميلة (الثالث) ---
            {
                "title": "حروف المد",
                "subject": "لغتي الجميلة",
                "grade_level": "الثالث",
                "qr_code": "QR_AR_01",
                "original_text": (
                    "حروف المد هي: الألف (ا) والواو (و) والياء (ي). "
                    "تأتي بعد حرف مفتوح أو مضموم أو مكسور. "
                    "المد بالألف: يأتي بعد فتحة مثل (كِتاب). "
                    "المد بالواو: يأتي بعد ضمة مثل (نُور). "
                    "المد بالياء: يأتي بعد كسرة مثل (جَمِيل). "
                    "حروف المد لا تقبل الحركات لأنها ساكنة دائماً. "
                    "تدريب: استخرج حروف المد من الكلمات التالية: عصفور، سعيد، كتاب."
                ),
            },
            {
                "title": "التنوين",
                "subject": "لغتي الجميلة",
                "grade_level": "الثالث",
                "qr_code": "QR_AR_02",
                "original_text": (
                    "التنوين نون ساكنة تلحق آخر الاسم لفظاً لا كتابةً. "
                    "أنواعه ثلاثة: تنوين الفتح (كتاباً) وتنوين الضم (كتابٌ) وتنوين الكسر (كتابٍ). "
                    "التنوين يأتي في الأسماء فقط ولا يأتي في الأفعال أو الحروف. "
                    "عند تنوين الفتح نضيف ألفاً بعد الحرف الأخير (كتاباً) "
                    "إلا إذا كان الحرف الأخير تاء مربوطة (شجرةً) أو همزة على ألف (سماءً). "
                    "تدريب: نوّن الكلمات التالية بتنوين الفتح: قلم، مدرسة، كتاب."
                ),
            },
            {
                "title": "الشدة",
                "subject": "لغتي الجميلة",
                "grade_level": "الثالث",
                "qr_code": "QR_AR_03",
                "original_text": (
                    "الشدة (ـّ) تعني أن الحرف مكرر: الأول ساكن والثاني متحرك. "
                    "مثل: شمّس = شمْمَس، معلّم = معلْلِم. "
                    "عند قراءة الحرف المشدد ننطقه مرتين: مرة ساكناً ومرة متحركاً. "
                    "الشدة تأتي مع الفتحة (شَدَّ) والضمة (يَمُدُّ) والكسرة (حِلِّ). "
                    "تدريب: اقرأ الكلمات التالية مع ضبط الشدة: سلّم، قطّة، درّاجة."
                ),
            },
            {
                "title": "اللام الشمسية والقمرية",
                "subject": "لغتي الجميلة",
                "grade_level": "الثالث",
                "qr_code": "QR_AR_04",
                "original_text": (
                    "اللام الشمسية لا تُنطق وتُدغم في الحرف بعدها مثل: الشّمس، النّور، التّفاح. "
                    "اللام القمرية تُنطق ويأتي بعدها سكون مثل: القمر، الكتاب، العلم. "
                    "الحروف الشمسية: ت ث د ذ ر ز س ش ص ض ط ظ ل ن. "
                    "الحروف القمرية: أ ب ج ح خ ع غ ف ق ك م هـ و ي. "
                    "طريقة سهلة: إذا نطقت (ال) بوضوح فهي قمرية، وإذا لم تنطقها فهي شمسية. "
                    "تدريب: صنّف الكلمات التالية إلى شمسية وقمرية: الباب، الدرس، الحقيبة، الطاولة."
                ),
            },
            # --- رياضيات (الثالث) ---
            {
                "title": "الجمع والطرح حتى 999",
                "subject": "الرياضيات",
                "grade_level": "الثالث",
                "qr_code": "QR_MATH_01",
                "original_text": (
                    "الجمع هو إضافة عددين أو أكثر للحصول على المجموع. "
                    "الطرح هو إيجاد الفرق بين عددين. "
                    "عند الجمع نبدأ من خانة الآحاد ثم العشرات ثم المئات. "
                    "مثال: 345 + 237 = 582. نجمع الآحاد: 5+7=12 نكتب 2 ونحمل 1. "
                    "ثم العشرات: 4+3+1=8. ثم المئات: 3+2=5. "
                    "عند الطرح: 582 - 345 = 237. نطرح الآحاد: 2-5 لا يمكن، نستلف من العشرات. "
                    "تدريب: احسب 456 + 328 و 754 - 389."
                ),
            },
            # --- العلوم (الثالث) ---
            {
                "title": "حالات المادة",
                "subject": "العلوم",
                "grade_level": "الثالث",
                "qr_code": "QR_SCI_01",
                "original_text": (
                    "للمادة ثلاث حالات رئيسية: الحالة الصلبة والحالة السائلة والحالة الغازية. "
                    "المادة الصلبة لها شكل ثابت وحجم ثابت مثل الخشب والحديد والحجر. "
                    "المادة السائلة لها حجم ثابت لكن ليس لها شكل ثابت وتأخذ شكل الإناء مثل الماء والحليب. "
                    "المادة الغازية ليس لها شكل ثابت ولا حجم ثابت وتنتشر في كل الاتجاهات مثل الهواء وبخار الماء. "
                    "يمكن تحويل المادة من حالة لأخرى: الماء سائل يتحول لبخار بالتسخين وثلج بالتبريد. "
                    "تدريب: صنف المواد التالية حسب حالتها: حليب، حديد، أكسجين، عصير، خشب."
                ),
            },
            # --- التربية الإسلامية (الثالث) ---
            {
                "title": "آداب الطعام والشراب",
                "subject": "التربية الإسلامية",
                "grade_level": "الثالث",
                "qr_code": "QR_ISL_01",
                "original_text": (
                    "من آداب الطعام في الإسلام: التسمية قبل الأكل بقول بسم الله. "
                    "الأكل باليد اليمنى والأكل مما يليك. "
                    "عدم الإسراف في الطعام لقوله تعالى: وكلوا واشربوا ولا تسرفوا. "
                    "حمد الله بعد الانتهاء بقول: الحمد لله الذي أطعمني هذا ورزقنيه من غير حول مني ولا قوة. "
                    "من آداب الشراب: عدم الشرب واقفاً والتنفس خارج الإناء والشرب ثلاث مرات. "
                    "تدريب: اذكر ثلاثة آداب للطعام تعلمتها من الدرس."
                ),
            },
            # --- رياضيات (الخامس) for student2 ---
            {
                "title": "الكسور العشرية",
                "subject": "الرياضيات",
                "grade_level": "الخامس",
                "qr_code": "QR_MATH_05",
                "original_text": (
                    "الكسر العشري هو كسر مقامه 10 أو 100 أو 1000 ويُكتب باستخدام الفاصلة العشرية. "
                    "مثال: 3/10 = 0.3 و 25/100 = 0.25 و 7/1000 = 0.007. "
                    "لقراءة الكسر العشري: 0.5 نقول صفر فاصلة خمسة أو خمسة من عشرة. "
                    "لمقارنة الكسور العشرية نقارن خانة بخانة من اليسار. "
                    "مثال: 0.45 > 0.39 لأن 4 عشرات أكبر من 3 عشرات. "
                    "الجمع والطرح: نرتب الأعداد بحيث تكون الفواصل العشرية تحت بعضها. "
                    "تدريب: رتب الأعداد التالية من الأصغر للأكبر: 0.7، 0.35، 0.8، 0.42."
                ),
            },
        ]

        lessons = []
        for ld in lessons_data:
            lesson = Lesson(**ld)
            db.add(lesson)
            db.flush()
            lessons.append(lesson)

        print(f"[OK] Lessons: {len(lessons)} created")

        # ═══════════════════════════════════════════════════
        # 3. QUIZZES (5 per lesson for first 4, 3 for rest)
        # ═══════════════════════════════════════════════════

        quizzes_data = {
            # Lesson 0: حروف المد
            0: [
                ("reading", "ما هي حروف المد؟",
                 ["الألف والواو والياء", "الباء والتاء والثاء", "الحاء والخاء والدال", "الراء والزاي والسين"],
                 "الألف والواو والياء"),
                ("reading", "كلمة (كتاب) فيها مد بـ",
                 ["الألف", "الواو", "الياء", "لا يوجد مد"], "الألف"),
                ("reading", "كلمة (نور) فيها مد بـ",
                 ["الألف", "الواو", "الياء", "لا يوجد مد"], "الواو"),
                ("comprehension", "كلمة (جميل) فيها مد بـ",
                 ["الألف", "الواو", "الياء", "لا يوجد مد"], "الياء"),
                ("comprehension", "حرف المد يأتي بعد حرف",
                 ["ساكن", "متحرك", "مشدد", "منون"], "متحرك"),
            ],
            # Lesson 1: التنوين
            1: [
                ("reading", "التنوين هو",
                 ["نون ساكنة تلحق آخر الاسم", "نون متحركة", "حرف مد", "علامة ترقيم"],
                 "نون ساكنة تلحق آخر الاسم"),
                ("reading", "كلمة (كتاباً) فيها تنوين",
                 ["فتح", "ضم", "كسر", "لا يوجد"], "فتح"),
                ("writing", "كلمة (طالبٌ) فيها تنوين",
                 ["فتح", "ضم", "كسر", "لا يوجد"], "ضم"),
                ("writing", "كلمة (بيتٍ) فيها تنوين",
                 ["فتح", "ضم", "كسر", "لا يوجد"], "كسر"),
                ("comprehension", "التنوين يأتي في",
                 ["الأسماء فقط", "الأفعال فقط", "الحروف فقط", "كل الكلمات"], "الأسماء فقط"),
            ],
            # Lesson 2: الشدة
            2: [
                ("reading", "الشدة تعني أن الحرف",
                 ["مكرر", "محذوف", "ساكن", "منون"], "مكرر"),
                ("writing", "كلمة (معلّم) عند فكها تصبح",
                 ["معلْلِم", "معلم", "معلوم", "معلام"], "معلْلِم"),
                ("comprehension", "الحرف المشدد ينطق",
                 ["مرتين", "مرة واحدة", "ثلاث مرات", "لا ينطق"], "مرتين"),
            ],
            # Lesson 3: اللام الشمسية والقمرية
            3: [
                ("reading", "اللام الشمسية",
                 ["لا تنطق", "تنطق", "تكتب فقط", "تحذف"], "لا تنطق"),
                ("reading", "كلمة (الشّمس) لامها",
                 ["شمسية", "قمرية", "لا تحتوي لام", "ليست لام تعريف"], "شمسية"),
                ("writing", "كلمة (القمر) لامها",
                 ["شمسية", "قمرية", "لا تحتوي لام", "ليست لام تعريف"], "قمرية"),
                ("comprehension", "كيف نعرف إذا اللام شمسية؟",
                 ["لا ننطق اللام", "ننطق اللام بوضوح", "نحذف اللام", "نضعف اللام"],
                 "لا ننطق اللام"),
                ("writing", "أي كلمة فيها لام شمسية؟",
                 ["الدّرس", "الكتاب", "العلم", "القلم"], "الدّرس"),
            ],
            # Lesson 4: الجمع والطرح
            4: [
                ("reading", "ناتج 345 + 237 =",
                 ["582", "572", "592", "562"], "582"),
                ("writing", "عند الجمع نبدأ من خانة",
                 ["الآحاد", "العشرات", "المئات", "الألوف"], "الآحاد"),
                ("comprehension", "إذا كان الناتج في خانة الآحاد أكبر من 9",
                 ["نكتب الآحاد ونحمل للعشرات", "نكتب العدد كاملاً", "نتوقف", "نبدأ من جديد"],
                 "نكتب الآحاد ونحمل للعشرات"),
            ],
            # Lesson 5: حالات المادة
            5: [
                ("reading", "كم حالة رئيسية للمادة؟",
                 ["ثلاث حالات", "حالتان", "أربع حالات", "خمس حالات"], "ثلاث حالات"),
                ("writing", "أي مما يلي مادة سائلة؟",
                 ["الماء", "الحجر", "الهواء", "الخشب"], "الماء"),
                ("comprehension", "ماذا يحدث للماء عند التبريد الشديد؟",
                 ["يتحول لثلج", "يتبخر", "يبقى سائلاً", "يختفي"], "يتحول لثلج"),
            ],
            # Lesson 6: آداب الطعام
            6: [
                ("reading", "ماذا نقول قبل الأكل؟",
                 ["بسم الله", "الحمد لله", "سبحان الله", "لا إله إلا الله"], "بسم الله"),
                ("writing", "الأكل يكون باليد",
                 ["اليمنى", "اليسرى", "كلتا اليدين", "لا يهم"], "اليمنى"),
                ("comprehension", "لماذا لا نسرف في الطعام؟",
                 ["لأن الله نهانا عن الإسراف", "لأن الطعام غالي", "لأننا لا نجوع", "لأن الطعام قليل"],
                 "لأن الله نهانا عن الإسراف"),
            ],
            # Lesson 7: الكسور العشرية
            7: [
                ("reading", "الكسر العشري 3/10 يكتب",
                 ["0.3", "0.03", "3.0", "0.003"], "0.3"),
                ("writing", "لمقارنة الكسور العشرية نقارن",
                 ["خانة بخانة من اليسار", "خانة بخانة من اليمين", "آخر خانة", "أول رقم فقط"],
                 "خانة بخانة من اليسار"),
                ("comprehension", "أيهما أكبر: 0.45 أم 0.39؟",
                 ["0.45", "0.39", "متساويان", "لا يمكن المقارنة"], "0.45"),
            ],
        }

        all_quizzes = []
        for lesson_idx, questions in quizzes_data.items():
            for qtype, qtext, opts, correct in questions:
                q = Quiz(
                    lesson_id=lessons[lesson_idx].id,
                    quiz_type=qtype,
                    question_text=qtext,
                    options=json.dumps(opts, ensure_ascii=False),
                    correct_answer=correct,
                )
                db.add(q)
                db.flush()
                all_quizzes.append(q)

        print(f"[OK] Quizzes: {len(all_quizzes)} created")

        # ═══════════════════════════════════════════════════
        # 4. LEARNING SESSIONS
        # ═══════════════════════════════════════════════════

        base_time = now_utc() - timedelta(days=7)

        sessions_data = [
            # سارة (student1) - 6 sessions
            (student1.id, lessons[0].id, "scan", 25, 0),
            (student1.id, lessons[1].id, "qr", 30, 1),
            (student1.id, lessons[2].id, "scan", 20, 2),
            (student1.id, lessons[3].id, "qr", 15, 3),
            (student1.id, lessons[5].id, "upload", 22, 4),
            (student1.id, lessons[6].id, "qr", 18, 5),
            # محمد (student2) - 4 sessions
            (student2.id, lessons[4].id, "qr", 30, 6),
            (student2.id, lessons[7].id, "scan", 25, 7),
            (student2.id, lessons[5].id, "upload", 20, 8),
            (student2.id, lessons[0].id, "qr", 15, 9),
        ]

        for sid, lid, stype, duration, offset in sessions_data:
            started = base_time + timedelta(days=offset, hours=14)
            sess = LearningSession(
                student_id=sid,
                lesson_id=lid,
                session_type=stype,
                started_at=started,
                ended_at=started + timedelta(minutes=duration),
                duration_minutes=duration,
            )
            db.add(sess)

        db.flush()
        print(f"[OK] Learning sessions: {len(sessions_data)} created")

        # ═══════════════════════════════════════════════════
        # 5. QUIZ RESULTS
        # ═══════════════════════════════════════════════════

        # سارة answered quizzes for lessons 0, 1, 3, 5
        s1_answers = [
            # Lesson 0 quizzes (5 questions) - scored 4/5
            (0, "الألف والواو والياء", True),
            (1, "الألف", True),
            (2, "الواو", True),
            (3, "الياء", True),
            (4, "ساكن", False),
            # Lesson 1 quizzes (5 questions) - scored 3/5
            (5, "نون ساكنة تلحق آخر الاسم", True),
            (6, "فتح", True),
            (7, "ضم", True),
            (8, "فتح", False),
            (9, "الأفعال فقط", False),
            # Lesson 3 quizzes (5 questions) - scored 5/5
            (10 + 3, "لا تنطق", True),    # quiz index offset for lesson 3
            (10 + 4, "شمسية", True),
            (10 + 5, "قمرية", True),
            (10 + 6, "لا ننطق اللام", True),
            (10 + 7, "الدّرس", True),
        ]

        # Need to map quiz indices properly
        # Lessons 0: quizzes 0-4, Lesson 1: 5-9, Lesson 2: 10-12, Lesson 3: 13-17
        # Lesson 4: 18-20, Lesson 5: 21-23, Lesson 6: 24-26, Lesson 7: 27-29
        s1_quiz_results = [
            # Lesson 0 - 4/5
            (0, "الألف والواو والياء", True),
            (1, "الألف", True),
            (2, "الواو", True),
            (3, "الياء", True),
            (4, "ساكن", False),
            # Lesson 1 - 3/5
            (5, "نون ساكنة تلحق آخر الاسم", True),
            (6, "فتح", True),
            (7, "ضم", True),
            (8, "فتح", False),
            (9, "الأفعال فقط", False),
            # Lesson 3 - 5/5
            (13, "لا تنطق", True),
            (14, "شمسية", True),
            (15, "قمرية", True),
            (16, "لا ننطق اللام", True),
            (17, "الدّرس", True),
            # Lesson 5 - 2/3
            (21, "ثلاث حالات", True),
            (22, "الماء", True),
            (23, "يتبخر", False),
        ]

        for qi, answer, correct in s1_quiz_results:
            if qi < len(all_quizzes):
                qr = QuizResult(
                    student_id=student1.id,
                    quiz_id=all_quizzes[qi].id,
                    selected_answer=answer,
                    is_correct=correct,
                    answered_at=base_time + timedelta(days=qi // 5, hours=14 + (qi % 5)),
                )
                db.add(qr)

        # محمد answered quizzes for lessons 4, 7
        s2_quiz_results = [
            # Lesson 4 - 3/3
            (18, "582", True),
            (19, "الآحاد", True),
            (20, "نكتب الآحاد ونحمل للعشرات", True),
            # Lesson 7 - 2/3
            (27, "0.3", True),
            (28, "خانة بخانة من اليسار", True),
            (29, "متساويان", False),
        ]

        for qi, answer, correct in s2_quiz_results:
            if qi < len(all_quizzes):
                qr = QuizResult(
                    student_id=student2.id,
                    quiz_id=all_quizzes[qi].id,
                    selected_answer=answer,
                    is_correct=correct,
                    answered_at=base_time + timedelta(days=5 + qi // 3, hours=15),
                )
                db.add(qr)

        db.flush()
        total_results = len(s1_quiz_results) + len(s2_quiz_results)
        print(f"[OK] Quiz results: {total_results} created")

        # ═══════════════════════════════════════════════════
        # 6. CHAT MESSAGES
        # ═══════════════════════════════════════════════════

        chats = [
            # سارة - حروف المد
            (student1.id, lessons[0].id, "user", "ما هي حروف المد؟"),
            (student1.id, lessons[0].id, "assistant",
             "حروف المد ثلاثة: الألف (ا) والواو (و) والياء (ي). تأتي بعد حرف متحرك لتمد الصوت."),
            (student1.id, lessons[0].id, "user", "ما الفرق بين المد بالألف والمد بالواو؟"),
            (student1.id, lessons[0].id, "assistant",
             "المد بالألف يأتي بعد فتحة مثل (كِتاب)، والمد بالواو يأتي بعد ضمة مثل (نُور). كل حرف مد يتبع حركة معينة."),
            # سارة - التنوين
            (student1.id, lessons[1].id, "user", "ما هو التنوين؟"),
            (student1.id, lessons[1].id, "assistant",
             "التنوين نون ساكنة تُضاف لآخر الاسم لفظاً لا كتابةً. له ثلاثة أنواع: فتح (كتاباً) وضم (كتابٌ) وكسر (كتابٍ)."),
            # سارة - حالات المادة
            (student1.id, lessons[5].id, "user", "لماذا الماء سائل؟"),
            (student1.id, lessons[5].id, "assistant",
             "الماء سائل لأن جزيئاته تتحرك بحرية لكنها متقاربة. لذلك له حجم ثابت لكن يأخذ شكل الإناء. إذا سخناه يتحول لبخار وإذا بردناه يتحول لثلج."),
            # محمد - الكسور العشرية
            (student2.id, lessons[7].id, "user", "كيف أقرأ الكسر العشري 0.25؟"),
            (student2.id, lessons[7].id, "assistant",
             "الكسر العشري 0.25 يُقرأ: صفر فاصلة خمسة وعشرون، أو خمسة وعشرون من مئة. يعني 25/100."),
            # محمد - الجمع والطرح
            (student2.id, lessons[4].id, "user", "كيف أجمع 456 + 328؟"),
            (student2.id, lessons[4].id, "assistant",
             "نبدأ من الآحاد: 6+8=14 نكتب 4 ونحمل 1. العشرات: 5+2+1=8. المئات: 4+3=7. الناتج: 784."),
        ]

        for i, (sid, lid, role, content) in enumerate(chats):
            cm = ChatMessage(
                student_id=sid,
                lesson_id=lid,
                role=role,
                content=content,
                created_at=base_time + timedelta(hours=i * 2),
            )
            db.add(cm)

        db.flush()
        print(f"[OK] Chat messages: {len(chats)} created")

        # ═══════════════════════════════════════════════════
        # 7. SYSTEM LOGS
        # ═══════════════════════════════════════════════════

        log_entries = [
            (admin_user.id, "system_startup", "success", {"version": "1.0.0"}),
            (admin_user.id, "user_login", "success", {"role": "admin"}),
            (parent_user.id, "user_login", "success", {"role": "parent", "ip": "192.168.1.10"}),
            (student_user.id, "user_login", "success", {"role": "student"}),
            (student_user.id, "scan_ocr", "success", {"file_size": 245000, "text_length": 150}),
            (student_user.id, "tts_generate", "success", {"text_length": 150}),
            (student_user.id, "chat_ask", "success", {"lesson": "حروف المد"}),
            (student_user.id, "quiz_submit", "success", {"quiz": "حروف المد - قراءة", "score": "4/5"}),
            (s2_user.id, "scan_qr", "success", {"qr_code": "QR_MATH_05"}),
            (parent_user.id, "view_child_report", "success", {"child": "سارة", "type": "weekly"}),
            (admin_user.id, "lesson_create", "success", {"title": "حروف المد"}),
            (student_user.id, "scan_ocr", "error", {"error": "image too blurry"}),
        ]

        for uid, action, status, details in log_entries:
            log = SystemLog(
                user_id=uid,
                action=action,
                status=status,
                details=json.dumps(details, ensure_ascii=False),
            )
            db.add(log)

        db.flush()
        print(f"[OK] System logs: {len(log_entries)} created")

        db.commit()

        # ═══════════════════════════════════════════════════
        # VERIFICATION
        # ═══════════════════════════════════════════════════
        print("\n" + "=" * 50)
        print("  SEED VERIFICATION")
        print("=" * 50)
        counts = {
            "users": db.query(User).count(),
            "students": db.query(Student).count(),
            "parents": db.query(Parent).count(),
            "admins": db.query(Admin).count(),
            "lessons": db.query(Lesson).count(),
            "quizzes": db.query(Quiz).count(),
            "quiz_results": db.query(QuizResult).count(),
            "chat_messages": db.query(ChatMessage).count(),
            "learning_sessions": db.query(LearningSession).count(),
            "system_logs": db.query(SystemLog).count(),
        }
        total = 0
        for table, count in counts.items():
            print(f"  {table:25s} {count}")
            total += count
        print(f"  {'TOTAL':25s} {total}")

        print("\n" + "=" * 50)
        print("  FIREBASE AUTH TEST ACCOUNTS")
        print("=" * 50)
        print("  Student: student@diyaa.test / Test123456")
        print(f"    UID: {FB_STUDENT}")
        print(f"    Name: سارة الطالبة | Grade: الثالث | Progress: 72.5%")
        print()
        print("  Parent:  parent@diyaa.test  / Test123456")
        print(f"    UID: {FB_PARENT}")
        print(f"    Name: أحمد ولي الأمر | Children: سارة, محمد")

        print("\n" + "=" * 50)
        print("  QR CODES FOR TESTING")
        print("=" * 50)
        for lesson in lessons:
            print(f"  {lesson.qr_code:15s} -> {lesson.title}")

        print("\n[DONE] Seed complete!")

    except Exception as e:
        db.rollback()
        print(f"[ERROR] {e}")
        raise
    finally:
        db.close()


if __name__ == "__main__":
    seed()
