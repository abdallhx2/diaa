# ============================================================
# File: routers/auth_router.py
# Purpose: نقاط نهاية المصادقة — تسجيل الدخول وإدارة الحسابات
# Owner: مشاعل — Backend Lead
# Branch: feature/backend-auth
# Week: Week 1-2 — نظام المصادقة والتسجيل
# ============================================================

# --- Required Imports ---
# from fastapi import APIRouter, Depends, HTTPException, Request
# from sqlalchemy.orm import Session
# from app.database import get_db
# from app.services.auth_service import verify_firebase_token, get_or_create_user, register_parent, add_child_to_parent
# from app.schemas.auth_schema import TokenVerifyRequest, RegisterParentRequest, AddChildRequest, UserResponse, LoginResponse
# from app.utils.helpers import format_response

# --- Implementation Steps ---

# Step 1: إنشاء الراوتر
# - router = APIRouter()

# Step 2: POST /verify-token — التحقق من توكن Firebase وإنشاء/جلب المستخدم
# - @router.post("/verify-token")
# - استلمي TokenVerifyRequest(token)
# - استدعي verify_firebase_token(token) للتحقق
# - استدعي get_or_create_user(firebase_uid, role, name, email) لإنشاء أو جلب المستخدم
# - ارجعي format_response(True, user_data, "تم التحقق بنجاح")
# - لو فشل التحقق — ارجعي 401

# Step 3: POST /register-parent — تسجيل حساب ولي أمر جديد
# - @router.post("/register-parent")
# - استلمي RegisterParentRequest(name, email, password, phone)
# - استدعي register_parent(data) لإنشاء الحساب في Firebase + DB
# - ارجعي format_response(True, parent_data, "تم تسجيل ولي الأمر بنجاح")
# - لو الإيميل موجود — ارجعي 400

# Step 4: POST /add-child — إضافة طفل لحساب ولي الأمر
# - @router.post("/add-child")
# - يحتاج مصادقة (المستخدم الحالي لازم يكون parent)
# - استلمي AddChildRequest(name, age, grade, learning_level)
# - parent_id = request.state.user.parent.id
# - استدعي add_child_to_parent(parent_id, child_data)
# - ارجعي format_response(True, child_data, "تم إضافة الطفل بنجاح")

# Step 5: GET /me — جلب بيانات المستخدم الحالي
# - @router.get("/me")
# - يحتاج مصادقة
# - user = request.state.user (موجود من auth_middleware)
# - ارجعي format_response(True, UserResponse.from_orm(user), "بيانات المستخدم")

# --- Dependencies ---
# - app/services/auth_service.py (جميع دوال المصادقة)
# - app/schemas/auth_schema.py (الـ schemas للتحقق من البيانات)
# - app/middleware/auth_middleware.py (التحقق من التوكن)
# - app/database.py (get_db)

# --- API Endpoints ---
# POST /api/auth/verify-token   — التحقق من التوكن (عام)
# POST /api/auth/register-parent — تسجيل ولي أمر (عام)
# POST /api/auth/add-child       — إضافة طفل (يحتاج مصادقة parent)
# GET  /api/auth/me              — بيانات المستخدم (يحتاج مصادقة)

# --- Notes ---
# - verify-token و register-parent ما يحتاجون مصادقة (public)
# - add-child و /me يحتاجون مصادقة
# - استخدمي دائماً format_response للـ standard response format
# - { success: bool, data: any, message: str }
