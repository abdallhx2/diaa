import uuid
from datetime import datetime, timezone
from sqlalchemy import Column, String, Text, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base
from app.models.compat import PortableUUID


class ChatMessage(Base):
    __tablename__ = "chat_messages"

    id = Column(PortableUUID(), primary_key=True, default=uuid.uuid4)
    student_id = Column(PortableUUID(), ForeignKey("students.id"), nullable=False)
    lesson_id = Column(PortableUUID(), ForeignKey("lessons.id"), nullable=True)
    role = Column(String(10), nullable=False)  # 'user' or 'assistant'
    content = Column(Text, nullable=False)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    student = relationship("Student", back_populates="chat_messages")
    lesson = relationship("Lesson", back_populates="chat_messages")
