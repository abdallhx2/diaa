import uuid
from datetime import datetime, timezone
from sqlalchemy import Column, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from app.database import Base
from app.models.compat import PortableUUID


class Admin(Base):
    __tablename__ = "admins"

    id = Column(PortableUUID(), primary_key=True, default=uuid.uuid4)
    user_id = Column(PortableUUID(), ForeignKey("users.id"), unique=True, nullable=False)
    admin_level = Column(String(20), default="standard")
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    user = relationship("User", back_populates="admin")
