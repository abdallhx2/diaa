from pydantic import BaseModel
from typing import List, Optional
from uuid import UUID
from datetime import datetime


class QuizCreate(BaseModel):
    lesson_id: UUID
    quiz_type: str
    question_text: str
    options: List[str]
    correct_answer: str


class QuizResponse(BaseModel):
    id: UUID
    lesson_id: UUID
    quiz_type: str
    question_text: str
    options: List[str]
    created_at: Optional[datetime] = None

    model_config = {"from_attributes": True}


class QuizSubmit(BaseModel):
    quiz_id: UUID
    selected_answer: str


class QuizResultResponse(BaseModel):
    id: UUID
    quiz_id: UUID
    selected_answer: str
    is_correct: bool
    answered_at: datetime

    model_config = {"from_attributes": True}
