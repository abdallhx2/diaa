from pydantic import BaseModel
from typing import List, Optional
from decimal import Decimal


class WeeklyReport(BaseModel):
    lessons_completed: int = 0
    quizzes_taken: int = 0
    study_time_hours: Decimal = Decimal("0")
    progress_percentage: Decimal = Decimal("0")
    avg_quiz_score: Decimal = Decimal("0")
    daily_streak: int = 0
    recent_activities: List[dict] = []


class MonthlyReport(BaseModel):
    lessons_completed: int = 0
    quizzes_taken: int = 0
    study_time_hours: Decimal = Decimal("0")
    progress_percentage: Decimal = Decimal("0")
    avg_quiz_score: Decimal = Decimal("0")
    daily_streak: int = 0
    recent_activities: List[dict] = []
    trends: dict = {}


class ChildReport(BaseModel):
    child_name: str
    grade: str
    learning_level: str
    progress_score: Decimal = Decimal("0")
    total_sessions: int = 0
    total_quizzes: int = 0
