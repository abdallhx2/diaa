from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from app.config import settings


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan: initialize Firebase Admin SDK and OpenRouter client."""
    # ── Startup ──
    if settings.USE_MOCKS:
        print("[MOCK] Running in MOCK MODE")

        # Create SQLite tables (no Alembic needed for local dev)
        from app.models import Base
        from app.database import engine, SessionLocal
        Base.metadata.create_all(bind=engine)
        print("[MOCK] SQLite tables created")

        # Auto-seed data if tables are empty
        from app.models.user import User
        _db = SessionLocal()
        try:
            if _db.query(User).count() == 0:
                from seed_data import seed
                seed()
            else:
                print("[SEED] Data already exists")
        finally:
            _db.close()
    else:
        # Initialize Firebase Admin SDK
        import firebase_admin
        from firebase_admin import credentials
        if not firebase_admin._apps:
            cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS_PATH)
            firebase_admin.initialize_app(cred, {
                "storageBucket": settings.FIREBASE_STORAGE_BUCKET,
            })

        # Verify OpenRouter client is ready
        from app.services.openrouter_client import client
        if client:
            print("[AI] OpenRouter client initialized")
        else:
            print("[WARNING] OpenRouter client not available")

    # Log AI mode
    if not settings.MOCK_AI:
        from app.services.openrouter_client import client as ai_client
        if ai_client:
            print(f"[AI] Real AI via OpenRouter (Chat: {settings.CHAT_MODEL}, OCR: {settings.VISION_MODEL}, TTS: {settings.TTS_MODEL})")
        else:
            print("[WARNING] MOCK_AI=false but OpenRouter client failed to initialize")
    else:
        print("[MOCK] AI services in mock mode")

    yield

    # ── Shutdown ──
    # Nothing to clean up


app = FastAPI(
    title="Edu Smart Assistant",
    version="1.0.0",
    description="منصة تعليمية ذكية للأطفال في المرحلة الابتدائية",
    lifespan=lifespan,
)

# ── CORS Middleware ──
origins = [o.strip() for o in settings.CORS_ORIGINS.split(",")]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Static Files (TTS audio) ──
import os as _os
_os.makedirs("static/audio", exist_ok=True)
app.mount("/static", StaticFiles(directory="static"), name="static")

# ── Logging Middleware ──
from app.middleware.logging_middleware import LoggingMiddleware
app.add_middleware(LoggingMiddleware)


# ── Exception Handlers ──
@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request, exc):
    return JSONResponse(
        status_code=422,
        content={"success": False, "data": None, "message": "بيانات غير صحيحة"}
    )


@app.exception_handler(Exception)
async def general_exception_handler(request, exc):
    return JSONResponse(
        status_code=500,
        content={"success": False, "data": None, "message": "حدث خطأ في الخادم"}
    )


# ── Register Routers ──
from app.routers import auth_router, student_router, scan_router, tts_router, chat_router, quiz_router, parent_router, admin_router
from app.routers import lesson_router

app.include_router(lesson_router.router, prefix="/api/lessons", tags=["lessons"])
app.include_router(auth_router.router, prefix="/api/auth", tags=["Authentication"])
app.include_router(student_router.router, prefix="/api/student", tags=["Student"])
app.include_router(scan_router.router, prefix="/api/scan", tags=["Scan & OCR"])
app.include_router(tts_router.router, prefix="/api/tts", tags=["Text-to-Speech"])
app.include_router(chat_router.router, prefix="/api/chat", tags=["AI Chat"])
app.include_router(quiz_router.router, prefix="/api/quizzes", tags=["Quizzes"])
app.include_router(parent_router.router, prefix="/api/parent", tags=["Parent"])
app.include_router(admin_router.router, prefix="/api/admin", tags=["Admin"])


# ── Health Check ──
@app.get("/")
async def health_check():
    return {
        "success": True,
        "data": None,
        "message": "Edu Smart Assistant API is running",
    }
