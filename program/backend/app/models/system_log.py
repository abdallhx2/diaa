# ============================================================
# File: models/system_log.py
# Purpose: موديل سجلات النظام — جدول system_logs في قاعدة البيانات
# Owner: فاطمة — Database Lead
# Branch: feature/backend-models
# Week: Week 1 — إنشاء جداول قاعدة البيانات
# ============================================================

# --- Required Imports ---
# import uuid
# from sqlalchemy import Column, String, DateTime, ForeignKey
# from sqlalchemy.dialects.postgresql import UUID, JSONB
# from sqlalchemy.sql import func
# from app.database import Base

# --- Implementation Steps ---

# Step 1: إنشاء كلاس SystemLog يرث من Base
# - __tablename__ = "system_logs"

# Step 2: تعريف الأعمدة (Columns)
# - id: UUID — Primary Key, default=uuid.uuid4
# - user_id: UUID — ForeignKey("users.id"), Nullable — المستخدم (Null لو العملية بدون مستخدم)
# - action: VARCHAR(100) — Not Null — نوع العملية (مثل: "login", "scan_text", "submit_quiz")
# - details: JSONB — Nullable — تفاصيل إضافية عن العملية، مثال:
#   {"method": "POST", "path": "/api/scan/ocr", "status_code": 200, "response_time_ms": 1500}
# - created_at: TIMESTAMP — Default=now() — وقت السجل

# --- Dependencies ---
# - app/database.py (Base class)
# - app/models/user.py (User model — FK, optional)

# --- Notes ---
# - يُستخدم من logging_middleware لتسجيل كل الطلبات
# - يُستخدم في GET /api/admin/logs لعرض سجلات النظام للمشرف
# - user_id اختياري عشان بعض الطلبات ما تحتاج تسجيل دخول (مثل health check)
# - details يحتوي على معلومات مفيدة للـ debugging والمراقبة
