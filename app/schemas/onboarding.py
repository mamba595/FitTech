from pydantic import BaseModel
from datetime import date
from typing import Optional


class OnboardingCreate(BaseModel):
    user_id: int
    birthdate: Optional[date] = None
    sex: Optional[str] = None
    height: Optional[int] = None
    weight: Optional[int] = None
    main_goal: Optional[str] = None
    weight_target: Optional[int] = None
    deadline: Optional[date] = None
    medical_conditions: Optional[str] = None
    sleep_hours: Optional[float] = None
    work_schedule: Optional[str] = None


class OnboardingInDB(OnboardingCreate):
    id: int
    user_id: int

    class Config:
        orm_mode = True