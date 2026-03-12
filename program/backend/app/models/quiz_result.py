import uuid
from sqlalchemy import Column, Numeric, DateTime, ForeignKey
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base


class QuizResult(Base):
    __tablename__ = "quiz_results"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    student_id = Column(UUID(as_uuid=True), ForeignKey("students.id"), nullable=False)
    quiz_id = Column(UUID(as_uuid=True), ForeignKey("quizzes.id"), nullable=False)
    score = Column(Numeric(5, 2), nullable=False)
    answers_detail = Column(JSONB, nullable=False)
    taken_at = Column(DateTime(timezone=True), server_default=func.now())

    student = relationship("Student", back_populates="quiz_results")
    quiz = relationship("Quiz", back_populates="results")
