# ============================================================
# File: main.py
# Purpose: نقطة الدخول الرئيسية لتطبيق FastAPI — تسجيل الراوترات والميدل وير
# Owner: مشاعل — Backend Lead
# Branch: feature/backend-auth
# Week: Week 1 — إعداد الهيكل الأساسي للتطبيق
# ============================================================

# --- Required Imports ---
# from fastapi import FastAPI
# from fastapi.middleware.cors import CORSMiddleware
# from app.config import settings
# from app.routers import auth_router, student_router, scan_router, tts_router, chat_router, quiz_router, parent_router, admin_router
# from app.middleware.auth_middleware import auth_middleware
# from app.middleware.logging_middleware import logging_middleware
# import easyocr

# --- Implementation Steps ---

# Step 1: إنشاء instance من FastAPI
# - app = FastAPI(title="Edu Platform", version="1.0.0")
# - أضيفي وصف بالعربي للمشروع في description parameter

# Step 2: إعداد CORS middleware
# - استخدمي app.add_middleware(CORSMiddleware, ...)
# - allowed origins تجي من settings.CORS_ORIGINS
# - allow_credentials=True
# - allow_methods=["*"]
# - allow_headers=["*"]

# Step 3: تسجيل جميع الراوترات مع البريفكس المناسب
# - app.include_router(auth_router.router, prefix="/api/auth", tags=["Authentication"])
# - app.include_router(student_router.router, prefix="/api/student", tags=["Student"])
# - app.include_router(scan_router.router, prefix="/api/scan", tags=["Scan & OCR"])
# - app.include_router(tts_router.router, prefix="/api/tts", tags=["Text-to-Speech"])
# - app.include_router(chat_router.router, prefix="/api/chat", tags=["AI Chat"])
# - app.include_router(quiz_router.router, prefix="/api/quizzes", tags=["Quizzes"])
# - app.include_router(parent_router.router, prefix="/api/parent", tags=["Parent"])
# - app.include_router(admin_router.router, prefix="/api/admin", tags=["Admin"])

# Step 4: إضافة الـ middleware
# - أضيفي auth_middleware للتحقق من التوكن
# - أضيفي logging_middleware لتسجيل الطلبات

# Step 5: إضافة startup event لتحميل نموذج EasyOCR
# - @app.on_event("startup")
# - async def startup_event():
# -     app.state.ocr_reader = easyocr.Reader(['ar'])
# - هذا يضمن تحميل النموذج مرة واحدة فقط عند بدء التطبيق

# Step 6: إضافة health check endpoint
# - @app.get("/")
# - return { "success": True, "data": None, "message": "Edu Platform API is running" }
# - هذا الـ endpoint يستخدمه Railway للتأكد إن التطبيق شغال

# --- Dependencies ---
# - app/config.py (إعدادات التطبيق)
# - app/routers/* (جميع الراوترات)
# - app/middleware/* (الميدل وير)

# --- API Endpoints ---
# GET / — Health check endpoint
# جميع الراوترات تحت /api/*

# --- Notes ---
# - تأكدي إن كل الراوترات مسجلة قبل تشغيل التطبيق
# - الـ CORS مهم جداً عشان الفرونت إند يقدر يتواصل مع الباك إند
# - نموذج EasyOCR يحتاج وقت للتحميل، لذلك نحمله مرة واحدة في startup
# - الـ standard response format: { success: bool, data: any, message: str }
