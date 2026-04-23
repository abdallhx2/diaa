from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings
from app.routers import admin_router          # ← سطر جديد

app = FastAPI(title="Diaa Platform", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(admin_router.router, prefix="/api/admin", tags=["Admin"])  # ← سطر جديد

@app.get("/")
def health_check():
    return {"success": True, "data": None, "message": "Diaa Platform API is running"}