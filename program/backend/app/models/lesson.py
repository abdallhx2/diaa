import uuid
from datetime import datetime, timezone
from sqlalchemy import Column, String, Text, DateTime
from sqlalchemy.orm import relationship
from app.database import Base
from app.models.compat import PortableUUID


class Lesson(Base):
    __tablename__ = "lessons"

    id = Column(PortableUUID(), primary_key=True, default=uuid.uuid4)
    title = Column(String(200), nullable=False)
    subject = Column(String(100), nullable=True)
    grade_level = Column(String(20), nullable=True)
    original_text = Column(Text, nullable=False)
    qr_code = Column(String(100), nullable=True)
    audio_url = Column(String(500), nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    sessions = relationship("LearningSession", back_populates="lesson")
    quizzes = relationship("Quiz", back_populates="lesson")
    chat_messages = relationship("ChatMessage", back_populates="lesson")
