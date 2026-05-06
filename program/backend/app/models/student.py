import uuid
from datetime import datetime, timezone
from sqlalchemy import Column, String, Integer, Numeric, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from app.database import Base
from app.models.compat import PortableUUID


class Student(Base):
    __tablename__ = "students"

    id = Column(PortableUUID(), primary_key=True, default=uuid.uuid4)
    user_id = Column(PortableUUID(), ForeignKey("users.id"), unique=True, nullable=False)
    parent_id = Column(PortableUUID(), ForeignKey("parents.id"), nullable=True)
    age = Column(Integer, nullable=True)
    grade = Column(String(20), nullable=False)
    learning_level = Column(String(50), default="مبتدئ")
    progress_score = Column(Numeric(5, 2), default=0)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    user = relationship("User", back_populates="student")
    parent = relationship("Parent", back_populates="children")
    sessions = relationship("LearningSession", back_populates="student")
    quiz_results = relationship("QuizResult", back_populates="student")
    chat_messages = relationship("ChatMessage", back_populates="student")
