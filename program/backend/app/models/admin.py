# ============================================================
# File: models/admin.py
# Purpose: موديل المشرف — جدول admins في قاعدة البيانات
# Owner: فاطمة — Database Lead
# Branch: feature/backend-models
# Week: Week 1 — إنشاء جداول قاعدة البيانات
# ============================================================

# --- Required Imports ---
# import uuid
# from sqlalchemy import Column, String, ForeignKey
# from sqlalchemy.dialects.postgresql import UUID
# from sqlalchemy.orm import relationship
# from app.database import Base

# --- Implementation Steps ---

# Step 1: إنشاء كلاس Admin يرث من Base
# - __tablename__ = "admins"

# Step 2: تعريف الأعمدة (Columns)
# - id: UUID — Primary Key, default=uuid.uuid4
# - user_id: UUID — ForeignKey("users.id"), Unique, Not Null — ربط مع جدول المستخدمين
# - admin_level: VARCHAR(20) — Default='standard' — مستوى الصلاحيات (standard/super)

# Step 3: تعريف العلاقات (Relationships)
# - user = relationship("User", back_populates="admin")  — علاقة 1:1 مع User

# --- Dependencies ---
# - app/database.py (Base class)
# - app/models/user.py (User model — FK)

# --- Notes ---
# - admin_level يحدد مستوى الصلاحيات:
#   - 'standard': إدارة المحتوى والمستخدمين
#   - 'super': كل شيء + إعدادات النظام
# - user_id يكون Unique عشان كل مستخدم يكون عنده سجل مشرف واحد فقط
