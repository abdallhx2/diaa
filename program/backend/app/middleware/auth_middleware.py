from fastapi import Depends, HTTPException, Request
from sqlalchemy.orm import Session
from app.config import settings as _cfg
from app.database import get_db
from app.models.user import User

# Only import Firebase SDK when not in mock mode
if not _cfg.USE_MOCKS:
    from firebase_admin import auth


async def verify_firebase_token(request: Request) -> dict:
    """FastAPI dependency: extracts Bearer token, verifies with Firebase, returns decoded dict."""
    authorization = request.headers.get("Authorization")
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=401,
            detail={"success": False, "data": None, "message": "التوكن مطلوب"},
        )
    token = authorization.split("Bearer ")[1]
    try:
        from app.config import settings
        if settings.USE_MOCKS:
            from app.services.mock_services import MockFirebaseAuth
            decoded_token = MockFirebaseAuth.verify_id_token(token)
            return decoded_token

        decoded_token = auth.verify_id_token(token)
        return decoded_token
    except Exception:
        raise HTTPException(
            status_code=401,
            detail={"success": False, "data": None, "message": "التوكن غير صالح أو منتهي الصلاحية"},
        )


async def get_current_user(
    decoded_token: dict = Depends(verify_firebase_token),
    db: Session = Depends(get_db),
) -> User:
    """FastAPI dependency: fetches User from DB using firebase_uid from decoded token."""
    firebase_uid = decoded_token.get("uid")
    if not firebase_uid:
        raise HTTPException(
            status_code=401,
            detail={"success": False, "data": None, "message": "بيانات التوكن غير صالحة"},
        )
    user = db.query(User).filter(User.firebase_uid == firebase_uid).first()
    if not user:
        raise HTTPException(
            status_code=401,
            detail={"success": False, "data": None, "message": "المستخدم غير موجود"},
        )
    if not user.is_active:
        raise HTTPException(
            status_code=403,
            detail={"success": False, "data": None, "message": "الحساب معطل"},
        )
    return user
