import uuid
from datetime import datetime, timezone
from sqlalchemy import Column, String, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base
from app.models.compat import PortableUUID


class QuizResult(Base):
    __tablename__ = "quiz_results"

    id = Column(PortableUUID(), primary_key=True, default=uuid.uuid4)
    student_id = Column(PortableUUID(), ForeignKey("students.id"), nullable=False)
    quiz_id = Column(PortableUUID(), ForeignKey("quizzes.id"), nullable=False)
    selected_answer = Column(String(200), nullable=False)
    is_correct = Column(Boolean, nullable=False)
    answered_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    student = relationship("Student", back_populates="quiz_results")
    quiz = relationship("Quiz", back_populates="results")
