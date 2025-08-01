from sqlalchemy import String, Integer, ForeignKey, Date, Float
from sqlalchemy.orm import Mapped, mapped_column
from app.core.database import Base

class Onboarding(Base):
    __tablename__ = 'onboarding'

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(ForeignKey('users.id'), index=True)
    name: Mapped[str] = mapped_column(String)
    birthdate: Mapped[Date] = mapped_column(Date)
    sex: Mapped[str] = mapped_column(String)
    height: Mapped[int] = mapped_column(Integer)
    weight: Mapped[int] = mapped_column(Integer)
    main_goal: Mapped[str] = mapped_column(String)
    weight_target: Mapped[int] = mapped_column(Integer)
    deadline: Mapped[Date] = mapped_column(Date)
    medical_conditions: Mapped[str] = mapped_column(String)
    sleep_hours: Mapped[float] = mapped_column(Float)
    work_schedule: Mapped[str] = mapped_column(String)
    percFat: Mapped[float] = mapped_column(Float)
    percMuscle: Mapped[float] = mapped_column(Float)
    injuryHist: Mapped[str] = mapped_column(String)
    expLevel: Mapped[str] = mapped_column(String)
    restrictedFoods: Mapped[str] = mapped_column(String)
    timeAvailability: Mapped[str] = mapped_column(String)
    materialAccess: Mapped[str] = mapped_column(String)
