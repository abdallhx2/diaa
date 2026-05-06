import uuid
import enum
from datetime import datetime, timezone
from sqlalchemy import Column, Integer, DateTime, ForeignKey, Enum as SQLEnum
from sqlalchemy.orm import relationship
from app.database import Base
from app.models.compat import PortableUUID


class SessionType(str, enum.Enum):
    scan = "scan"
    qr = "qr"
    upload = "upload"


class LearningSession(Base):
    __tablename__ = "learning_sessions"

    id = Column(PortableUUID(), primary_key=True, default=uuid.uuid4)
    student_id = Column(PortableUUID(), ForeignKey("students.id"), nullable=False)
    lesson_id = Column(PortableUUID(), ForeignKey("lessons.id"), nullable=False)
    session_type = Column(SQLEnum(SessionType, name="session_type_enum", native_enum=False), nullable=False)
    started_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    ended_at = Column(DateTime, nullable=True)
    duration_minutes = Column(Integer, default=0)

    student = relationship("Student", back_populates="sessions")
    lesson = relationship("Lesson", back_populates="sessions")
