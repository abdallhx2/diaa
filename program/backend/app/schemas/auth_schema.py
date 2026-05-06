from pydantic import BaseModel, EmailStr
from typing import Optional
from uuid import UUID
from datetime import datetime


class TokenVerifyRequest(BaseModel):
    token: str


class RegisterParentRequest(BaseModel):
    name: str
    email: Optional[EmailStr] = None
    phone: Optional[str] = None


class AddChildRequest(BaseModel):
    child_firebase_uid: str
    child_name: str
    age: Optional[int] = None
    grade: str
    learning_level: Optional[str] = "مبتدئ"


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


class UserResponse(BaseModel):
    id: UUID
    name: str
    email: Optional[str] = None
    role: str
    phone: Optional[str] = None
    created_at: datetime

    model_config = {"from_attributes": True}


class LoginResponse(BaseModel):
    success: bool
    user: UserResponse
    token: str
