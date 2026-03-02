# ============================================================
# File: routers/scan_router.py
# Purpose: نقاط نهاية المسح والتعرف على النص — OCR و QR
# Owner: رنيم — API Developer
# Branch: feature/backend-routers
# Week: Week 2 — واجهات المسح الضوئي
# ============================================================

# --- Required Imports ---
# from fastapi import APIRouter, Depends, UploadFile, File, HTTPException, Request
# from sqlalchemy.orm import Session
# from app.database import get_db
# from app.services.ocr_service import extract_text_from_image
# from app.models.lesson import Lesson
# from app.utils.helpers import format_response

# --- Implementation Steps ---

# Step 1: إنشاء الراوتر
# - router = APIRouter()

# Step 2: POST /ocr — استخراج النص من صورة بالكاميرا
# - @router.post("/ocr")
# - يحتاج مصادقة
# - استلمي الصورة كـ UploadFile: image: UploadFile = File(...)
# - تحققي من حجم الملف (أقصى 10MB):
#   - contents = await image.read()
#   - if len(contents) > 10 * 1024 * 1024: raise HTTPException(413)
# - تحققي من نوع الملف (image/jpeg, image/png فقط)
# - استدعي extract_text_from_image(contents) من ocr_service
# - ارجعي format_response(True, {"extracted_text": text}, "تم استخراج النص بنجاح")

# Step 3: POST /qr — البحث عن درس بكود QR
# - @router.post("/qr")
# - يحتاج مصادقة
# - استلمي qr_code: str في body
# - ابحثي في جدول lessons عن الدرس بـ qr_code
# - لو ما لقيتيه — ارجعي 404: format_response(False, None, "الدرس غير موجود")
# - ارجعي format_response(True, lesson_data, "تم العثور على الدرس")

# Step 4: POST /upload — رفع صورة واستخراج النص
# - @router.post("/upload")
# - يحتاج مصادقة
# - نفس منطق /ocr بس للصور المرفوعة من الجهاز (مو الكاميرا)
# - استلمي file: UploadFile = File(...)
# - تحققي من الحجم (أقصى 10MB) والنوع
# - استدعي extract_text_from_image(contents)
# - ارجعي format_response(True, {"extracted_text": text}, "تم استخراج النص بنجاح")

# --- Dependencies ---
# - app/services/ocr_service.py (extract_text_from_image)
# - app/models/lesson.py (Lesson model — للبحث بـ QR)
# - app/database.py (get_db)
# - app/middleware/auth_middleware.py (التحقق من التوكن)

# --- API Endpoints ---
# POST /api/scan/ocr     — استخراج النص من صورة الكاميرا
# POST /api/scan/qr      — البحث عن درس بكود QR
# POST /api/scan/upload   — رفع صورة واستخراج النص

# --- Notes ---
# - الحد الأقصى لحجم الملف: 10MB
# - الأنواع المسموحة: image/jpeg, image/png
# - استخدمي format_response دائماً: { success: bool, data: any, message: str }
# - الـ OCR يستخدم EasyOCR للنص العربي
