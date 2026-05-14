from pydantic import BaseModel
from typing import Optional, List
from uuid import UUID
from decimal import Decimal
from datetime import datetime


class StudentCreate(BaseModel):
    user_id: UUID
    parent_id: Optional[UUID] = None
    age: Optional[int] = None
    grade: str
    learning_level: str = "مبتدئ"


class StudentUpdate(BaseModel):
    age: Optional[int] = None
    grade: Optional[str] = None
    learning_level: Optional[str] = None


class StudentResponse(BaseModel):
    id: UUID
    name: Optional[str] = None
    age: Optional[int] = None
    grade: str
    learning_level: str
    progress_score: Decimal

    model_config = {"from_attributes": True}


class SessionStartRequest(BaseModel):
    lesson_id: UUID
    session_type: Optional[str] = "scan"


class SessionResponse(BaseModel):
    id: UUID
    student_id: UUID
    lesson_id: UUID
    session_type: str
    started_at: Optional[datetime] = None
    ended_at: Optional[datetime] = None
    duration_minutes: Optional[int] = None

    model_config = {"from_attributes": True}


class StudentDashboard(BaseModel):
    student_info: StudentResponse
    recent_sessions: List[dict]
    recent_quizzes: List[dict]
    progress_score: Decimal
