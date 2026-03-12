from fastapi import APIRouter, HTTPException, Request
from sqlalchemy.orm import Session
from app.services.auth_service import verify_firebase_token, get_or_create_user, register_parent, add_child_to_parent
from app.utils.helpers import format_response
from pydantic import BaseModel
from typing import Optional

router = APIRouter()


class TokenVerifyRequest(BaseModel):
    token: str
    role: Optional[str] = "student"


class RegisterParentRequest(BaseModel):
    name: str
    email: str
    password: str
    phone: Optional[str] = None


class AddChildRequest(BaseModel):
    name: str
    age: Optional[int] = None
    grade: Optional[str] = None
    learning_level: Optional[str] = None


@router.post("/verify-token")
def verify_token(body: TokenVerifyRequest):
    try:
        decoded = verify_firebase_token(body.token)
        user = get_or_create_user(
            firebase_uid=decoded["uid"],
            role=body.role,
            name=decoded.get("name", ""),
            email=decoded.get("email", ""),
        )
        return format_response(True, {
            "id": str(user.id),
            "name": user.name,
            "email": user.email,
            "role": user.role,
        }, "تم التحقق بنجاح")
    except Exception as e:
        raise HTTPException(status_code=401, detail=str(e))


@router.post("/register-parent")
def register_parent_endpoint(body: RegisterParentRequest):
    try:
        parent_data = register_parent(body.dict())
        return format_response(True, parent_data, "تم تسجيل ولي الأمر بنجاح")
    except Exception as e:
        if "EMAIL_EXISTS" in str(e):
            raise HTTPException(status_code=400, detail="البريد الإلكتروني مستخدم بالفعل")
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/add-child")
def add_child(body: AddChildRequest, request: Request):
    try:
        user = request.state.user
        if user.role != "parent":
            raise HTTPException(status_code=403, detail="هذا الإجراء مخصص لأولياء الأمور فقط")
        parent_id = str(user.parent.id)
        child_data = add_child_to_parent(parent_id, body.dict())
        return format_response(True, child_data, "تم إضافة الطفل بنجاح")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/me")
def get_me(request: Request):
    user = request.state.user
    return format_response(True, {
        "id": str(user.id),
        "name": user.name,
        "email": user.email,
        "role": user.role,
        "phone": user.phone,
        "created_at": str(user.created_at),
    }, "بيانات المستخدم")