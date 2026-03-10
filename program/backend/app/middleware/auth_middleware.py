from fastapi import Request
from fastapi.responses import JSONResponse
from starlette.middleware.base import BaseHTTPMiddleware
from app.database import SessionLocal
from app.services.auth_service import verify_firebase_token

PUBLIC_PATHS = [
    "/",
    "/docs",
    "/openapi.json",
    "/api/auth/verify-token",
    "/api/auth/register-parent",
]

class AuthMiddleware(BaseHTTPMiddleware):

    async def dispatch(self, request: Request, call_next):

        if request.url.path in PUBLIC_PATHS:
            return await call_next(request)

        authorization = request.headers.get("Authorization")

        if not authorization or not authorization.startswith("Bearer "):
            return JSONResponse(
                status_code=401,
                content={"success": False, "data": None, "message": "Missing or invalid Authorization header"}
            )

        token = authorization.split("Bearer ")[1]

        try:
            decoded_token = verify_firebase_token(token)
        except Exception:
            return JSONResponse(
                status_code=401,
                content={"success": False, "data": None, "message": "Invalid or expired token"}
            )

        firebase_uid = decoded_token.get("uid")

        db = SessionLocal()

        try:
            from app.models.user import User
            user = db.query(User).filter(User.firebase_uid == firebase_uid).first()

            if not user:
                return JSONResponse(
                    status_code=401,
                    content={"success": False, "data": None, "message": "User not found"}
                )

            request.state.user = user

        finally:
            db.close()

        response = await call_next(request)
        return response