# ============================================================
# File: schemas/report_schema.py
# Purpose: مخططات التقارير — تقارير أسبوعية وشهرية لولي الأمر
# Owner: رنيم — API Developer
# Branch: feature/backend-routers
# Week: Week 2 — إعداد الـ schemas
# ============================================================

# --- Required Imports ---
# from pydantic import BaseModel
# from typing import List, Optional
# from decimal import Decimal

# --- Implementation Steps ---

# Step 1: WeeklyReport — التقرير الأسبوعي للطالب
# - class WeeklyReport(BaseModel):
#     - lessons_completed: int        — عدد الدروس المكتملة هذا الأسبوع
#     - quizzes_taken: int            — عدد الاختبارات المقدمة هذا الأسبوع
#     - study_time_hours: Decimal     — إجمالي وقت الدراسة بالساعات
#     - progress_percentage: Decimal  — نسبة التقدم هذا الأسبوع
#     - avg_quiz_score: Decimal       — متوسط درجات الاختبارات
#     - daily_streak: int             — عدد الأيام المتتالية للدراسة
#     - recent_activities: List[dict] — آخر الأنشطة، كل نشاط يحتوي على:
#       # {
#       #   "type": "quiz" | "lesson" | "chat",
#       #   "title": "اسم النشاط",
#       #   "date": "2026-03-01",
#       #   "score": 85.0  (للاختبارات فقط)
#       # }

# Step 2: MonthlyReport — التقرير الشهري للطالب (نفس الحقول + trends)
# - class MonthlyReport(BaseModel):
#     - lessons_completed: int
#     - quizzes_taken: int
#     - study_time_hours: Decimal
#     - progress_percentage: Decimal
#     - avg_quiz_score: Decimal
#     - daily_streak: int
#     - recent_activities: List[dict]
#     - trends: dict                  — اتجاهات الأداء، مثال:
#       # {
#       #   "score_trend": "improving" | "declining" | "stable",
#       #   "study_time_trend": "increasing" | "decreasing" | "stable",
#       #   "weekly_scores": [80, 85, 90, 88]  — درجات الأسابيع الأربعة
#       # }

# --- Dependencies ---
# - لا يعتمد على ملفات أخرى (schemas مستقلة)

# --- Notes ---
# - WeeklyReport يُستخدم في GET /api/parent/reports/{child_id}/weekly
# - MonthlyReport يُستخدم في GET /api/parent/reports/{child_id}/monthly
# - daily_streak = عدد الأيام المتتالية اللي الطالب درس فيها بدون انقطاع
# - trends في MonthlyReport تساعد ولي الأمر يفهم اتجاه تقدم الطالب
