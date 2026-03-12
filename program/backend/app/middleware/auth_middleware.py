from fastapi import Request
from fastapi.responses import JSONResponse
from starlette.middleware.base import BaseHTTPMiddleware

PUBLIC_PATHS = [
    "/",
    "/docs",
    "/openapi.json",
    "/redoc",
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
                content={"success": False, "data": None, "message": "Missing or invalid authorization header"},
            )

        token = authorization.split("Bearer ")[1]

        try:
            from app.services.auth_service import verify_firebase_token
            from app.database import SessionLocal
            from app.models.user import User

            decoded = verify_firebase_token(token)
            firebase_uid = decoded.get("uid")

            db = SessionLocal()
            try:
                user = db.query(User).filter(User.firebase_uid == firebase_uid).first()
                if not user:
                    return JSONResponse(
                        status_code=401,
                        content={"success": False, "data": None, "message": "User not found"},
                    )
                request.state.user = user
            finally:
                db.close()

        except Exception:
            return JSONResponse(
                status_code=401,
                content={"success": False, "data": None, "message": "Invalid or expired token"},
            )

        return await call_next(request)