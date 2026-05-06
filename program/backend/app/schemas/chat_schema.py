from pydantic import BaseModel
from typing import List, Optional
from uuid import UUID
from datetime import datetime


class ChatRequest(BaseModel):
    question: str
    lesson_id: Optional[UUID] = None


class ChatResponse(BaseModel):
    answer: str
    audio_url: Optional[str] = None


class ChatHistoryItem(BaseModel):
    role: str
    content: str
    created_at: datetime

    model_config = {"from_attributes": True}


class ChatHistoryResponse(BaseModel):
    messages: List[ChatHistoryItem]
