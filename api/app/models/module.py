from sqlalchemy import JSON, Boolean, Column, DateTime, Integer, String

from app.database import Base


class ModuleSettings(Base):
    __tablename__ = "module_settings"

    id = Column(Integer, primary_key=True, index=True)
    module_name = Column(String, unique=True)
    created = Column(DateTime, nullable=False)
    modified = Column(DateTime, nullable=False)
    enabled = Column(Boolean, nullable=False, default=False)
    config = Column(JSON, nullable=False, default={})
