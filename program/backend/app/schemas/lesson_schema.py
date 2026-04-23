from pydantic import BaseModel
from typing import Optional
from uuid import UUID
from datetime import datetime

class LessonCreate(BaseModel):
    title: str
    subject: str
    grade_level: str
    original_text: str
    qr_code: Optional[str] = None

class LessonResponse(BaseModel):
    id: UUID
    title: str
    subject: str
    grade_level: str
    original_text: str
    qr_code: Optional[str]
    audio_url: Optional[str]
    created_at: datetime

    model_config = {"from_attributes": True}

class LessonUpdate(BaseModel):
    title: Optional[str] = None
    subject: Optional[str] = None
    grade_level: Optional[str] = None
    original_text: Optional[str] = None