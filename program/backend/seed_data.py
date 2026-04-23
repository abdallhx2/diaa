from app.database import SessionLocal
from app.models.lesson import Lesson
from app.models.quiz import Quiz, QuizType
import uuid
 
 
def seed_lessons():
    db = SessionLocal()
    lessons = [
        Lesson(
            id=uuid.uuid4(),
            title="أسرتي",
            subject="لغتي",
            grade_level="الصف الأول",
            original_text="أسرتي صغيرة ومحبوبة. أبي يعمل ويرعانا، وأمي تهتم بنا وتطعمنا. لي أخ وأخت نلعب معاً ونتعاون. نحب أسرتنا ونحافظ عليها. الأسرة هي أهم شيء في حياتنا.",
            qr_code="QR001"
        ),
        Lesson(
            id=uuid.uuid4(),
            title="عذراً يا جدي",
            subject="لغتي",
            grade_level="الصف الثاني",
            original_text="في حصة القراءة، رأى المعلم فوازاً يجلس حزيناً. سأله المعلم عن سبب حزنه، فأخبره أن جده طلب منه أن يخفض صوت التلفاز فلم يفعل، فغضب منه الجد. قال المعلم: لقد أخطأت يا فواز، عليك أن تعتذر لجدك وتطلب منه السماح. قال فواز: ليت جدي يسامحني! قال المعلم: الجد عطوف حنون وسيسامحك، ولكن احرص على طاعة جدك دائماً.",
            qr_code="QR002"
        ),
        Lesson(
            id=uuid.uuid4(),
            title="عادل في الطائرة",
            subject="لغتي",
            grade_level="الصف الثالث",
            original_text="دخل الوالد حاملاً تذاكر السفر، فاستقبلته الأسرة بفرح. في صالة الانتظار رأى عادل امرأة تحمل طفلاً لم تجد مكاناً تجلس فيه، فقام عادل من مقعده وأجلسها. وفي الطائرة رأى أطفالاً يركضون في الممرات ويعبثون، فقال لهم: الطائرة ليست مكاناً للعب. أحسنت يا عادل، فالمسلم يتحلى بحسن الأخلاق في كل مكان.",
            qr_code="QR003"
        ),
        Lesson(
            id=uuid.uuid4(),
            title="النباتات مخلوقات حية",
            subject="علوم",
            grade_level="الصف الأول",
            original_text="النباتات مخلوقات حية تعيش من حولنا. تحتاج النباتات إلى الماء والهواء وضوء الشمس لتنمو. للنبات أجزاء مهمة: الجذر يثبت النبات في التربة ويمتص الماء، والساق تحمل الماء والغذاء إلى الأوراق، والأوراق تصنع غذاء النبات بمساعدة الشمس.",
            qr_code="QR004"
        ),
        Lesson(
            id=uuid.uuid4(),
            title="حاجات المخلوقات الحية",
            subject="علوم",
            grade_level="الصف الثاني",
            original_text="تحتاج المخلوقات الحية إلى أشياء مهمة للبقاء على قيد الحياة. أولاً الغذاء: تحتاجه لتنمو وتتحرك. ثانياً الماء: يدخل في تركيب أجسام جميع المخلوقات. ثالثاً الهواء: تحتاجه جميع المخلوقات الحية للتنفس. وأخيراً المكان المناسب: يوفر لها الدفء والأمان.",
            qr_code="QR005"
        ),
        Lesson(
            id=uuid.uuid4(),
            title="ما الذي تحتاجه المخلوقات الحية؟",
            subject="علوم",
            grade_level="الصف الثالث",
            original_text="للمخلوقات الحية حاجات متعددة منها: الغذاء والماء والمكان للعيش. وإذا لم تتوفر هذه الحاجات فإنها تموت. ويُسمى المكان الذي يعيش فيه المخلوق الحي البيئة. تحصل الحيوانات على الماء من البيئة المحيطة بها، أما النباتات فتمتص الماء من التربة عبر جذورها.",
            qr_code="QR006"
        ),
    ]
    db.add_all(lessons)
    db.commit()
    print(f"✅ تم إضافة {len(lessons)} دروس")
    return lessons, db
 
 
def seed_quizzes(lessons, db):
    quizzes = [
 
        # أسرتي - الصف الأول
        Quiz(id=uuid.uuid4(), lesson_id=lessons[0].id, quiz_type=QuizType.comprehension,
             question_text="من يرعى الأسرة ويعمل لأجلها؟",
             options={"أ": "الأخ", "ب": "الأب", "ج": "الأم", "د": "الأخت"},
             correct_answer="ب"),
        Quiz(id=uuid.uuid4(), lesson_id=lessons[0].id, quiz_type=QuizType.comprehension,
             question_text="ماذا يفعل الأخ والأخت معاً؟",
             options={"أ": "يتشاجران", "ب": "يناموان", "ج": "يلعبان ويتعاونان", "د": "يذهبان للعمل"},
             correct_answer="ج"),
        Quiz(id=uuid.uuid4(), lesson_id=lessons[0].id, quiz_type=QuizType.comprehension,
             question_text="ما أهم شيء في حياتنا حسب النص؟",
             options={"أ": "اللعب", "ب": "المدرسة", "ج": "الأصدقاء", "د": "الأسرة"},
             correct_answer="د"),
 
        # عذراً يا جدي - الصف الثاني
        Quiz(id=uuid.uuid4(), lesson_id=lessons[1].id, quiz_type=QuizType.comprehension,
             question_text="لماذا كان فواز حزيناً؟",
             options={"أ": "لأنه خسر في اللعبة", "ب": "لأنه لم يطع جده", "ج": "لأنه نسي واجبه", "د": "لأنه مريض"},
             correct_answer="ب"),
        Quiz(id=uuid.uuid4(), lesson_id=lessons[1].id, quiz_type=QuizType.comprehension,
             question_text="ماذا نصح المعلم فوازاً؟",
             options={"أ": "أن يشاهد التلفاز", "ب": "أن يتجاهل جده", "ج": "أن يعتذر لجده", "د": "أن يذهب للنوم"},
             correct_answer="ج"),
        Quiz(id=uuid.uuid4(), lesson_id=lessons[1].id, quiz_type=QuizType.comprehension,
             question_text="كيف وصف المعلم الجد؟",
             options={"أ": "غاضب وقاسي", "ب": "عطوف وحنون", "ج": "صارم وجاد", "د": "مشغول دائماً"},
             correct_answer="ب"),
 
        # عادل في الطائرة - الصف الثالث
        Quiz(id=uuid.uuid4(), lesson_id=lessons[2].id, quiz_type=QuizType.comprehension,
             question_text="ماذا أحضر الوالد للأسرة؟",
             options={"أ": "هدايا", "ب": "تذاكر السفر", "ج": "طعاماً", "د": "ألعاباً"},
             correct_answer="ب"),
        Quiz(id=uuid.uuid4(), lesson_id=lessons[2].id, quiz_type=QuizType.comprehension,
             question_text="ماذا فعل عادل حين رأى المرأة التي لا تجد مقعداً؟",
             options={"أ": "تجاهلها", "ب": "أخبر المضيف", "ج": "قام من مقعده وأجلسها", "د": "طلب منها الوقوف"},
             correct_answer="ج"),
        Quiz(id=uuid.uuid4(), lesson_id=lessons[2].id, quiz_type=QuizType.comprehension,
             question_text="ماذا قال عادل للأطفال الذين يركضون؟",
             options={"أ": "العبوا بهدوء", "ب": "الطائرة ليست مكاناً للعب", "ج": "اذهبوا لأماكنكم", "د": "اسألوا المضيف"},
             correct_answer="ب"),
 
        # النباتات مخلوقات حية - الصف الأول
        Quiz(id=uuid.uuid4(), lesson_id=lessons[3].id, quiz_type=QuizType.comprehension,
             question_text="ماذا يحتاج النبات لينمو؟",
             options={"أ": "الماء فقط", "ب": "الماء والهواء وضوء الشمس", "ج": "الهواء فقط", "د": "الظلام والماء"},
             correct_answer="ب"),
        Quiz(id=uuid.uuid4(), lesson_id=lessons[3].id, quiz_type=QuizType.comprehension,
             question_text="ما وظيفة الجذر في النبات؟",
             options={"أ": "صنع الغذاء", "ب": "تثبيت النبات وامتصاص الماء", "ج": "جذب الشمس", "د": "حمل الثمار"},
             correct_answer="ب"),
        Quiz(id=uuid.uuid4(), lesson_id=lessons[3].id, quiz_type=QuizType.comprehension,
             question_text="أين تصنع الأوراق الغذاء للنبات؟",
             options={"أ": "في الجذر", "ب": "في الساق", "ج": "بمساعدة الشمس", "د": "في التربة"},
             correct_answer="ج"),
 
        # حاجات المخلوقات الحية - الصف الثاني
        Quiz(id=uuid.uuid4(), lesson_id=lessons[4].id, quiz_type=QuizType.comprehension,
             question_text="ما الحاجات الأساسية للمخلوقات الحية؟",
             options={"أ": "الغذاء والماء والهواء والمكان المناسب", "ب": "الغذاء فقط", "ج": "الماء والهواء فقط", "د": "المكان والغذاء فقط"},
             correct_answer="أ"),
        Quiz(id=uuid.uuid4(), lesson_id=lessons[4].id, quiz_type=QuizType.comprehension,
             question_text="لماذا تحتاج المخلوقات الحية للهواء؟",
             options={"أ": "للسباحة", "ب": "للتنفس", "ج": "للأكل", "د": "للنوم"},
             correct_answer="ب"),
        Quiz(id=uuid.uuid4(), lesson_id=lessons[4].id, quiz_type=QuizType.comprehension,
             question_text="ماذا يوفر المكان المناسب للمخلوق الحي؟",
             options={"أ": "الغذاء فقط", "ب": "الماء فقط", "ج": "الدفء والأمان", "د": "الهواء فقط"},
             correct_answer="ج"),
 
        # ما الذي تحتاجه المخلوقات الحية - الصف الثالث
        Quiz(id=uuid.uuid4(), lesson_id=lessons[5].id, quiz_type=QuizType.comprehension,
             question_text="ما اسم المكان الذي يعيش فيه المخلوق الحي؟",
             options={"أ": "الوطن", "ب": "البيئة", "ج": "الحديقة", "د": "الغابة"},
             correct_answer="ب"),
        Quiz(id=uuid.uuid4(), lesson_id=lessons[5].id, quiz_type=QuizType.comprehension,
             question_text="كيف تحصل النباتات على الماء؟",
             options={"أ": "من الهواء", "ب": "من الأمطار على أوراقها", "ج": "تمتصه من التربة عبر جذورها", "د": "من الشمس"},
             correct_answer="ج"),
        Quiz(id=uuid.uuid4(), lesson_id=lessons[5].id, quiz_type=QuizType.comprehension,
             question_text="ماذا يحدث للمخلوق الحي إذا لم تتوفر حاجاته؟",
             options={"أ": "يتكيف ويعيش", "ب": "يهاجر لمكان آخر", "ج": "يموت", "د": "ينام فقط"},
             correct_answer="ج"),
    ]
    db.add_all(quizzes)
    db.commit()
    print(f"✅ تم إضافة {len(quizzes)} سؤال")
    db.close()
 
 
if __name__ == "__main__":
    lessons, db = seed_lessons()
    seed_quizzes(lessons, db)
    print("🎉 اكتمل seed_data.py بنجاح!")
 