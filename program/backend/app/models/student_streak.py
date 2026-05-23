from sqlalchemy import Column, Integer, Date, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base
from app.models.compat import PortableUUID


class StudentStreak(Base):
    __tablename__ = "student_streaks"

    student_id = Column(PortableUUID(), ForeignKey("students.id"), primary_key=True)
    current_streak = Column(Integer, default=0)
    longest_streak = Column(Integer, default=0)
    last_activity_date = Column(Date, nullable=True)

    student = relationship("Student")
