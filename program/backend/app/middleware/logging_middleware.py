import time
from fastapi import Request
from starlette.middleware.base import BaseHTTPMiddleware
from app.database import SessionLocal
from app.models.system_log import SystemLog


class LoggingMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        method = request.method
        path = request.url.path
        start_time = time.time()

        response = await call_next(request)

        response_time_ms = (time.time() - start_time) * 1000

        try:
            db = SessionLocal()
            user_id = None
            if hasattr(request.state, "user") and request.state.user:
                user_id = request.state.user.id

            status_code = response.status_code
            log = SystemLog(
                user_id=user_id,
                action=f"{method} {path}",
                status="success" if status_code < 400 else "error",
                details={
                    "method": method,
                    "path": path,
                    "status_code": status_code,
                    "response_time_ms": round(response_time_ms, 2),
                },
            )
            db.add(log)
            db.commit()
            db.close()
        except Exception as e:
            print(f"Logging error: {e}")

        return response
