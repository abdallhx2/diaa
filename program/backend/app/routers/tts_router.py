# ============================================================
# File: routers/tts_router.py
# Purpose: نقاط نهاية تحويل النص إلى صوت — Text-to-Speech
# Owner: رنيم — API Developer
# Branch: feature/backend-routers
# Week: Week 2 — واجهة تحويل النص لصوت
# ============================================================

# --- Required Imports ---
# from fastapi import APIRouter, Depends, HTTPException, Request
# from sqlalchemy.orm import Session
# from app.database import get_db
# from app.services.tts_service import text_to_speech
# from app.utils.helpers import format_response

# --- Implementation Steps ---

# Step 1: إنشاء الراوتر
# - router = APIRouter()

# Step 2: POST /generate — تحويل النص العربي إلى صوت
# - @router.post("/generate")
# - يحتاج مصادقة
# - استلمي text: str في body (النص العربي المراد تحويله)
# - تحققي إن النص مو فاضي
# - تحققي أولاً من الـ cache (لو النص تم تحويله قبل، ارجعي الرابط المخزن)
# - لو مو موجود في الكاش — استدعي text_to_speech(text) من tts_service
# - الدالة ترجع رابط الملف الصوتي (audio_url)
# - ارجعي format_response(True, {"audio_url": audio_url}, "تم تحويل النص إلى صوت")

# --- Dependencies ---
# - app/services/tts_service.py (text_to_speech)
# - app/database.py (get_db)
# - app/middleware/auth_middleware.py (التحقق من التوكن)

# --- API Endpoints ---
# POST /api/tts/generate — تحويل نص عربي إلى صوت

# --- Notes ---
# - يُستخدم Azure Speech Service مع صوت عربي (ar-SA-HamedNeural)
# - التخزين المؤقت (caching): لو النص نفسه تم تحويله قبل، نرجع الرابط القديم بدون توليد جديد
# - الكاش يعتمد على hash للنص عشان نقلل استهلاك Azure API
# - الملف الصوتي يُرفع على Firebase Storage
# - استخدمي format_response دائماً: { success: bool, data: any, message: str }
