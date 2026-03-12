import uuid
from sqlalchemy import Column, String, Integer, Numeric, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.database import Base


class Student(Base):
    __tablename__ = "students"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), unique=True, nullable=False)
    parent_id = Column(UUID(as_uuid=True), ForeignKey("parents.id"), nullable=True)
    age = Column(Integer, nullable=True)
    grade = Column(String(20), nullable=True)
    learning_level = Column(String(50), nullable=True)
    progress_score = Column(Numeric(5, 2), default=0)

    user = relationship("User", back_populates="student")
    parent = relationship("Parent", back_populates="children")
    sessions = relationship("LearningSession", back_populates="student")
    quiz_results = relationship("QuizResult", back_populates="student")
    chat_messages = relationship("ChatMessage", back_populates="student")
