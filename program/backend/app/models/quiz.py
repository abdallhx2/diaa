import uuid
import enum
from sqlalchemy import Column, String, Text, ForeignKey, Enum as SQLEnum
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
from app.database import Base


class QuizType(str, enum.Enum):
    reading = "reading"
    writing = "writing"
    comprehension = "comprehension"


class Quiz(Base):
    __tablename__ = "quizzes"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    lesson_id = Column(UUID(as_uuid=True), ForeignKey("lessons.id"), nullable=False)
    quiz_type = Column(SQLEnum(QuizType), nullable=False)
    question_text = Column(Text, nullable=False)
    options = Column(JSONB, nullable=False)
    correct_answer = Column(String(200), nullable=False)

    lesson = relationship("Lesson", back_populates="quizzes")
    results = relationship("QuizResult", back_populates="quiz")
