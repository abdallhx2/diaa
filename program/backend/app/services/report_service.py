# ============================================================
# File: services/report_service.py
# Purpose: خدمة التقارير — توليد تقارير أسبوعية وشهرية لولي الأمر
# Owner: فدوه — AI Chat + Quiz Logic
# Branch: feature/ai-chat
# Week: Week 3 — بناء نظام التقارير
# ============================================================

# --- Required Imports ---
# from datetime import datetime, timedelta
# from sqlalchemy.orm import Session
# from sqlalchemy import func
# from app.database import SessionLocal
# from app.models.learning_session import LearningSession
# from app.models.quiz_result import QuizResult
# from app.models.chat_message import ChatMessage

# --- Implementation Steps ---

# Step 1: دالة get_weekly_report(student_id: UUID) -> dict
# - حددي نطاق الأسبوع:
#   - week_start = datetime.now() - timedelta(days=7)
# - اجلبي جلسات التعلم في هذا الأسبوع:
#   - sessions = db.query(LearningSession).filter(
#       LearningSession.student_id == student_id,
#       LearningSession.started_at >= week_start
#   ).all()
# - اجلبي نتائج الاختبارات في هذا الأسبوع:
#   - quiz_results = db.query(QuizResult).filter(
#       QuizResult.student_id == student_id,
#       QuizResult.taken_at >= week_start
#   ).all()
# - احسبي:
#   - lessons_completed: عدد الجلسات المكتملة (ended_at != None)
#   - quizzes_taken: عدد الاختبارات (len(quiz_results))
#   - study_time_hours: مجموع duration_minutes / 60
#   - progress_percentage: (lessons_completed / total_available_lessons) * 100
#   - avg_quiz_score: متوسط score من quiz_results
#   - daily_streak: عدد الأيام المتتالية اللي فيها جلسات
# - اجلبي recent_activities (آخر 10 أنشطة مرتبة بالأحدث)
# - ارجعي WeeklyReport dict

# Step 2: دالة get_monthly_report(student_id: UUID) -> dict
# - نفس منطق get_weekly_report بس بنطاق 30 يوم:
#   - month_start = datetime.now() - timedelta(days=30)
# - أضيفي حقل trends:
#   - قسمي الشهر لـ 4 أسابيع
#   - احسبي درجات كل أسبوع
#   - حددي الاتجاه:
#     - score_trend: "improving" لو الدرجات تتحسن، "declining" لو تنخفض، "stable" لو ثابتة
#     - study_time_trend: نفس المنطق لوقت الدراسة
#     - weekly_scores: قائمة بمتوسط الدرجات لكل أسبوع
# - ارجعي MonthlyReport dict

# --- Helper: حساب daily_streak ---
# - اجلبي تواريخ الجلسات (unique dates)
# - ابدئي من اليوم وامشي للخلف
# - عدي الأيام المتتالية اللي فيها جلسات
# - مثال: لو درس اليوم وأمس وأول أمس = streak = 3

# --- Dependencies ---
# - app/database.py (SessionLocal)
# - app/models/learning_session.py (LearningSession model)
# - app/models/quiz_result.py (QuizResult model)
# - app/models/chat_message.py (ChatMessage model)

# --- Notes ---
# - التقارير تُعرض لولي الأمر في GET /api/parent/reports/{child_id}/weekly و /monthly
# - daily_streak يحفز الطالب على الاستمرار
# - trends في التقرير الشهري يساعد ولي الأمر يفهم اتجاه تقدم طفله
# - استخدمي SQL aggregation functions (COUNT, AVG, SUM) عشان الأداء
# - لو ما فيه بيانات — ارجعي قيم صفرية (مو خطأ)
