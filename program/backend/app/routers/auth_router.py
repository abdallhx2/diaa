from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from typing import Literal
from sqlalchemy.orm import Session
from app.database import get_db
from app.services.auth_service import (
    verify_firebase_token,
    get_or_create_user,
    register_parent,
    add_child,
    get_user_profile,
)
from app.schemas.auth_schema import (
    TokenVerifyRequest,
    RegisterParentRequest,
    AddChildRequest,
    UserResponse,
)
from app.middleware.auth_middleware import get_current_user, verify_firebase_token as verify_firebase_token_dep
from app.models.user import User
from app.models.fcm_token import FcmToken
from app.utils.helpers import format_response


class FcmTokenRequest(BaseModel):
    token: str
    platform: Literal["android", "ios"]

router = APIRouter()


@router.post("/verify-token")
async def verify_token(body: TokenVerifyRequest, db: Session = Depends(get_db)):
    """Verify Firebase token and get or create user."""
    try:
        decoded = verify_firebase_token(body.token)
        uid = decoded.get("uid", "")
        email = decoded.get("email")
        name = decoded.get("name", decoded.get("email", "مستخدم"))
        role = decoded.get("role", "student")

        user = get_or_create_user(db, firebase_uid=uid, role=role, name=name, email=email)
        profile = get_user_profile(db, user)
        return format_response(True, profile, "تم التحقق بنجاح")
    except Exception as e:
        raise HTTPException(status_code=401, detail=format_response(False, None, str(e)))


@router.post("/register-parent")
async def register_parent_endpoint(
    body: RegisterParentRequest,
    current_user_token: dict = Depends(verify_firebase_token_dep),
    db: Session = Depends(get_db),
):
    """Register a new parent account. Parent must already be authenticated via Firebase."""
    try:
        firebase_uid = current_user_token.get("uid", "")

        # Check if user already exists in DB
        existing = get_or_create_user(db, firebase_uid=firebase_uid, role="parent", name=body.name, email=body.email)
        if existing.phone != body.phone and body.phone:
            existing.phone = body.phone
            db.commit()
            db.refresh(existing)

        profile = get_user_profile(db, existing)
        return format_response(True, profile, "تم تسجيل ولي الأمر بنجاح")
    except Exception as e:
        raise HTTPException(status_code=400, detail=format_response(False, None, str(e)))


@router.post("/add-child")
async def add_child_endpoint(
    body: AddChildRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Add a child to the authenticated parent's account."""
    if current_user.role.value != "parent":
        raise HTTPException(status_code=403, detail=format_response(False, None, "يجب أن تكون ولي أمر"))

    try:
        child_user = add_child(
            db,
            parent_user=current_user,
            child_firebase_uid=body.child_firebase_uid,
            child_name=body.child_name,
            age=body.age,
            grade=body.grade,
            learning_level=body.learning_level or "مبتدئ",
        )
        return format_response(True, {
            "id": str(child_user.id),
            "name": child_user.name,
        }, "تم إضافة الطفل بنجاح")
    except Exception as e:
        raise HTTPException(status_code=400, detail=format_response(False, None, str(e)))


@router.get("/me")
async def get_me(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get current authenticated user's profile."""
    try:
        profile = get_user_profile(db, current_user)
        return format_response(True, profile, "بيانات المستخدم")
    except Exception as e:
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))


@router.post("/fcm-token")
async def register_fcm_token(
    body: FcmTokenRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Upsert FCM device token for current user (parents only receive notifications)."""
    try:
        existing = (
            db.query(FcmToken)
            .filter(FcmToken.user_id == current_user.id, FcmToken.token == body.token)
            .first()
        )
        if existing:
            existing.platform = body.platform
        else:
            db.add(FcmToken(user_id=current_user.id, token=body.token, platform=body.platform))
        db.commit()
        return format_response(True, None, "تم تسجيل الجهاز بنجاح")
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=format_response(False, None, str(e)))
