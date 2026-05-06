import uuid
import enum
from datetime import datetime, timezone
from sqlalchemy import Column, String, Text, ForeignKey, DateTime, Enum as SQLEnum
from sqlalchemy.orm import relationship
from app.database import Base
from app.models.compat import PortableUUID, PortableJSON


class QuizType(str, enum.Enum):
    reading = "reading"
    writing = "writing"
    comprehension = "comprehension"


class Quiz(Base):
    __tablename__ = "quizzes"

    id = Column(PortableUUID(), primary_key=True, default=uuid.uuid4)
    lesson_id = Column(PortableUUID(), ForeignKey("lessons.id"), nullable=False)
    quiz_type = Column(SQLEnum(QuizType, name="quiz_type_enum", native_enum=False), nullable=False)
    question_text = Column(Text, nullable=False)
    options = Column(PortableJSON(), nullable=False)
    correct_answer = Column(String(200), nullable=False)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    lesson = relationship("Lesson", back_populates="quizzes")
    results = relationship("QuizResult", back_populates="quiz")
