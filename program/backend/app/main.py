from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.routers import (
    auth_router,
    student_router,
    parent_router,
    admin_router,
    chat_router,
    quiz_router,
    scan_router,
    tts_router,
)

app = FastAPI(title="Edu Platform")

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routers
app.include_router(auth_router.router,    prefix="/auth",    tags=["Auth"])
app.include_router(student_router.router, prefix="/student", tags=["Student"])
app.include_router(parent_router.router,  prefix="/parent",  tags=["Parent"])
app.include_router(admin_router.router,   prefix="/admin",   tags=["Admin"])
app.include_router(chat_router.router,    prefix="/chat",    tags=["Chat"])
app.include_router(quiz_router.router,    prefix="/quiz",    tags=["Quiz"])
app.include_router(scan_router.router,    prefix="/scan",    tags=["Scan"])
app.include_router(tts_router.router,     prefix="/tts",     tags=["TTS"])

@app.get("/")
def root():
    return {"status": "ok", "message": "Server is running"}