"""Idempotent lesson + quiz seed script. Run from backend/ directory."""
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.database import SessionLocal
from app.models.lesson import Lesson
from app.models.quiz import Quiz, QuizType

LESSONS = [
    {
        "title": "أسرتي الحبيبة",
        "subject": "لغتي",
        "grade_level": "الثالث",
        "original_text": (
            "الأسرة هي أساس المجتمع، وتتكوّن من الأب والأم والأبناء، "
            "وقد يكون فيها الأجداد والأعمام والعمات. تعيش الأسرة في بيت واحد "
            "وتتعاون في أعمال البيت وتتشارك في الأفراح والأتراح.\n\n"
            "للأسرة دور كبير في تنشئة الأبناء تنشئةً سليمة، إذ يتعلّم الطفل "
            "من والديه قيم الصدق والاحترام والمحبة. وحين يكبر الأبناء يردّون "
            "الجميل بخدمة والديهم والاعتناء بهم."
        ),
        "quizzes": [
            {
                "question_text": "ممّ تتكوّن الأسرة؟",
                "options": {"a": "الأب والأم والأبناء", "b": "المعلم والطلاب", "c": "الجيران", "d": "الأصدقاء"},
                "correct_answer": "a",
            },
            {
                "question_text": "أين تعيش الأسرة عادةً؟",
                "options": {"a": "في المدرسة", "b": "في بيت واحد", "c": "في المسجد", "d": "في السوق"},
                "correct_answer": "b",
            },
            {
                "question_text": "ماذا يتعلّم الطفل من والديه؟",
                "options": {"a": "اللعب فقط", "b": "قيم الصدق والاحترام والمحبة", "c": "الطبخ فقط", "d": "القيادة"},
                "correct_answer": "b",
            },
        ],
    },
    {
        "title": "فصل الربيع",
        "subject": "لغتي",
        "grade_level": "الثالث",
        "original_text": (
            "الربيع فصلٌ جميل يأتي بعد الشتاء، تتفتّح فيه الأزهار وتخضرّ الأشجار "
            "وتعود الطيور من رحلاتها البعيدة. تعتدل درجات الحرارة وتهبّ النسمات "
            "الباردة المنعشة.\n\n"
            "يحبّ كثير من الناس فصل الربيع لأنه يمنحهم طاقةً وحيويةً. يخرج الأطفال "
            "للعب في الحدائق ويستمتعون بالألوان الزاهية للزهور. ويهتمّ الفلاحون "
            "بزراعة أراضيهم استعداداً لموسم الحصاد."
        ),
        "quizzes": [
            {
                "question_text": "متى يأتي فصل الربيع؟",
                "options": {"a": "قبل الصيف مباشرةً", "b": "بعد الشتاء", "c": "بعد الخريف", "d": "قبل الشتاء"},
                "correct_answer": "b",
            },
            {
                "question_text": "ماذا يحدث للأشجار في فصل الربيع؟",
                "options": {"a": "تتساقط أوراقها", "b": "تجفّ", "c": "تخضرّ", "d": "لا يحدث لها شيء"},
                "correct_answer": "c",
            },
            {
                "question_text": "ماذا يفعل الأطفال في الربيع؟",
                "options": {"a": "يجلسون في البيت", "b": "يلعبون في الحدائق", "c": "يذهبون للسوق", "d": "ينامون كثيراً"},
                "correct_answer": "b",
            },
        ],
    },
    {
        "title": "النباتات من حولنا",
        "subject": "العلوم",
        "grade_level": "الثالث",
        "original_text": (
            "النباتات كائنات حيّة تنمو في التربة وتحتاج إلى الماء والضوء والهواء لتعيش. "
            "تصنع النباتات غذاءها بنفسها عن طريق عملية تسمى التركيب الضوئي، إذ تمتصّ "
            "ضوء الشمس وثاني أكسيد الكربون وتُنتج الأكسجين الذي نتنفّسه.\n\n"
            "تنقسم النباتات إلى نباتات مزهرة كالورد والياسمين، ونباتات غير مزهرة "
            "كالأشجار الصنوبرية. وللنبات أجزاء رئيسية هي: الجذر الذي يمتصّ الماء، "
            "والساق التي تحمل الغذاء والماء، والأوراق التي تصنع الغذاء، والزهرة "
            "التي تُنتج البذور."
        ),
        "quizzes": [
            {
                "question_text": "ما الذي تحتاجه النباتات لتعيش؟",
                "options": {"a": "الماء والضوء والهواء", "b": "الماء فقط", "c": "الضوء فقط", "d": "التربة فقط"},
                "correct_answer": "a",
            },
            {
                "question_text": "ما الغاز الذي تُنتجه النباتات ونحن نتنفّسه؟",
                "options": {"a": "ثاني أكسيد الكربون", "b": "النيتروجين", "c": "الأكسجين", "d": "البخار"},
                "correct_answer": "c",
            },
            {
                "question_text": "ما وظيفة الجذر في النبات؟",
                "options": {"a": "صنع الغذاء", "b": "امتصاص الماء", "c": "إنتاج البذور", "d": "حمل الأوراق"},
                "correct_answer": "b",
            },
        ],
    },
    {
        "title": "حالات الماء",
        "subject": "العلوم",
        "grade_level": "الثالث",
        "original_text": (
            "الماء مادة عجيبة يمكن أن توجد في ثلاث حالات: الحالة السائلة كالماء الذي "
            "نشربه، والحالة الصلبة كالجليد، والحالة الغازية كبخار الماء. تتغيّر حالة "
            "الماء بتأثير درجة الحرارة.\n\n"
            "عندما يُسخَّن الماء يتحوّل إلى بخار، وهذه العملية تسمى التبخّر. وعندما "
            "يبرد البخار يتحوّل إلى ماء سائل، وتسمى التكثّف. أمّا عندما تنخفض درجة "
            "الحرارة إلى الصفر المئوي أو ما دونه فيتجمّد الماء ويصبح جليداً."
        ),
        "quizzes": [
            {
                "question_text": "كم حالة يمكن أن يكون عليها الماء؟",
                "options": {"a": "حالة واحدة", "b": "حالتان", "c": "ثلاث حالات", "d": "أربع حالات"},
                "correct_answer": "c",
            },
            {
                "question_text": "ما اسم العملية التي يتحوّل فيها الماء إلى بخار؟",
                "options": {"a": "التجمّد", "b": "التكثّف", "c": "التبخّر", "d": "الذوبان"},
                "correct_answer": "c",
            },
            {
                "question_text": "عند أيّ درجة حرارة يتجمّد الماء؟",
                "options": {"a": "١٠٠ مئوي", "b": "٠ مئوي", "c": "٥٠ مئوي", "d": "٢٥ مئوي"},
                "correct_answer": "b",
            },
        ],
    },
]


def seed():
    db = SessionLocal()
    try:
        for lesson_data in LESSONS:
            quizzes_data = lesson_data.pop("quizzes")
            existing = db.query(Lesson).filter(Lesson.title == lesson_data["title"]).first()
            if existing:
                print(f"[SKIP] {lesson_data['title']} already exists")
                lesson_data["quizzes"] = quizzes_data
                continue

            lesson = Lesson(**lesson_data)
            db.add(lesson)
            db.flush()

            for q in quizzes_data:
                quiz = Quiz(
                    lesson_id=lesson.id,
                    quiz_type=QuizType.comprehension,
                    question_text=q["question_text"],
                    options=q["options"],
                    correct_answer=q["correct_answer"],
                )
                db.add(quiz)

            print(f"[SEED] {lesson.title} (id={lesson.id})")
            lesson_data["quizzes"] = quizzes_data

        db.commit()
        print("[DONE] Seed complete")
    except Exception as e:
        db.rollback()
        print(f"[ERROR] {e}")
        raise
    finally:
        db.close()


if __name__ == "__main__":
    seed()
