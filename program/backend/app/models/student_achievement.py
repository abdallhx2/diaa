import uuid
from datetime import datetime, timezone
from sqlalchemy import Column, DateTime, ForeignKey, UniqueConstraint
from sqlalchemy.orm import relationship
from app.database import Base
from app.models.compat import PortableUUID


class StudentAchievement(Base):
    __tablename__ = "student_achievements"

    id = Column(PortableUUID(), primary_key=True, default=uuid.uuid4)
    student_id = Column(PortableUUID(), ForeignKey("students.id"), nullable=False)
    achievement_id = Column(PortableUUID(), ForeignKey("achievements.id"), nullable=False)
    unlocked_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    student = relationship("Student")
    achievement = relationship("Achievement")

    __table_args__ = (
        UniqueConstraint("student_id", "achievement_id", name="uq_student_achievement"),
    )
