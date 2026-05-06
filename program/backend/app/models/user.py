import uuid
import enum
from datetime import datetime, timezone
from sqlalchemy import Column, String, Boolean, DateTime, Enum as SQLEnum
from sqlalchemy.orm import relationship
from app.database import Base
from app.models.compat import PortableUUID


class UserRole(str, enum.Enum):
    student = "student"
    parent = "parent"
    admin = "admin"


class User(Base):
    __tablename__ = "users"

    id = Column(PortableUUID(), primary_key=True, default=uuid.uuid4)
    firebase_uid = Column(String, unique=True, nullable=False)
    role = Column(SQLEnum(UserRole, name="user_role", native_enum=False), nullable=False)
    name = Column(String(100), nullable=False)
    email = Column(String(150), unique=True, nullable=True)
    phone = Column(String(20), nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    is_active = Column(Boolean, default=True)

    student = relationship("Student", back_populates="user", uselist=False)
    parent = relationship("Parent", back_populates="user", uselist=False)
    admin = relationship("Admin", back_populates="user", uselist=False)
