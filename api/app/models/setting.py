from sqlalchemy import JSON, Column, Integer, String

from app.database import Base


class Setting(Base):
    __tablename__ = "settings"
    id = Column(Integer, primary_key=True, index=True)
    namespace = Column(String, unique=True, index=True)
    value = Column(JSON)
