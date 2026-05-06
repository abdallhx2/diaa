from pydantic import BaseModel
from typing import List, Optional, Dict
from decimal import Decimal


class AdminDashboard(BaseModel):
    total_users: int = 0
    active_users_7d: int = 0
    total_sessions_week: int = 0
    total_sessions_month: int = 0
    avg_response_time: Decimal = Decimal("0")


class UserManage(BaseModel):
    name: Optional[str] = None
    email: Optional[str] = None
    role: Optional[str] = None
    is_active: Optional[bool] = None


class SystemSettings(BaseModel):
    language: str = "ar"
    available_content: List[str] = ["لغة عربية"]
    notifications: Dict[str, bool] = {
        "email_notifications": True,
        "push_notifications": True,
        "parent_weekly_report": True,
    }
