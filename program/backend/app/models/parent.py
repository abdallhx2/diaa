import uuid
from datetime import datetime, timezone
from sqlalchemy import Column, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from app.database import Base
from app.models.compat import PortableUUID


class Parent(Base):
    __tablename__ = "parents"

    id = Column(PortableUUID(), primary_key=True, default=uuid.uuid4)
    user_id = Column(PortableUUID(), ForeignKey("users.id"), unique=True, nullable=False)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    user = relationship("User", back_populates="parent")
    children = relationship("Student", back_populates="parent")
