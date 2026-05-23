import uuid
from sqlalchemy import Column, String, Integer, Text
from app.database import Base
from app.models.compat import PortableUUID


class Achievement(Base):
    __tablename__ = "achievements"

    id = Column(PortableUUID(), primary_key=True, default=uuid.uuid4)
    code = Column(String(40), unique=True, nullable=False)
    name_ar = Column(String(80), nullable=False)
    description_ar = Column(Text, nullable=True)
    icon_emoji = Column(String(10), nullable=True)
    threshold = Column(Integer, nullable=False)
    kind = Column(String(20), nullable=False)
