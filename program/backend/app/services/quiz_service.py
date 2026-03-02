# ============================================================
# File: services/quiz_service.py
# Purpose: خدمة الاختبارات — منطق الأسئلة والإجابات وحساب الدرجات
# Owner: فدوه — AI Chat + Quiz Logic
# Branch: feature/ai-chat
# Week: Week 2 — بناء نظام الاختبارات
# ============================================================

# --- Required Imports ---
# import random
# from sqlalchemy.orm import Session
# from app.database import SessionLocal
# from app.models.quiz import Quiz
# from app.models.quiz_result import QuizResult
# from app.utils.helpers import generate_uuid, get_current_timestamp

# --- Implementation Steps ---

# Step 1: دالة get_quizzes_for_lesson(lesson_id: UUID, quiz_type: str = None) -> list
# - اجلبي الاختبارات من DB:
#   - query = db.query(Quiz).filter(Quiz.lesson_id == lesson_id)
#   - لو quiz_type محدد: query = query.filter(Quiz.quiz_type == quiz_type)
# - حولي النتائج لـ list of dicts
# - عشوئي ترتيب الأسئلة:
#   - random.shuffle(quizzes)
# - ملاحظة: لا ترجعي correct_answer!
# - ارجعي القائمة

# Step 2: دالة submit_quiz(student_id: UUID, quiz_id: UUID, answers: list) -> dict
# - اجلبي الاختبار من DB بـ quiz_id
# - لو ما لقيتيه — ارمي Exception
# - استدعي calculate_score(answers, quiz.correct_answer)
# - أنشئي QuizResult:
#   - result = QuizResult(
#       id=generate_uuid(),
#       student_id=student_id,
#       quiz_id=quiz_id,
#       score=calculated_score,
#       answers_detail=answers_detail_json,
#       taken_at=get_current_timestamp()
#   )
# - db.add(result) → db.commit()
# - ارجعي النتيجة

# Step 3: دالة calculate_score(answers: list, correct_answers: list) -> tuple(score, details)
# - قارني كل إجابة مع الإجابة الصحيحة
# - احسبي عدد الإجابات الصحيحة
# - احسبي النسبة المئوية: score = (correct_count / total_count) * 100
# - أنشئي answers_detail:
#   - [{"question": "...", "student_answer": "...", "correct_answer": "...", "is_correct": True/False}, ...]
# - ارجعي (score, answers_detail)

# Step 4: دالة get_student_results(student_id: UUID) -> list
# - اجلبي جميع نتائج الطالب من quiz_results:
#   - results = db.query(QuizResult).filter(QuizResult.student_id == student_id).order_by(QuizResult.taken_at.desc()).all()
# - حولي لـ list of dicts
# - ارجعي القائمة

# --- Dependencies ---
# - app/database.py (SessionLocal)
# - app/models/quiz.py (Quiz model)
# - app/models/quiz_result.py (QuizResult model)
# - app/utils/helpers.py (generate_uuid, get_current_timestamp)

# --- Notes ---
# - الأسئلة تتعشوأ عشان ما يحفظ الطالب الترتيب
# - calculate_score ترجع النسبة المئوية + تفاصيل كل إجابة
# - answers_detail يساعد الطالب يعرف وش غلط فيه
# - لا ترجعي correct_answer في get_quizzes_for_lesson (قبل التسليم)
# - بعد التسليم، QuizResultResponse يعرض التفاصيل كاملة
