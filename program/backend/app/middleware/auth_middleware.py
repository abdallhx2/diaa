# ============================================================
# File: middleware/auth_middleware.py
# Purpose: التحقق من صحة التوكن — Firebase token verification middleware
# Owner: مشاعل — Backend Lead
# Branch: feature/backend-auth
# Week: Week 1 — إعداد نظام المصادقة
# ============================================================

# --- Required Imports ---
# from fastapi import Request, HTTPException
# from fastapi.responses import JSONResponse
# from starlette.middleware.base import BaseHTTPMiddleware
# from app.services.auth_service import verify_firebase_token
# from app.database import SessionLocal

# --- Implementation Steps ---

# Step 1: إنشاء كلاس AuthMiddleware يرث من BaseHTTPMiddleware
# - class AuthMiddleware(BaseHTTPMiddleware):

# Step 2: تحديد المسارات المستثناة من التحقق (public routes)
# - PUBLIC_PATHS = ["/", "/docs", "/openapi.json", "/api/auth/verify-token", "/api/auth/register-parent"]
# - هذي المسارات ما تحتاج توكن

# Step 3: في دالة dispatch(self, request, call_next):
# - تحققي إذا المسار في PUBLIC_PATHS — إذا نعم، مرريه بدون تحقق
# - استخرجي التوكن من Authorization header
#   - authorization = request.headers.get("Authorization")
#   - لو ما فيه header أو ما يبدأ بـ "Bearer " — ارجعي 401
#   - token = authorization.split("Bearer ")[1]

# Step 4: التحقق من التوكن مع Firebase
# - استدعي verify_firebase_token(token)
# - لو فشل — ارجعي 401: {"success": False, "data": None, "message": "Invalid or expired token"}

# Step 5: جلب المستخدم من قاعدة البيانات
# - استخدمي firebase_uid من التوكن المتحقق
# - ابحثي في جدول users عن المستخدم بـ firebase_uid
# - لو ما لقيتيه — ارجعي 401: {"success": False, "data": None, "message": "User not found"}

# Step 6: إرفاق المستخدم بالطلب
# - request.state.user = user
# - هذا يخلي الراوترات تقدر توصل للمستخدم الحالي

# Step 7: تمرير الطلب
# - response = await call_next(request)
# - return response

# --- Dependencies ---
# - app/services/auth_service.py (verify_firebase_token)
# - app/database.py (SessionLocal, get_db)
# - app/models/user.py (User model)

# --- Notes ---
# - الـ middleware يشتغل على كل طلب قبل ما يوصل للراوتر
# - ارجعي دائماً الـ standard response format: { success: bool, data: any, message: str }
# - لا تنسي تغلقين الـ DB session بعد الاستخدام في الـ middleware
# - التوكن يجي من Firebase Authentication في الفرونت إند
