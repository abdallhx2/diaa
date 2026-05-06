import uuid
from datetime import datetime, timezone
from sqlalchemy import Column, String, DateTime, ForeignKey
from app.database import Base
from app.models.compat import PortableUUID, PortableJSON


class SystemLog(Base):
    __tablename__ = "system_logs"

    id = Column(PortableUUID(), primary_key=True, default=uuid.uuid4)
    user_id = Column(PortableUUID(), ForeignKey("users.id"), nullable=True)
    action = Column(String(100), nullable=False)
    status = Column(String(20), nullable=False, default="success")
    details = Column(PortableJSON(), nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
