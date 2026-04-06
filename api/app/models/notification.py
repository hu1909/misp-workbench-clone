from sqlalchemy import (JSON, Boolean, Column, DateTime, ForeignKey, Integer,
                        String)
from sqlalchemy.dialects.postgresql import UUID

from app.database import Base


class Notification(Base):
    __tablename__ = "notifications"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    type = Column(String, nullable=False)
    entity_type = Column(String(255))
    entity_uuid = Column(UUID(as_uuid=True), unique=False, nullable=True)
    read = Column(Boolean, default=False)
    payload = Column(JSON, nullable=False, default={})
    created_at = Column(DateTime, nullable=False)
    updated_at = Column(DateTime, nullable=True)
