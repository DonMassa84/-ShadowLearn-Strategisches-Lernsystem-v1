from sqlalchemy import Column, Integer, String
from core.database import Base

class LearningItem(Base):
    __tablename__ = "learning_items"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String)
    content = Column(String)
    category = Column(String)
