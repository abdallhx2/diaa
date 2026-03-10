from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.orm import Session

from app.database import get_db
from app.services.auth_service import (
    verify_firebase_token,
    get_or_create_user,
    register_parent,
    add_child_to_parent,
)
from app.schemas.auth_schema import (
    TokenVerifyRequest,
    RegisterParentRequest,
    AddChildRequest,
    UserResponse,
)
from app.utils.helpers import format_response

router = APIRouter()


@router.post("/verify-token")
async def verify_token(body: TokenVerifyRequest, db: Session = Depends(get_db)):
    try:
        decoded_token = verify_firebase_token(body.token)

        firebase_uid = decoded_token.get("uid")
        email = decoded_token.get("email", "")
        name = decoded_token.get("name", "")
        role = decoded_token.get("role", "parent")

        user = get_or_create_user(
            db=db,
            firebase_uid=firebase_uid,
            role=role,
            name=name,
            email=email,
        )

        return format_response(
            True,
            UserResponse.from_orm(user),
            "تم التحقق بنجاح",
        )

    except HTTPException:
        raise
    except Exception:
        raise HTTPException(
            status_code=401,
            detail=format_response(False, None, "Invalid or expired token"),
        )


@router.post("/register-parent")
async def register_parent_endpoint(
    body: RegisterParentRequest,
    db: Session = Depends(get_db),
):
    try:
        parent_data = register_parent(db=db, data=body)

        return format_response(
            True,
            parent_data,
            "تم تسجيل ولي الأمر بنجاح",
        )

    except ValueError as e:
        raise HTTPException(
            status_code=400,
            detail=format_response(False, None, str(e)),
        )
    except HTTPException:
        raise
    except Exception:
        raise HTTPException(
            status_code=400,
            detail=format_response(False, None, "فشل تسجيل ولي الأمر"),
        )


@router.post("/add-child")
async def add_child(
    request: Request,
    body: AddChildRequest,
    db: Session = Depends(get_db),
):
    try:
        user = request.state.user

        if user.role != "parent":
            raise HTTPException(
                status_code=403,
                detail=format_response(False, None, "غير مصرح — يجب أن تكون ولي أمر"),
            )

        parent_id = user.parent.id

        child_data = add_child_to_parent(
            db=db,
            parent_id=parent_id,
            child_data=body,
        )

        return format_response(
            True,
            child_data,
            "تم إضافة الطفل بنجاح",
        )

    except HTTPException:
        raise
    except Exception:
        raise HTTPException(
            status_code=400,
            detail=format_response(False, None, "فشل إضافة الطفل"),
        )


@router.get("/me")
async def get_me(request: Request):
    try:
        user = request.state.user

        return format_response(
            True,
            UserResponse.from_orm(user),
            "بيانات المستخدم",
        )

    except HTTPException:
        raise
    except Exception:
        raise HTTPException(
            status_code=401,
            detail=format_response(False, None, "User not authenticated"),
        )